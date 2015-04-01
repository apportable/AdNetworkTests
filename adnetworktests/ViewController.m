//
//  ViewController.m
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import "ViewController.h"
#import <Chartboost/Chartboost.h>
#import "AppDelegate.h"
#import "Flurry.h"
#import "FlurryAds.h"
#import <RevMobAds/RevMobAds.h>
#import "MPInterstitialAdController.h"
#import "SupersonicAdsAdvertiser.h"
#import "SupersonicAdsPublisher.h"

#define kSuperSonicAppKey @"2dea0439"
#define kSuperSonicUserId @"demo"

@interface ViewController () <AdColonyAdDelegate, MPInterstitialAdControllerDelegate, ChartboostDelegate, SSARewardedVideoDelegate>

@property (nonatomic) MPInterstitialAdController *interstitial;

@end
SupersonicAdsPublisher *ssaAg;

#ifdef APPORTABLE
NSString *adSpaceName = @"android_ad";
#else
NSString *adSpaceName = @"ios_ad";
#endif

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
#ifdef APPORTABLE
    mBannerView.adUnitID = @"a151ef2cfd3e120";
#else
    mBannerView.adUnitID = @"a151ef29a50747e";
#endif
    mBannerView.rootViewController = self;
    mBannerView.delegate = self;
    [self.view addSubview:mBannerView];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [mBannerView loadRequest:request];
    [VGVunglePub setDelegate:self];
    [self loadInterstitial];
    
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"0e60ee652c6c4badb36f912e82e51b81"];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];

    ssaAg = [SupersonicAdsPublisher sharedInstance];
    [ssaAg initRewardedVideoWithApplicationKey:kSuperSonicAppKey userId:kSuperSonicUserId delegate:self additionalParameters:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FlurryAds setAdDelegate:self];
    [FlurryAds fetchAdForSpace:adSpaceName frame:self.view.frame size:FULLSCREEN];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [FlurryAds setAdDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showChartboost:(id)sender {
    [Chartboost showInterstitial:CBLocationDefault];
    [Flurry logEvent:@"showChartboost"];
}

- (IBAction)showAdColony:(id)sender {
#ifdef APPORTABLE
//    Use the following line to show a non-rewarded video
    [AdColony playVideoAdForZone:@"vz8d2d1f791d8849fdbf" withDelegate:self];
//    Use the following line to show a rewarded video
//    [AdColony playVideoAdForZone:@"vzb71d88b9fb3e49f189908a" withDelegate:nil withV4VCPrePopup:YES andV4VCPostPopup:YES];
#else
    [AdColony playVideoAdForZone:@"vz9fe8f499eaf04128aa506c" withDelegate:nil];
#endif
    [Flurry logEvent:@"showAdColony"];
}

- (IBAction)showRevmob:(id)sender {
    [[RevMobAds session] showFullscreen];
    [Flurry logEvent:@"showRevMob"];
}

- (IBAction)showInterstitial:(id)sender {
    mBannerView.hidden = NO;
    if (mInterstitial.isReady) {
        [mInterstitial presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
    [Flurry logEvent:@"showAdMobInterstitial"];
}

- (IBAction)showVungleAd:(id)sender {
    if ([VGVunglePub adIsAvailable]) {
        [VGVunglePub playIncentivizedAd:self animated:YES showClose:YES userTag:nil];
//        [VGVunglePub playModalAd:self animated:YES];
        [Flurry logEvent:@"showVungle"];
    }
}

- (IBAction)showSuperSonicAd:(id)sender {
    NSLog(@"showSuperSonicAd");
    if (supersonic_rewarded_video_available) {
        // XXX
        [ssaAg showRewardedVideo];
    } else {
        NSLog(@"SuperSonicAds Video loading ...");
    }
}

- (IBAction)showFlurryAd:(id)sender {
    if ([FlurryAds adReadyForSpace:adSpaceName]) {
        [FlurryAds displayAdForSpace:adSpaceName onView:self.view];
    } else {
        // Fetch an ad
        [FlurryAds fetchAdForSpace:adSpaceName frame:self.view.frame size:FULLSCREEN];
    }
}

- (IBAction)showMoPubInterstitial:(id)sender {
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
    } else {
        [self.interstitial loadAd];
    }
}


- (IBAction)pressed:(id)sender {
//    mBannerView.hidden = !mBannerView.hidden;
    [mBannerView removeFromSuperview];

}

#pragma mark - Private

- (void)loadInterstitial
{
    mInterstitial = [[GADInterstitial alloc] init];
    mInterstitial.adUnitID = @"ca-app-pub-3320312069359444/9360936014";
    mInterstitial.delegate = self;
    [mInterstitial loadRequest:[GADRequest request]];
}

- (void)reloadInterstitial
{
    mInterstitial = nil;
    [self loadInterstitial];
}

#pragma mark - MPIntersitialAdControllerDelegate

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"**** MoPub Interstitial load failed.");
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    NSLog(@"**** MoPub Interstitial did load.");
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial {

}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self reloadInterstitial];
}

