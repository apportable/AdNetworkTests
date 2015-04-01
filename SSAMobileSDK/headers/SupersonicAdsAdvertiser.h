//
//  SupersonicAdsAdvertiser.h
//  SupersonicAds
//
//  Created by SSA on 1/31/12.
//  Copyright (c) 2012 SSA All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SupersonicAdsAdvertiser : NSObject <NSURLConnectionDelegate>

+ (SupersonicAdsAdvertiser*)sharedInstance;

- (void)reportAppStarted;

@end
