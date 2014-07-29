package com.mopub.nativeads;

import android.graphics.Rect;
import android.os.Handler;
import android.os.SystemClock;
import android.view.View;
import android.view.ViewTreeObserver;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import static android.view.ViewTreeObserver.OnPreDrawListener;

/**
 * Tracks views to determine when they've been viewable by the user, where viewability is defined as
 * having been at least X% on the screen for a continuous Y seconds. These values are set by the
 */
final class ImpressionTrackingManager {
    private ImpressionTrackingManager(){}

    private static final int PERIOD = 250;

    // Visible views currently polling to become viewable, subset of tracked views.
    private static final WeakHashMap<View, OnPreDrawListener> sWaitingViews =
            new WeakHashMap<View, OnPreDrawListener>(10);

    // Views waiting to become visible, subset of tracked views
    private static final WeakHashMap<View, NativeResponseWrapper> sPollingViews =
            new WeakHashMap<View, NativeResponseWrapper>(10);

    // Handler to delay starting tracking until the next render loop
    private static final Handler startHandler = new Handler();

    // Handler for polling visible views
    private static final Handler pollHandler = new Handler();

    // Runnable to run on each visibility loop
    private static final PollingRunnable pollingRunnable = new PollingRunnable();

    // Object to check actual visibility
    private static final VisibilityChecker visibilityChecker = new VisibilityChecker();

    /**
     * Tracks the given view for visibility.
     * <p/>
     * If the view is already being tracked this does nothing. To restart tracking you should call
     * stopTracking first.
     * <p/>
     * It is the caller's responsibility to avoid tracking views for ads that have already registered
     * an impression.
     */
    static void addView(final View view, final NativeResponse nativeResponse) {
        // Ignore if already being tracked.
        if (view == null || nativeResponse == null || isViewTracked(view)) {
            return;
        }

        // Posting the handler gives the view another render loop before checking visibility. Useful
        // because ListView likes to reparent a views after calling getView.
        final WeakReference<View> viewReference = new WeakReference<View>(view);
        startHandler.post(new Runnable() {
            @Override
            public void run() {
                final View view = viewReference.get();
                // Might have been untracked or GC'd
                if (view == null) {
                    return;
                }

                // Important to test viewability instead of just waiting
                if (visibilityChecker.isMostlyVisible(view,
                        nativeResponse.getImpressionMinPercentageViewed())) {
                    pollVisibleView(view, nativeResponse);
                } else {
                    waitForVisibility(view, nativeResponse);
                }
            }
        });
    }

    static boolean isViewTracked(final View view) {
        return sPollingViews.containsKey(view) || sWaitingViews.containsKey(view);
    }

    static void waitForVisibility(final View view, final NativeResponse nativeResponse) {
        // Remove from the polling list
        removePollingView(view);

        // Track draw events on this view to see when it becomes visible
        final WeakReference<View> viewReference = new WeakReference<View>(view);
        OnPreDrawListener preDrawListener = new OnPreDrawListener() {
            @Override
            public boolean onPreDraw() {
                final View view = viewReference.get();
                if (view == null) {
                    return true;
                }

                if (visibilityChecker.isMostlyVisible(view,
                        nativeResponse.getImpressionMinPercentageViewed())) {
                    pollVisibleView(view, nativeResponse);
                }
                return true;
            }
        };

        final ViewTreeObserver viewTreeObserver = view.getViewTreeObserver();
        if (viewTreeObserver.isAlive()) {
            viewTreeObserver.addOnPreDrawListener(preDrawListener);
            sWaitingViews.put(view, preDrawListener);
        }
    }

    static void pollVisibleView(final View view, final NativeResponse nativeResponse) {
        // Remove from waiting and add to polling
        removeWaitingView(view);
        sPollingViews.put(view, new NativeResponseWrapper(nativeResponse));

        // Make sure we're polling
        scheduleNextPoll();
    }

    static void scheduleNextPoll() {
        // Only schedule if there are no messages already scheduled.
        if (pollHandler.hasMessages(0)) {
            return;
        }

        pollHandler.postDelayed(pollingRunnable, PERIOD);
    }

    static void removeWaitingView(final View view) {
        final OnPreDrawListener listener = sWaitingViews.remove(view);
        if (listener != null) {
            final ViewTreeObserver viewTreeObserver = view.getViewTreeObserver();
            if (viewTreeObserver.isAlive()) {
                viewTreeObserver.removeOnPreDrawListener(listener);
            }
        }
    }

