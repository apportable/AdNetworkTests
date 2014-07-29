package com.mopub.nativeads;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.mopub.common.util.MoPubLog;

import static android.view.View.GONE;
import static android.view.View.OnClickListener;
import static android.view.View.VISIBLE;
import static com.mopub.nativeads.MoPubNative.MoPubNativeListener;

class NativeAdViewHelper {
    private NativeAdViewHelper() {}

    static View getAdView(View convertView,
                          final ViewGroup parent,
                          final Context context,
                          final NativeResponse nativeResponse,
                          final ViewBinder viewBinder,
                          final MoPubNativeListener moPubNativeListener) {

        if (viewBinder == null) {
            MoPubLog.d("ViewBinder is null, returning empty view.");
            return new View(context);
        }

        if (convertView == null) {
            convertView = createConvertView(context, parent, viewBinder);
        }

        final NativeViewHolder nativeViewHolder = getOrCreateNativeViewHolder(convertView, viewBinder);

        // Clean up previous state of view
        removeClickListeners(convertView, nativeViewHolder);
        ImpressionTrackingManager.removeView(convertView);

        if (nativeResponse == null) {
            // If we don't have content for the view, then hide the view for now
            MoPubLog.d("NativeResponse is null, returning hidden view.");
            convertView.setVisibility(GONE);
        } else if (nativeResponse.isDestroyed()) {
            MoPubLog.d("NativeResponse is destroyed, returning hidden view.");
            convertView.setVisibility(GONE);
        } else if (nativeViewHolder == null) {
            MoPubLog.d("Could not create NativeViewHolder, returning hidden view.");
            convertView.setVisibility(GONE);
        } else {
            populateConvertViewSubViews(convertView, nativeViewHolder, nativeResponse, viewBinder);
            attachClickListeners(convertView, nativeViewHolder, nativeResponse);
            convertView.setVisibility(VISIBLE);
            nativeResponse.prepareImpression(convertView);
        }

        return convertView;
    }

    private static View createConvertView(final Context context, final ViewGroup parent, final ViewBinder viewBinder) {
        final View convertView = LayoutInflater
                .from(context)
                .inflate(viewBinder.layoutId, parent, false);
        return convertView;
    }

    static NativeViewHolder getOrCreateNativeViewHolder(final View convertView, final ViewBinder viewBinder) {
        // Create view holder and put it in the view tag
        Object object = ImageViewService.getViewTag(convertView);
        if (object == null || !(object instanceof NativeViewHolder)) {
            final NativeViewHolder nativeViewHolder = NativeViewHolder.fromViewBinder(convertView, viewBinder);
            ImageViewService.setViewTag(convertView, nativeViewHolder);
            return nativeViewHolder;
        } else {
            return (NativeViewHolder) object;
        }
    }

    private static void populateConvertViewSubViews(final View convertView,
            final NativeViewHolder nativeViewHolder,
            final NativeResponse nativeResponse,
            final ViewBinder viewBinder) {
        nativeViewHolder.update(nativeResponse);
        nativeViewHolder.updateExtras(convertView, nativeResponse, viewBinder);
    }

    private static void removeClickListeners(final View view,
                                             final NativeViewHolder nativeViewHolder) {
        if (view == null) {
            return;
        }

        view.setOnClickListener(null);
        setCtaClickListener(nativeViewHolder, null);
    }

    private static void attachClickListeners(final View view,
            final NativeViewHolder nativeViewHolder,
            final NativeResponse nativeResponse) {
        if (view == null || nativeResponse == null) {
            return;
        }

        final NativeViewClickListener nativeViewClickListener
                = new NativeViewClickListener(nativeResponse);
        view.setOnClickListener(nativeViewClickListener);
        setCtaClickListener(nativeViewHolder, nativeViewClickListener);
    }

    private static void setCtaClickListener(final NativeViewHolder nativeViewHolder,
            final NativeViewClickListener nativeViewClickListener) {
        if (nativeViewHolder == null || nativeViewClickListener == null) {
            return;
        }

        // CTA widget could be a button and buttons don't inherit click listeners from parents
        // So we have to set it manually here if so
        if (nativeViewHolder.callToActionView != null && nativeViewHolder.callToActionView instanceof Button) {
            nativeViewHolder.callToActionView.setOnClickListener(nativeViewClickListener);
        }
    }

    static class NativeViewClickListener implements OnClickListener {
        private final NativeResponse mNativeResponse;

        NativeViewClickListener(final NativeResponse nativeResponse) {
            mNativeResponse = nativeResponse;
        }

        @Override
        public void onClick(View view) {
            mNativeResponse.handleClick(view);
        }
    }
}
