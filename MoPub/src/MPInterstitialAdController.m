//
//  MPInterstitialAdController.m
//  MoPub
//
//  Created by Glenna Buford on 7/28/13.
//  Copyright (c) 2014 Apportable. All rights reserved.
//



#import "MPInterstitialAdController.h"
#import "MoPubInterstitial.h"
#import <BridgeKit/AndroidActivity.h>

@implementation MPInterstitialAdController : UIViewController {
    MoPubInterstitial *_interstitial;
    ApportableMoPubInterstitialAdListener *_listener;
}

// @property (nonatomic, assign) id<MPInterstitialAdControllerDelegate> delegate;
// @property (nonatomic, copy) NSString *adUnitId;
// @property (nonatomic, copy) NSString *keywords;
// @property (nonatomic, copy) CLLocation *location;
// @property (nonatomic, assign, getter=isTesting) BOOL testing;
// @property (nonatomic, assign, readonly) BOOL ready;

+ (MPInterstitialAdController *)interstitialAdControllerForAdUnitId:(NSString *)adUnitId
{
    MPInterstitialAdController *interstitialController = [[[MPInterstitialAdController alloc] initWithAdUnitId:adUnitId] autorelease];
    return interstitialController;
}

- (MPInterstitialAdController *)initWithAdUnitId:(NSString *)adUnitId
{
    self = [super init];
    if (self)
    {
        dispatch_sync(dispatch_get_main_android_queue(), ^{
            _interstitial = [[MoPubInterstitial alloc] initMoPubInterstitialWithActivity:[AndroidActivity currentActivity] adUnitId:adUnitId];
            _listener = [[ApportableMoPubInterstitialAdListener alloc] init];
            [_interstitial setInterstitialAdListener:_listener];
        });
    }
    return self;
}

- (void)dealloc
{
    [_interstitial dealloc];
    _interstitial = nil;

    [_listener dealloc];
    _listener = nil;
}

- (void)loadAd
{
    dispatch_async(dispatch_get_main_android_queue(), ^{
        [_interstitial load];
    });
}

- (void)showFromViewController:(UIViewController *)controller
{
    dispatch_async(dispatch_get_main_android_queue(), ^{
        [_interstitial show];
    });
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
