#import "MoPubInterstitial.h"
#import <BridgeKit/JavaClass.h>
#import <BridgeKit/AndroidActivity.h>

@implementation MoPubErrorCode
+ (void)initializeJava
{
    [super initializeJava];
}

+ (NSString *)className
{
    return @"com.mopub.mobileads.MoPubErrorCode";
}
@end

@implementation ApportableMoPubInterstitialAdListener
+ (void)initializeJava
{
    [super initializeJava];

    [ApportableMoPubInterstitialAdListener registerCallback:@"onInterstitialLoaded" selector:@selector(onInterstitialLoaded:) returnValue:NULL arguments:[MoPubInterstitial className], nil];

    [ApportableMoPubInterstitialAdListener registerCallback:@"onInterstitialFailed" selector:@selector(onInterstitialFailed:withErrorCode:) returnValue:NULL arguments:[MoPubInterstitial className], [MoPubErrorCode className], nil];

    [ApportableMoPubInterstitialAdListener registerCallback:@"onInterstitialShown" selector:@selector(onInterstitialShown:) returnValue:NULL arguments:[MoPubInterstitial className], nil];

    [ApportableMoPubInterstitialAdListener registerCallback:@"onInterstitialClicked" selector:@selector(onInterstitialClicked:) returnValue:NULL arguments:[MoPubInterstitial className], nil];

    [ApportableMoPubInterstitialAdListener registerCallback:@"onInterstitialDismissed" selector:@selector(onInterstitialDismissed:) returnValue:NULL arguments:[MoPubInterstitial className], nil];
}

+ (void)loadJavaClass:(JavaObjectClassContext *)context
{
    [context registerInstanceMethod:@"onInterstitialLoaded" returnValue:NULL arguments:[MoPubInterstitial className], nil];

    [context registerInstanceMethod:@"onInterstitialFailed" returnValue:NULL arguments:[MoPubInterstitial className], [MoPubErrorCode className], nil];

    [context registerInstanceMethod:@"onInterstitialShown" returnValue:NULL arguments:[MoPubInterstitial className], nil];

    [context registerInstanceMethod:@"onInterstitialClicked" returnValue:NULL arguments:[MoPubInterstitial className], nil];

    [context registerInstanceMethod:@"onInterstitialDismissed" returnValue:NULL arguments:[MoPubInterstitial className], nil];
}

+ (NSString *)interfaceName
{
    return @"com.mopub.mobileads.MoPubInterstitial$InterstitialAdListener";
}

+ (NSString *)className
{
    return @"com.mopub.mobileads.MoPubInterstitial.InterstitialAdListener";
}

+ (NSArray *)interfaces
{
    return [NSArray arrayWithObjects:[ApportableMoPubInterstitialAdListener interfaceName], nil];
}

- (void)onInterstitialLoaded:(MoPubInterstitial *)interstitial
{
}

- (void)onInterstitialFailed:(MoPubInterstitial *)interstitial withErrorCode:(MoPubErrorCode *)errorCode
{
}

- (void)onInterstitialShown:(MoPubInterstitial *)interstitial
{
}

- (void)onInterstitialClicked:(MoPubInterstitial *)interstitial
{
}

- (void)onInterstitialDismissed:(MoPubInterstitial *)interstitial
{
}

@end


@implementation MoPubInterstitial
+ (void)initializeJava
{
    [super initializeJava];

    [MoPubInterstitial registerConstructorWithSelector:@selector(initMoPubInterstitialWithActivity:adUnitId:) arguments:[AndroidActivity className], [NSString className], nil];

    [MoPubInterstitial registerInstanceMethod:@"setInterstitialAdListener" selector:@selector(setInterstitialAdListener:) returnValue:NULL arguments:[ApportableMoPubInterstitialAdListener interfaceName], nil];

    [MoPubInterstitial registerInstanceMethod:@"load" selector:@selector(load)];

    [MoPubInterstitial registerInstanceMethod:@"show" selector:@selector(show) returnValue:[JavaClass boolPrimitive]];

    [MoPubInterstitial registerInstanceMethod:@"isReady" selector:@selector(isReady) returnValue:[JavaClass boolPrimitive]];

}

+ (NSString *)className
{
    return @"com.mopub.mobileads.MoPubInterstitial";
}
@end
