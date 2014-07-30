#import <BridgeKit/JavaObject.h>
#import <BridgeKit/AndroidActivity.h>
#import "MPInterstitialAdController.h"

@interface MoPubErrorCode : JavaObject
- (NSString *)description;
@end

@interface ApportableMoPubInterstitialAdListener : JavaObject
- (void)setDelegate:(id <MPInterstitialAdControllerDelegate>) delegate;
@property (nonatomic, assign) MPInterstitialAdController *controller;
@end

@interface MoPubInterstitial : JavaObject
@property (nonatomic, assign) ApportableMoPubInterstitialAdListener *interstitialAdListener;
@property (nonatomic, assign) NSString *keywords;
@property (nonatomic, assign) BOOL testing;
- (MoPubInterstitial *)initMoPubInterstitialWithActivity:(AndroidActivity *)activity adUnitId:(NSString *)adUnitId;
- (void)load;
- (BOOL)show;
- (BOOL)isReady;
@end
