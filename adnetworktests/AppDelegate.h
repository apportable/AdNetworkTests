//
//  AppDelegate.h
//  adnetworktests
//
//  Created by Glenna Buford on 6/17/13.
//  Copyright (c) 2013 Glenna Buford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdColony/AdColony.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AdColonyDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
