//
//  AppDelegate.m
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import "AppDelegate.h"
#import <Chartboost/Chartboost.h>
#import "Flurry.h"
#import "FlurryAds.h"
#import <RevMobAds/RevMobAds.h>
#import "VGVunglePub.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef ANDROID
    [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenBestEmulatedMode];
#endif
    //Chartboost config
#ifdef APPORTABLE
    [Chartboost startWithAppId:@"5125833216ba47017000000c" appSignature:@"cb4f77e909672121e3011eae23f0be0887659aeb" delegate:nil];
#else
    [Chartboost startWithAppId:@"5125786a17ba476d5000002d" appSignature:@"6c43009ec3ebccbd2ce7053e3313a78b4a3f4c07" delegate:nil];
#endif

    //Revmob config
#ifdef APPORTABLE
    [RevMobAds startSessionWithAppID:@"51bf7537795f1df64d000005"];
#else
    [RevMobAds startSessionWithAppID:@"515e0b9e1a112b1c0200000f"];
#endif
    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;

    
    //AdColony config
    NSArray *zoneIds = nil;
    NSString *adColonyAppId = nil;
#ifdef APPORTABLE
    zoneIds = @[@"vzb71d88b9fb3e49f189908a", @"vz8d2d1f791d8849fdbf"];
    adColonyAppId = @"app3d6b109836f044908283cd";
#else
    zoneIds = @[@"vz9fe8f499eaf04128aa506c"];
    adColonyAppId = @"appcd4c2ca4996f4838b6bdfd";
#endif
    [AdColony configureWithAppID:adColonyAppId zoneIDs:zoneIds delegate:self logging:YES];
#ifdef APPORTABLE
    [Flurry startSession:@"29KWMFWFYNVNYCMR7JX3"];
#else
    [Flurry startSession:@"PNQM2PVNTDW5JXQ885DG"];
#endif
    [Flurry setShowErrorInLogEnabled:YES];
    [Flurry setDebugLogEnabled:YES];
    
    
    VGUserData *data = [[VGUserData alloc] init];
    data.age = 27;
    data.gender = VGGenderFemale;
    [VGVunglePub startWithPubAppID:@"vungleTest" userData:data];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [FlurryAds initialize:self.window.rootViewController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- AdColonyDelegate methods

- ( void ) onAdColonyV4VCReward:(BOOL)success currencyName:(NSString*)currencyName currencyAmount:(int)amount inZone:(NSString*)zoneID {
    NSLog(@"adcolony recieved onAdColonyV4VCReward in app success: %d currencyName: %@ currencyAmount: %d", success, currencyName, amount);
}

@end
