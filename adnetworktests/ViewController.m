//
//  ViewController.m
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import "ViewController.h"
#import "Chartboost.h"
#if USE_REVMOB
#import <RevMobAds/RevMobAds.h>
#endif

@interface ViewController () <AdColonyAdDelegate>

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
    [self.view addSubview:mBannerView];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [mBannerView loadRequest:request];
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
    [AdColony playVideoAdForZone:@"vz8d2d1f791d8849fdbf" withDelegate:self];
#else
    [AdColony playVideoAdForZone:@"vz9fe8f499eaf04128aa506c" withDelegate:nil];
#endif
}

- (IBAction)showRevmob:(id)sender {
#if USE_REVMOB
    [[RevMobAds session] showFullscreen];
#else
    [sender setTitle:@"Revmob is disabled" forState:UIControlStateNormal];
#endif
}

- ( void ) onAdColonyAdAttemptFinished:(BOOL)shown inZone:( NSString * )zoneID {
    NSLog(@"adcolony recieved onAdColonyAdAttemptFinished in app");
}

- ( void ) onAdColonyAdStartedInZone:( NSString * )zoneID {
    NSLog(@"adcolony recieved onAdColonyAdStartedInZone in app");
}

@end
