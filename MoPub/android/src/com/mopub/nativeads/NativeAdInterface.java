package com.mopub.nativeads;

import android.view.View;

import java.util.Map;
import java.util.Set;

interface NativeAdInterface {
    // Getters
    String getMainImageUrl();
    String getIconImageUrl();
    String getClickDestinationUrl();
    String getCallToAction();
    String getTitle();
    String getText();
    Double getStarRating();

    Set<String> getImpressionTrackers();
    int getImpressionMinPercentageViewed();
    int getImpressionMinTimeViewed();

    // Extras Getters
    Object getExtra(final String key);
    Map<String, Object> getExtras();

    // Event Handlers
    void prepareImpression(final View view);
    void recordImpression();
    void handleClick(final View view);
    void destroy();
}
