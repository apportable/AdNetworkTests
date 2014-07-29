package com.apportable;

import android.util.Log;

import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.mobileads.MoPubInterstitial.InterstitialAdListener;

import com.apportable.activity.VerdeActivity;

public class ApportableMoPubInterstitial implements InterstitialAdListener {
    private MoPubInterstitial mInterstitial;
    private String mAdUnitId;
    private static final String TAG = "ApportableMoPubInterstitial";

    public ApportableMoPubInterstitial(String adUnitId) {
        mAdUnitId = adUnitId;
        final String fAdUnitId = adUnitId;
        VerdeActivity.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mInterstitial = new MoPubInterstitial(VerdeActivity.getActivity(), fAdUnitId);
                mInterstitial.setInterstitialAdListener(ApportableMoPubInterstitial.this);
            }
        });
    }

    public void load() {
        VerdeActivity.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mInterstitial.load();
            }
        });
    }

    public void show() {
        VerdeActivity.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mInterstitial != null && mInterstitial.isReady()) {
                    mInterstitial.show();
                } else {
                    Log.e(TAG, "Interstitial was not ready. Try reloading.");
                }
            }
        });
    }

    public boolean isReady() {
        return mInterstitial.isReady();
    }

    @Override
    public void onInterstitialLoaded(MoPubInterstitial interstitial) {}

    @Override
    public void onInterstitialFailed(MoPubInterstitial interstitial, MoPubErrorCode errorCode) {}

    @Override
    public void onInterstitialShown(MoPubInterstitial interstitial) {}

    @Override
    public void onInterstitialClicked(MoPubInterstitial interstitial) {}

    @Override
    public void onInterstitialDismissed(MoPubInterstitial interstitial) {}
}