- ( void ) onAdColonyAdAttemptFinished:(BOOL)shown inZone:( NSString * )zoneID {
    NSLog(@"adcolony recieved onAdColonyAdAttemptFinished in app");
}

- ( void ) onAdColonyAdStartedInZone:( NSString * )zoneID {
    NSLog(@"adcolony recieved onAdColonyAdStartedInZone in app");
}


#pragma -mark GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    NSLog(@"admobview did receivedAD");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"admobview didFailToReceiveAdWithError");
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"admobview adViewWillPresentScreen");
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"admobview adViewWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"admobview adViewDidDismissScreen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"admobview adViewWillLeaveApplication");
}

#pragma mark vungle delegate methods
static BOOL finished_last_vungle_video_ = NO;

- (void)vungleMoviePlayed:(VGPlayData*)playData
{
    NSLog(@"vungleMoviePlayed: %@", playData);
    if ([playData playedFull]) {
        finished_last_vungle_video_ = YES;
    }
}

- (void)vungleStatusUpdate:(VGStatusData*)statusData
{
    NSLog(@"vungleStatusUpdate: %@", statusData);
}

- (void)vungleViewDidDisappear:(UIViewController*)viewController
{
    NSLog(@"vungleViewDidDisappear");
    if (finished_last_vungle_video_) {
        NSLog(@"vungle award coins!!!!");
        finished_last_vungle_video_ = NO;
    }
}

- (void)vungleViewDidDisappear:(UIViewController*)viewController willShowProductView:(BOOL)willShow
{
    NSLog(@"vungleViewDidDisappear:willShowProductView:");
    NSLog(@"vungleViewDidDisappear");
    if (finished_last_vungle_video_) {
        NSLog(@"vungle award coins!!!!");
        finished_last_vungle_video_ = NO;
    }
}

- (void)vungleViewWillAppear:(UIViewController*)viewController
{
    NSLog(@"vungleViewWillAppear");
}

- (void)vungleAppStoreWillAppear
{
    NSLog(@"vungleAppStoreWillAppear");
}

- (void)vungleAppStoreViewDidDisappear
{
    NSLog(@"vungleAppStoreViewDidDisappear");
}

#pragma mark SuperSonic SSARewardedVideoDelegate
static BOOL supersonic_rewarded_video_available = NO;

- (void)ssaRewardedVideoDidUpdateAdUnits:(NSDictionary *)adUnitsInfo
{
    supersonic_rewarded_video_available = YES;
    NSLog(@"ssaRewardedVideoDidUpdateAdUnits %@", adUnitsInfo);
}
- (void)ssaRewardedVideoNoMoreOffers
{
    supersonic_rewarded_video_available = NO;
    NSLog(@"ssaRewardedVideoNoMoreOffers");
}
- (void)ssaRewardedVideoDidFailInitWithError:(NSError *)error
{
    NSLog(@"ssaRewardedVideoDidFailInitWithError %@", error);
}
- (void)ssaRewardedVideoWindowWillOpen
{
    NSLog(@"ssaRewardedVideoWindowWillOpen");
}
- (void)ssaRewardedVideoWindowDidClose
{
    NSLog(@"ssaRewardedVideoWindowDidClose");
}
- (void)ssaRewardedVideoDidFailShowWithError:(NSError *)error
{
    NSLog(@"ssaRewardedVideoDidFailShowWithError %@", error);
}
- (void)ssaRewardedVideoCallback:(NSString *)name parameters:(NSDictionary *)parameters
{
    NSLog(@"ssaRewardedVideoCallback, %@, %@", name, parameters);
}
- (void)ssaRewardedVideoDidReceiveCredit:(NSDictionary *)creditInfo
{
    NSLog(@"ssaRewardedVideoDidReceiveCredit %@", creditInfo);
}

#pragma mark flurry ad delegate

- (BOOL) spaceShouldDisplay:(NSString*)adSpace interstitial:(BOOL)interstitial {
    if (interstitial) {
        // Pause app state here
    }
    // Continue ad display
    return YES;
}

- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    if (interstitial) {
        // Resume app state here
    }
}

#pragma mark MoPub delegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialDidLoadAd: %@", interstitial);
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialDidFailToLoadAd: %@", interstitial);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialWillAppear: %@", interstitial);
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialDidAppear: %@", interstitial);
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialWillDisappear: %@", interstitial);
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialDidDisappear: %@", interstitial);
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial
{
    NSLog(@"mopub interstitialDidExpire: %@", interstitial);
}

#if APPORTABLE
- (void)buttonUpWithEvent:(UIEvent *)event
{
    switch (event.buttonCode) {
        case UIEventButtonCodeBack:
            break;
        case UIEventButtonCodeMenu:
            break;
        default:
            break;
    }
}
#endif

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
@end
