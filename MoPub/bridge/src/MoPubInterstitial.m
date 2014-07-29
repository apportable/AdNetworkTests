#import "MoPubInterstitial.h"
#import <BridgeKit/JavaClass.h>

@implementation MoPubInterstitial
+ (void)initializeJava
{
    [super initializeJava];

    [MoPubInterstitial registerConstructorWithSelector:@selector(initMoPubInterstitialForAdUnitId:) arguments:[NSString className], nil];

    [MoPubInterstitial registerInstanceMethod:@"load" selector:@selector(load)];

    [MoPubInterstitial registerInstanceMethod:@"show" selector:@selector(show)];

    [MoPubInterstitial registerInstanceMethod:@"isReady" selector:@selector(isReady) returnValue:[JavaClass boolPrimitive]];
}
+ (NSString *)className
{
    return @"com.apportable.ApportableMoPubInterstitial";
}
@end
