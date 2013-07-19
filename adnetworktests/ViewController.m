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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showChartboost:(id)sender {
    [[Chartboost sharedChartboost] showInterstitial];
}

- (IBAction)showRevmob:(id)sender {
#if USE_REVMOB
    [[RevMobAds session] showFullscreen];
#else
    [sender setTitle:@"Revmob is disabled" forState:UIControlStateNormal];
#endif
}

@end
