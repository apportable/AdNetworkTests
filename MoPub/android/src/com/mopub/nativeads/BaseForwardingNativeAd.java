package com.mopub.nativeads;

import android.view.View;

import com.mopub.common.util.MoPubLog;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

abstract class BaseForwardingNativeAd implements NativeAdInterface {
    private static final int IMPRESSION_MIN_PERCENTAGE_VIEWED = 50;
    static final double MIN_STAR_RATING = 0;
    static final double MAX_STAR_RATING = 5;

    // Basic fields
    private String mMainImageUrl;
    private String mIconImageUrl;
    private String mClickDestinationUrl;
    private String mCallToAction;
    private String mTitle;
    private String mText;
    private Double mStarRating;

    // Impression logistics
    private final Set<String> mImpressionTrackers;
    private int mImpressionMinTimeViewed;

    // Extras
    private final Map<String, Object> mExtras;

    BaseForwardingNativeAd() {
        mImpressionMinTimeViewed = 1000;

        mImpressionTrackers = new HashSet<String>();
        mExtras = new HashMap<String, Object>();
    }

    // Getters
    /**
     * Returns the String url corresponding to the ad's main image.
     */
    @Override
    final public String getMainImageUrl() {
        return mMainImageUrl;
    }

    /**
     * Returns the String url corresponding to the ad's icon image.
     */
    @Override
    final public String getIconImageUrl() {
        return mIconImageUrl;
    }

    /**
     * Returns a Set<String> of all impression trackers associated with this native ad. Note that
     * network requests will automatically be made to each of these impression trackers when the
     * native ad is display on screen. See {@link BaseForwardingNativeAd#getImpressionMinPercentageViewed}
     * and {@link BaseForwardingNativeAd#getImpressionMinTimeViewed()} for relevant
     * impression-tracking parameters.
     */
    @Override
    final public Set<String> getImpressionTrackers() {
        return new HashSet<String>(mImpressionTrackers);
    }

    /**
     * Returns the String url that the device will attempt to resolve when the ad is clicked.
     */
    @Override
    final public String getClickDestinationUrl() {
        return mClickDestinationUrl;
    }

    /**
     * Returns the Call To Action String (i.e. "Download" or "Learn More") associated with this ad.
     */
    @Override
    final public String getCallToAction() {
        return mCallToAction;
    }

    /**
     * Returns the String corresponding to the ad's title.
     */
    @Override
    final public String getTitle() {
        return mTitle;
    }

    /**
     * Returns the String corresponding to the ad's body text.
     */
    @Override
    final public String getText() {
        return mText;
    }

    /**
     * For app install ads, this returns the associated star rating (on a 5 star scale) for the
     * advertised app. Note that this method may return null if the star rating was either never set
     * or invalid.
     */
    @Override
    final public Double getStarRating() {
        return mStarRating;
    }

    /**
     * Returns the minimum viewable percentage of the ad that must be onscreen for it to be
     * considered visible. See {@link BaseForwardingNativeAd#getImpressionMinTimeViewed()} for
     * additional impression tracking considerations.
     */
    @Override
    final public int getImpressionMinPercentageViewed() {
        return IMPRESSION_MIN_PERCENTAGE_VIEWED;
    }

    /**
     * Returns the minimum amount of time (in milliseconds) the ad that must be onscreen before an
     * impression is recorded. See {@link BaseForwardingNativeAd#getImpressionMinPercentageViewed()}
     * for additional impression tracking considerations.
     */
    @Override
    final public int getImpressionMinTimeViewed() {
        return mImpressionMinTimeViewed;
    }

    // Extras Getters
    /**
     * Given a particular String key, return the associated Object value from the ad's extras map.
     * See {@link BaseForwardingNativeAd#getExtras()} for more information.
     */
    @Override
    final public Object getExtra(final String key) {
        return mExtras.get(key);
    }

    @Override
    /**
     * Returns a copy of the extras map, reflecting additional ad content not reflected in any
     * of the above hardcoded setters. This is particularly useful for passing down custom fields
     * with MoPub's direct-sold native ads or from mediated networks that pass back additional
     * fields.
     */
    final public Map<String, Object> getExtras() {
        return new HashMap<String, Object>(mExtras);
    }

    // Setters
    final void setMainImageUrl(final String mainImageUrl) {
        mMainImageUrl = mainImageUrl;
    }

    final void setIconImageUrl(final String iconImageUrl) {
        mIconImageUrl = iconImageUrl;
    }

    final void setClickDestinationUrl(final String clickDestinationUrl) {
        mClickDestinationUrl = clickDestinationUrl;
    }

    final void setCallToAction(final String callToAction) {
        mCallToAction = callToAction;
    }

    final void setTitle(final String title) {
        mTitle = title;
    }

    final void setText(final String text) {
        mText = text;
    }

    final void setStarRating(final Double starRating) {
        if (starRating == null) {
            mStarRating = null;
        } else if (starRating >= MIN_STAR_RATING && starRating <= MAX_STAR_RATING) {
            mStarRating = starRating;
        } else {
            MoPubLog.d("Ignoring attempt to set invalid star rating (" + starRating + "). Must be "
                    + "between " + MIN_STAR_RATING + " and " + MAX_STAR_RATING + ".");
        }
    }

    final void addExtra(final String key, final Object value) {
        mExtras.put(key, value);
    }

    final void addImpressionTracker(final String url) {
        mImpressionTrackers.add(url);
    }

    final void setImpressionMinTimeViewed(final int impressionMinTimeViewed) {
        if (impressionMinTimeViewed >= 0) {
            mImpressionMinTimeViewed = impressionMinTimeViewed;
        }
    }

    // Event Handlers
    /**
     * Your base native ad subclass should implement this method if the network requires the developer
     * to prepare state for recording an impression before a view is rendered to screen.
     * This method is optional.
     */
    @Override
    public void prepareImpression(final View view) { }

    /**
     * Your base native ad subclass should implement this method if the network requires the developer
     * to explicitly record an impression of a view rendered to screen.
     * This method is optional.
     */
    @Override
    public void recordImpression() { }

    /**
     * Your base native ad subclass should implement this method if the network requires the developer
     * to explicitly handle click events of views rendered to screen.
     * This method is optional.
     */
    @Override
    public void handleClick(final View view) { }

    /**
     * Your base native ad subclass should implement this method if the network requires the developer
     * to destroy or cleanup their native ad when they are finished with it.
     * This method is optional.
     */
    @Override
    public void destroy() { }
}
