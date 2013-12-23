//
//  ViewController.m
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import "ViewController.h"
#import "Chartboost.h"
#import "AppDelegate.h"
#if USE_REVMOB
#import <RevMobAds/RevMobAds.h>
#endif

@interface ViewController ()

@end

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
    CGRect frame = mBannerView.frame;
    mBannerView.hidden = YES;
    mBannerView.frame = frame;
    [self.view addSubview:mBannerView];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [mBannerView loadRequest:request];


    [self loadInterstitial];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showChartboost:(id)sender {
    [[Chartboost sharedChartboost] showInterstitial];
}

- (IBAction)showAdColony:(id)sender {
#ifdef APPORTABLE
    [AdColonyPublic playVideoAdForZone:@"vzb71d88b9fb3e49f189908a"];
#else
    [AdColonyPublic playVideoAdForZone:@"vz9fe8f499eaf04128aa506c"];
#endif
}

- (IBAction)showRevmob:(id)sender {
#if USE_REVMOB
    [[RevMobAds session] showFullscreen];
#else
    [sender setTitle:@"Revmob is disabled" forState:UIControlStateNormal];
#endif
}

- (IBAction)showInterstitial:(id)sender {
    mBannerView.hidden = NO;
    if (mInterstitial.isReady) {
        [mInterstitial presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
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

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    NSLog(@"**** MoPub Interstitial did load.");
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial
{

}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [self reloadInterstitial];
}

@end
