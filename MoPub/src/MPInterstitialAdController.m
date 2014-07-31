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

@implementation MPInterstitialAdController {
    MoPubInterstitial *_interstitial;
    ApportableMoPubInterstitialAdListener *_listener;
}

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
        dispatch_async(dispatch_get_main_android_queue(), ^{
            _interstitial = [[MoPubInterstitial alloc] initMoPubInterstitialWithActivity:[AndroidActivity currentActivity] adUnitId:adUnitId];
            _listener = [[ApportableMoPubInterstitialAdListener alloc] init];
            [_interstitial setInterstitialAdListener:_listener];
        });
        self.adUnitId = adUnitId;
    }
    return self;
}

- (void)dealloc
{
    [_interstitial dealloc];
    _interstitial = nil;

    [_listener dealloc];
    _listener = nil;

    _delegate = nil;

    [super dealloc];
}

- (void)loadAd
{
    dispatch_async(dispatch_get_main_android_queue(), ^{
        [_interstitial load];
    });
}

- (void)showFromViewController:(UIViewController *)controller
{
        [_interstitial show];
}

- (void)setDelegate:(id <MPInterstitialAdControllerDelegate>)delegate
{
        [_listener setDelegate:delegate];
        [_listener setController:self];
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
    __block BOOL ready = false;
    dispatch_sync(dispatch_get_main_android_queue(), ^{
        ready = [_interstitial isReady];
    });
    return ready;
}

- (void)setKeywords:(NSString *)keywords
{
    [_interstitial setKeywords:keywords];
}

- (void)setTesting:(BOOL)enabled
{
    [_interstitial setTesting:enabled];
}

@end
