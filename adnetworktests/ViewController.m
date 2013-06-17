//
//  ViewController.m
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import "ViewController.h"
#import "Chartboost.h"
#import <RevMobAds/RevMobAds.h>

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
    [[RevMobAds session] showFullscreen];
}

@end
