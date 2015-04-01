//
//  SupersonicAdsPublisher.h
//
//
//  Created by SSA on 2/22/12.
//  Copyright (c) 2012 SSA Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*----------------------------------------------------------------------------------------------*/
// SSARewardedVideoDelegate - Protocol
/*----------------------------------------------------------------------------------------------*/

@protocol SSARewardedVideoDelegate <NSObject , NSURLConnectionDelegate>

- (void)ssaRewardedVideoDidUpdateAdUnits:(NSDictionary *)adUnitsInfo;
- (void)ssaRewardedVideoNoMoreOffers;

@optional
- (void)ssaRewardedVideoDidFailInitWithError:(NSError *)error;
- (void)ssaRewardedVideoWindowWillOpen;
- (void)ssaRewardedVideoWindowDidClose;

- (void)ssaRewardedVideoDidFailShowWithError:(NSError *)error;
- (void)ssaRewardedVideoCallback:(NSString *)name parameters:(NSDictionary *)parameters;

- (void)ssaRewardedVideoDidReceiveCredit:(NSDictionary *)creditInfo;

@end

/*----------------------------------------------------------------------------------------------*/
// SSAInterstitialDelegate - Protocol
/*----------------------------------------------------------------------------------------------*/

@protocol SSAInterstitialDelegate <NSObject , NSURLConnectionDelegate>
- (void)ssaInitInterstitialSuccess;
- (void)ssaInitInterstitialFailWithError:(NSError *)error;
- (void)ssaInterstitialAdAvailable:(BOOL)available;
- (void)ssaShowInterstitialSuccess;
- (void)ssaShowInterstitialFailWithError:(NSError *)error;
- (void)ssaInterstitialAdClicked;
- (void)ssaInterstitialAdClosed;

@end

/*----------------------------------------------------------------------------------------------*/
// SSAOfferWallDelegate - Protocol
/*----------------------------------------------------------------------------------------------*/

@protocol SSAOfferWallDelegate <NSObject>

@optional

/**
 * Called each time the Offerwall successfully loads for the user
 **/
- (void)ssaOfferWallShowSuccess;

/**
 * Called each time the Offerwall fails to initialize or show
 * @param error - the error object with the failure info
 **/
- (void)ssaOfferWallShowFailedWithError:(NSError *)error;

/**
 * Called when the user closes the Offerwall
 **/
- (void)ssaOfferWallDidClose;

/** 
* Called each time the user completes an Offer Aware the user with the credit amount corresponding to the value of the ‘credits’ parameter.
* @param creditInfo - A dictionary with the following key-value pairs:
    @"credits" - (integer) The number of credits the user has Earned since the last ssaOfferwallDidReceiveCredit event that returned 'YES'. Note that the credits may represent multiple completions (see return parameter).
*   @"totalCredits" - (integer) The total number of credits ever earned by the user.
*   @"totalCreditsFlag" - (boolean) In some cases, we won’t be able to provide the exact amount of credits since the last event(specifically if the user clears the app’s data). In this case the ‘credits’ will be equal to the @"totalCredits", and this flag will be @(YES).
* @return The publisher should return a boolean stating if he handled this call (notified the user for example). if the return value is 'NO' the 'credits' value will be added to the next call.
**/
- (BOOL)ssaOfferWallDidReceiveCredit:(NSDictionary *)creditInfo;

/**
 * Called when the method ‘-getOfferWallCreditsWithApplicationKey:userId:delegate:’ failed to retrieve the users credit balance info.
 * @param error - the error object with the failure info
 **/
- (void)ssaOfferwallDidFailGettingCreditWithError:(NSError *)error;


- (void)ssaOfferWallCallback:(NSString *)name parameters:(NSDictionary *)parameters;

@end

/*----------------------------------------------------------------------------------------------*/
// superSonicAdsDelegate - Protocol
/*----------------------------------------------------------------------------------------------*/

@protocol SuperSonicAdsDelegate <NSObject>

@optional
- (void)ssaGenericFunctionResponse:(NSDictionary *)response withError:(NSError *)error;

@end

/*----------------------------------------------------------------------------------------------*/
// Publisher interface
/*----------------------------------------------------------------------------------------------*/
@interface SupersonicAdsPublisher : NSObject

@property (nonatomic, weak) id <SSARewardedVideoDelegate> rewardedVideoDelegate;
@property (nonatomic, weak) id <SSAInterstitialDelegate> interstitialDelegate;
@property (nonatomic, weak) id <SSAOfferWallDelegate> offerWallDelegate;
@property (nonatomic, weak) id <SuperSonicAdsDelegate> superSonicAdsDelegate;

/*-----------------------------------------------*/
// Publisher Singleton
/*-----------------------------------------------*/
+ (SupersonicAdsPublisher *)sharedInstance;
+ (SupersonicAdsPublisher *)sharedTestInstance;

/*-----------------------------------------------*/
// Brand Connect
/*-----------------------------------------------*/

/**
 * Initializes RewardedVideo for the specified application and user. Call once when the application is accessed by a new user.
 * upon success or failure, the SDK will call it's delegates' either -ssaRewardedVideoDidUpdateAdUnits (success), or -ssaRewardedVideoDidFailInitWithError (error)
 *
 * @param applicationKey - The application key that was generated by SupersonicAds when you registered your application. You can see this key on your application’s Settings page
 * @param userId - A unique identifier for the current user.
 * @param delegate - a delegate implementing the SSARewardedVideoDelegate protocol (usually set to "self")
 * @param additionalParameters - Additional (optional) initialization settings.
**/
- (void)initRewardedVideoWithApplicationKey:(NSString *)applicationKey userId:(NSString *)userId delegate:(id<SSARewardedVideoDelegate>)delegate additionalParameters:(NSDictionary *)parameters;

- (void)showRewardedVideo;

/*-----------------------------------------------*/
// Interstitial
/*-----------------------------------------------*/
- (void)initInterstitialWithApplicationKey:(NSString *)applicationKey userId:(NSString *)userId delegate:(id<SSAInterstitialDelegate>)delegate additionalParameters:(NSDictionary *)parameters;

- (void)showInterstitial;
- (void)forceShowInterstitial;
- (BOOL)isInterstitialAdAvailable;

/*-----------------------------------------------*/
// Offer Wall
/*-----------------------------------------------*/
- (void)showOfferWallWithApplicationKey:(NSString *)applicationKey userId:(NSString *)userId delegate:(id<SSAOfferWallDelegate>)delegate additionalParameters:(NSDictionary *)parameters;
- (void)getOfferWallCreditsWithApplicationKey:(NSString *)applicationKey userId:(NSString *)userId delegate:(id<SSAOfferWallDelegate>)delegate;

/*-----------------------------------------------*/
// Generic calls
/*-----------------------------------------------*/
+ (NSString *)getSDKVersion;

//- (void)callSupersonicAdsFunction:(NSString *)functionName withParameters:(NSDictionary *)parameters delegate:(id)delegate viewController:(id)viewController;

@end






