#import <BridgeKit/JavaObject.h>

@interface MoPubInterstitial : JavaObject
- (MoPubInterstitial *)initMoPubInterstitialForAdUnitId:(NSString *)adUnitId;
- (void)load;
- (void)show;
- (BOOL)isReady;
@end