    static void removePollingView(View view) {
        sPollingViews.remove(view);
    }

    /**
     * Stops tracking a view, cleaning any pending tracking
     */
    static void removeView(View view) {
        removeWaitingView(view);
        removePollingView(view);
    }

    /**
     * Immediately clear all views. Useful for when we re-request ads for an ad placer
     */
    static void clearTracking() {
        // Stop waiting. Copy so that we can modify the map during iteration.
        final List<View> views = new ArrayList<View>(sWaitingViews.keySet());
        for (final View view : views) {
            removeWaitingView(view);
        }

        // Clear and stop the polling
        sPollingViews.clear();
        pollHandler.removeMessages(0);

        // Stop any views being currently added to tracking
        startHandler.removeMessages(0);
    }

    static class PollingRunnable implements Runnable {

        @Override
        public void run() {
            final ArrayList<View> views = new ArrayList<View>(sPollingViews.keySet());
            for (final View view : views) {
                final NativeResponseWrapper nativeResponseWrapper = sPollingViews.get(view);

                if (nativeResponseWrapper == null
                        || nativeResponseWrapper.mNativeResponse == null
                        || nativeResponseWrapper.mNativeResponse.getRecordedImpression()
                        || nativeResponseWrapper.mNativeResponse.isDestroyed()) {
                    removeView(view);
                    continue;
                }

                // If no longer visible, go back to a waiting state
                if (!visibilityChecker.isMostlyVisible(view,
                        nativeResponseWrapper.mNativeResponse.getImpressionMinPercentageViewed())) {
                    // Also removes from the visible list
                    waitForVisibility(view, nativeResponseWrapper.mNativeResponse);
                    continue;
                }

                // If it's been visible for a Y seconds, trigger the callback
                if (!visibilityChecker.hasRequiredTimeElapsed(
                        nativeResponseWrapper.mFirstVisibleTimestamp,
                        nativeResponseWrapper.mNativeResponse.getImpressionMinTimeViewed())) {
                    continue;
                }

                nativeResponseWrapper.mNativeResponse.recordImpression(view);
                removeView(view);
            }

            if (!sPollingViews.isEmpty()) {
                scheduleNextPoll();
            }
        }
    }

    // Visible for testing.
    static class VisibilityChecker {

        /**
         * Whether the visible time has elapsed from the start time. Easily mocked for testing.
         */
        static boolean hasRequiredTimeElapsed(final long startTimeMillis,
                final int impressionMinTimeViewed) {
            return SystemClock.uptimeMillis() - startTimeMillis >= impressionMinTimeViewed;
        }

        /**
         * Whether the view is at least certain % visible
         */
        static boolean isMostlyVisible(final View view, final int impressionMinPercentageViewed) {
            /*
             * ListView & GridView both call detachFromParent() for views that can be recycled for
             * new data. This is one of the rare instances where a view will have a null parent for
             * an extended period of time and will not be the main window.
             *
             * view.getGlobalVisibleRect() doesn't check that case, so if the view has visibility
             * of View.VISIBLE but has no parent it is likely in the recycle bin of a
             * ListView / GridView and not on screen.
             */
            if (view == null || view.getVisibility() != View.VISIBLE || view.getParent() == null) {
                return false;
            }

            final Rect clipRect = new Rect();
            if (!view.getGlobalVisibleRect(clipRect)) {
                // Not visible
                return false;
            }

            // % visible check - the cast is to avoid int overflow for large views.
            final long visibleViewArea = (long) clipRect.height() * clipRect.width();
            final long totalViewArea = (long) view.getHeight() * view.getWidth();

            if (totalViewArea <= 0) {
                return false;
            }

            return 100 * visibleViewArea >= impressionMinPercentageViewed * totalViewArea;
        }
    }

    static class NativeResponseWrapper {
        final NativeResponse mNativeResponse;
        long mFirstVisibleTimestamp;

        NativeResponseWrapper(final NativeResponse nativeResponse) {
            mNativeResponse = nativeResponse;
            mFirstVisibleTimestamp = SystemClock.uptimeMillis();
        }
    }

    @Deprecated // for testing
    static Map<View, OnPreDrawListener> getWaitingViews() {
        return sWaitingViews;
    }

    @Deprecated // for testing
    static Map<View, NativeResponseWrapper> getPollingViews() {
        return sPollingViews;
    }

    @Deprecated // for testing
    static Handler getStartHandler() {
        return startHandler;
    }
}
