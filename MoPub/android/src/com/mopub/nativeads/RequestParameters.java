package com.mopub.nativeads;

import android.location.Location;
import android.text.TextUtils;

import java.util.EnumSet;

public final class RequestParameters {

    public enum NativeAdAsset {
        TITLE("title"),
        TEXT("text"),
        ICON_IMAGE("iconimage"),
        MAIN_IMAGE("mainimage"),
        CALL_TO_ACTION_TEXT("ctatext"),
        STAR_RATING("starrating");

        private final String mAssetName;

        private NativeAdAsset(String assetName) {
            mAssetName = assetName;
        }

        @Override
        public String toString() {
            return mAssetName;
        }
    }

    private final String mKeywords;
    private final Location mLocation;
    private final EnumSet<NativeAdAsset> mDesiredAssets;

    public final static class Builder {
        private String keywords;
        private Location location;
        private EnumSet<NativeAdAsset> desiredAssets;

        public final Builder keywords(String keywords) {
            this.keywords = keywords;
            return this;
        }

        public final Builder location(Location location) {
            this.location = location;
            return this;
        }

        // Specify set of assets used by this ad request. If not set, this defaults to all assets
        public final Builder desiredAssets(final EnumSet<NativeAdAsset> desiredAssets) {
            this.desiredAssets = EnumSet.copyOf(desiredAssets);
            return this;
        }

        public final RequestParameters build() {
            return new RequestParameters(this);
        }
    }

    private RequestParameters(Builder builder) {
        mKeywords = builder.keywords;
        mLocation = builder.location;
        mDesiredAssets = builder.desiredAssets;
    }

    public final String getKeywords() {
        return mKeywords;
    }

    public final Location getLocation() {
        return mLocation;
    }

    public final String getDesiredAssets() {
        String result = "";

        if (mDesiredAssets != null) {
            result = TextUtils.join(",", mDesiredAssets.toArray());
        }
        return result;
    }
}
