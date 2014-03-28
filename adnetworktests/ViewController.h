//
//  ViewController.h
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import <AdColony/AdColony.h>
#import "VGVunglePub.h"
@interface ViewController : UIViewController <GADInterstitialDelegate, GADBannerViewDelegate, VGVunglePubDelegate> {
    GADBannerView *mBannerView;
    GADInterstitial *mInterstitial;
}

@end
