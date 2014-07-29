package com.mopub.mobileads.util;

import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

public class Interstitials {
    private Interstitials(){}

    public static boolean addCloseEventRegion(final ViewGroup viewGroup, final ViewGroup.LayoutParams layoutParams, final View.OnClickListener onClickListener) {
        if (viewGroup == null || viewGroup.getContext() == null) {
            return false;
        }

        // An area of the screen that will always lead to an expanded MRAID ad collapsing.
        final Button closeEventRegion = new Button(viewGroup.getContext());
        closeEventRegion.setVisibility(View.VISIBLE);
        closeEventRegion.setBackgroundColor(Color.TRANSPARENT);
        closeEventRegion.setOnClickListener(onClickListener);

        viewGroup.addView(closeEventRegion, layoutParams);

        return true;
    }
}
