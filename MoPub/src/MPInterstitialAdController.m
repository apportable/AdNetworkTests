//
//  MPInterstitialAdController.m
//  MoPub
//
//  Created by Glenna Buford on 7/28/13.
//  Copyright (c) 2014 Apportable. All rights reserved.
//



#import "MPInterstitialAdController.h"
#import "MoPubInterstitial.h"

@implementation MPInterstitialAdController : UIViewController {
    MoPubInterstitial *_interstitial;
}

// @property (nonatomic, assign) id<MPInterstitialAdControllerDelegate> delegate;
// @property (nonatomic, copy) NSString *adUnitId;
// @property (nonatomic, copy) NSString *keywords;
// @property (nonatomic, copy) CLLocation *location;
// @property (nonatomic, assign, getter=isTesting) BOOL testing;
// @property (nonatomic, assign, readonly) BOOL ready;

+ (MPInterstitialAdController *)interstitialAdControllerForAdUnitId:(NSString *)adUnitId
{
    MPInterstitialAdController *interstitialController = [[MPInterstitialAdController alloc] initWithAdUnitId:adUnitId];
    return interstitialController;
}

- (MPInterstitialAdController *)initWithAdUnitId:(NSString *)adUnitId
{
    self = [super init];
    if (self)
    {
        _interstitial = [[MoPubInterstitial alloc] initMoPubInterstitialForAdUnitId:adUnitId];
    }
    return self;
}

- (void)loadAd
{
    [_interstitial load];
}

- (void)showFromViewController:(UIViewController *)controller
{
    [_interstitial show];
}

+ (void)removeSharedInterstitialAdController:(MPInterstitialAdController *)controller
{

}

+ (NSMutableArray *)sharedInterstitialAdControllers
{
    return nil;
}

- (BOOL)ready
{
    return [_interstitial isReady];
}

@end
