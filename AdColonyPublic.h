//
//  AdColonyPublic.h
//  adc-ios-sdk
//
//  Created by Ty Heath on 7/17/12.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark protocols

//so the new library can be simply dropped in without changing any implementation code
#define AdColonyAdministratorDelegate AdColonyDelegate
#define AdColonyAdministratorPublic   AdColonyPublic
#define AdColony                      AdColonyPublic
#define initAdministratorWithDelegate initAdColonyWithDelegate

//String constants used to set AdColony's logging level
extern NSString *const  AdColonyLoggingOn;
extern NSString *const  AdColonyLoggingOff; //Critical errors will still be logged

//ENUM FOR ZONE STATUS
typedef enum {
    ADCOLONY_ZONE_STATUS_NO_ZONE = 0,
    ADCOLONY_ZONE_STATUS_OFF,
    ADCOLONY_ZONE_STATUS_LOADING,
    ADCOLONY_ZONE_STATUS_ACTIVE,
    ADCOLONY_ZONE_STATUS_UNKNOWN
}  ADCOLONY_ZONE_STATUS;

//USER META DATA TYPES
extern NSString *const  ADC_SET_USER_AGE;                     //set the users age
extern NSString *const  ADC_SET_USER_INTERESTS;               //set the users interests
extern NSString *const  ADC_SET_USER_GENDER;                  //set the users gender
extern NSString *const  ADC_SET_USER_LATITUDE;                //set the users current latitude
extern NSString *const  ADC_SET_USER_LONGITUDE;               //set the users current longitude
extern NSString *const  ADC_SET_USER_ANNUAL_HOUSEHOLD_INCOME; //set the users annual house hold income in United States Dollars
extern NSString *const  ADC_SET_USER_MARITAL_STATUS;          //set the users marital status
extern NSString *const  ADC_SET_USER_EDUCATION;               //set the users education level
extern NSString *const  ADC_SET_USER_ZIPCODE;                 //set the users known zip code

//USER META DATA PRE-DEFINED VALUES
extern NSString *const  ADC_USER_MALE;                          //user is male
extern NSString *const  ADC_USER_FEMALE;                        //user is female

extern NSString *const  ADC_USER_SINGLE;                        //user is single
extern NSString *const  ADC_USER_MARRIED;                       //user is married

extern NSString *const  ADC_USER_EDUCATION_GRADE_SCHOOL;        //user has a basic grade school education and has not attended high school
extern NSString *const  ADC_USER_EDUCATION_SOME_HIGH_SCHOOL;    //user has completed at least some high school but has not received a diploma
extern NSString *const  ADC_USER_EDUCATION_HIGH_SCHOOL_DIPLOMA; //user has received a high school diploma but has not completed any college
extern NSString *const  ADC_USER_EDUCATION_SOME_COLLEGE;        //user has completed at least some college but doesn't have a college degree
extern NSString *const  ADC_USER_EDUCATION_ASSOCIATES_DEGREE;   //user has been awarded at least 1 associates degree, but doesn't have any higher level degrees
extern NSString *const  ADC_USER_EDUCATION_BACHELORS_DEGREE;    //user has been awarded at least 1 bachelors degree, but does not have a graduate level degree
extern NSString *const  ADC_USER_EDUCATION_GRADUATE_DEGREE;     //user has been awarded at least 1 masters or doctorate level degree

//--------********--------********--------********--------********--------********--------********--------*******

//The AdColonyDelegate protocol methods must be implemented in order to
//supply necessary configuration data about the app.
@protocol AdColonyDelegate <NSObject>

//Should return the application id provided by the AdColony website.
- ( NSString * ) adColonyApplicationID;

//Should return a dictionary mapping unique integer keys to zone ids.
//Provides a list of all ad zones in use throughout the app.
//Keys should be NSNumber objects with integer values (called the slot number).
//Values should be NSString objects with zone id values provided by the AdColony website.
//Do not use the same key for multiple zones.
- ( NSDictionary * ) adColonyAdZoneNumberAssociation;

@optional
//Should return the application version, which should be a numerical string, like @"1.1"
- ( NSString * ) adColonyApplicationVersion;

//Should return approrpriate constant string to determine the amount of AdColony console logging.
- ( NSString * ) adColonyLoggingStatus;

//Is called when the video zone is turned off or server fails to return videos
- ( void ) adColonyNoVideoFillInZone:( NSString * )zone;

//Is called when the video zone is ready to serve ads
- ( void ) adColonyVideoAdsReadyInZone:( NSString * )zone;

//is called when, temporarily or permanently, video ads have become
//unavailable for any reason
//requesting ads after this method returns and before a subsequent
//adColonyVideoAdsReadyInZone: callback with the same zone will produce no video ads
- ( void ) adColonyVideoAdsNotReadyInZone:( NSString * )zone;

//Should implement any app-specific code that should be run when AdColony has successfully rewarded
//virtual currency after a video. For example, contact a game server to determine the current total of
//virtual currency after the award.
- ( void ) adColonyVirtualCurrencyAwardedByZone:( NSString * )zone currencyName:( NSString * )name currencyAmount:( int )amount;

//Should implement any app-specific code that should be run when AdColony has failed to reward virtual
//currency after a video. For example, update the user interface with the results of calling
//virtualCurrencyAwardAvailable to disable or enable launching virtual currency videos.
- ( void ) adColonyVirtualCurrencyNotAwardedByZone:( NSString * )zone currencyName:( NSString * )name currencyAmount:( int )amount reason:( NSString * )reason;

//- ( NSString * ) adColonySupplementalVCParametersForZone:( NSString * )zone;

//- ( NSTimeInterval ) adColonyEndframeDuration;

@end

//--------********--------********--------********--------********--------********--------********--------*******

//Methods that should be implemented in classes that launch
//ads that will take over the screen, either on appearance, or on click.
@protocol AdColonyTakeoverAdDelegate <NSObject>

@optional
//Should implement any app-specific code that should be run when an ad that takes over the screen begins
//(for example, pausing a game if a video ad is being served in the middle of a session).
- ( void ) adColonyTakeoverBeganForZone:( NSString * )zone;

//Should implement any app-specific code that should be run when an ad that takes over the screen ends
//(for example, resuming a game if a video ad was served in the middle of a session).
- ( void ) adColonyTakeoverEndedForZone:( NSString * )zone withVC:( BOOL )withVirtualCurrencyAward;

//Should implement any app-specific code that should be run when AdColony is unable to play a video ad
//or virtual currency video ad
- ( void ) adColonyVideoAdNotServedForZone:( NSString * )zone;

@end

//--------********--------********--------********--------********--------********--------********--------*******

@interface AdColonyPublic : NSObject

//Call to initialize AdColony with an app id.  The app id is supplied by the clients.adcolony.com website.
+ ( void ) initAdColonyWithDelegate:( id<AdColonyDelegate>)del;

//Developers should set user information (if accurate information is available) for improved ad targeting and improved ad earnings
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_AGE withValue:@"25"];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_MARITAL_STATUS withValue: ADC_USER_MARRIED];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_GENDER withValue: ADC_USER_FEMALE];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_EDUCATION withValue: ADC_USER_EDUCATION_SOME_COLLEGE];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_ZIPCODE withValue: @"12345"];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_ANNUAL_HOUSE_HOLD_INCOME withValue: @"85000"];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_LATITUDE withValue: @"85.316"];
//Usage Example: [AdColonyPublic setUserMetadata: ADC_SET_USER_INTERESTS withValue: @"science, dating, racing, hiking"];
+ ( void ) setUserMetadata:( NSString * )meta_data_type withValue:( NSString * )value;

//Call this to give the SDK real time feedback about what a user is interested in.
//For example, if the user has started browsing the finance section of a news app, a developer should call:  [AdColonyPublic userInterestedIn:@"finance"]
//This will improve targeting and consequently improve earnings for your app.
//You can call this as often as you want with various topics that the user has engaged in within your app or as the user engages in them.
//Other Usage Examples:
// [AdColonyPublic userInterestedIn:@"facebook"];  //The user has posted a comment to Facebook for their friends to see
// [AdColonyPublic userInterestedIn:@"dating"];  //The user has clicked on a dating app within your 'more apps' section.
// [AdColonyPublic userInterestedIn:@"puzzles"];  //The user has opted to play a puzzle mini game within your app
+ ( void ) userInterestedIn:( NSString * )topic;

//Assign your own custom id to this user.  The SDK will keep this custom id permanently until you update it.
//The NSString must have a length of less than 128.
//You can retrieve the current custom id via '[AdColonyPublic getCustomID]'
//This custom id will also pass through to server-side v4vc callbacks to be used at your discretion.
+ ( void ) setCustomID:( NSString * )custom_id;

//This returns the device's custom id.
//The custom id will be the value previously set via '[AdColonyPublic setCustomID:(NSString*)]'
+ ( NSString * ) getCustomID;

//This returns the device's OpenUDID
//You can link your own copy of the OpenUDID library if desired, and it should return the same OpenUDID value
//For more details, please see the OpenUDID github page at: https://github.com/ylechelle/OpenUDID
//For server-side V4VC integrations, this is the value that will be sent as the URL parameter named 'open_udid'
+ ( NSString * ) getOpenUDID;

//This returns one of the unique device identifiers used by AdColony
//This identifier should remain constant across the lifetime of an iOS device
//The identifier is a SHA1 hash of the lowercase human readable MAC address of the device's WiFi interface
//For server-side V4VC integrations, this is the value that will be sent as the URL parameter named 'uid'
+ ( NSString * ) getUniqueDeviceID;

//This returns one of the unique device identifiers used by AdColony
//This identifier should remain constant across the lifetime of an iOS device
//The identifier is an ODIN-1 id ( which is based on a sha1 hash of the binary MAC address of the device's WiFi interface)
//For server-side V4VC integrations, this is the value that will be sent as the URL parameter named 'odin1'
+ ( NSString * ) getODIN1;

//This returns the new iOS 6 advertising id associated with this device.
//This value can change if the user restores their device
//Requires iOS 6.0+.  Returns nil if iOS version is less than 6.0
+ ( NSString * ) getAdvertisingIdentifier;

//This returns the new iOS 6 vendor id.
//Requires iOS 6.0+.  Returns nil if iOS version is less than 6.0
+ ( NSString * ) getVendorIdentifier;

// *************** PLAYING VIDEO ADS *************** //
+ ( void )  playVideoAdForSlot:( int )slotNumber;
+ ( void )  playVideoAdForZone:( NSString * )zoneID;

+ ( void ) playVideoAdForZone :( NSString * )zoneID withDelegate:( id<AdColonyTakeoverAdDelegate>)del
   withV4VCPrePopup           :( BOOL )showPrePopup andV4VCPostPopup:( BOOL )showPostPopup;

+ ( void ) playVideoAdForSlot :( int )slotNumber withDelegate:( id<AdColonyTakeoverAdDelegate>)del
   withV4VCPrePopup           :( BOOL )showPrePopup andV4VCPostPopup:( BOOL )showPostPopup;

+ ( void )  playVideoAdForZone:( NSString * )zoneID withDelegate:( id<AdColonyTakeoverAdDelegate>)del;
+ ( void )  playVideoAdForSlot:( int )slotNumber withDelegate:( id<AdColonyTakeoverAdDelegate>)del;

//Cancels any ad that is currently playing and returns control to the app.
//No earnings or v4vc rewards will occur.
//This is used by apps that must respond to an incoming event like a VoIP phone call.
+ ( void ) cancelAd;

//Check zone status to determine whether ads are ready to be played,
//or will be ready
+ ( ADCOLONY_ZONE_STATUS )  zoneStatusForZone:( NSString * )zoneID;
+ ( ADCOLONY_ZONE_STATUS )  zoneStatusForSlot:( int )slotNumber;

//Call to check if it is possible to get a virtual currency reward for playing a video in the zone.
//Returns NO if virtual currency hasn't been configured in the AdColony.com control panel
//Returns NO if the user's daily reward cap has been reached
//Returns NO if their are no ads available at this time
//Returns YES otherwise
+ ( BOOL )  virtualCurrencyAwardAvailableForZone:( NSString * )zoneID;
+ ( BOOL )  virtualCurrencyAwardAvailableForSlot:( int )slotNumber;

// Returns the remaining number of virtual currency awards that can possibly play in the near future.
// This is a function of daily caps, available ads, and other variables
// 0 means no rewards are available
+ ( int ) virtualCurrencyAwardsAvailableTodayInZone:( NSString * )zoneID;
+ ( int ) virtualCurrencyAwardsAvailableTodayInSlot:( int )slotNumber;

//Returns the name of the virtual currency rewarded on each video play in the zone
//The returned value will match the value set in the the adcolony.com control panel
//Note: You must first initialize AdColony using initAdColonyWithDelegate: before using this function
//Returns nil if the VC has not been set for the presenter's zone
+ ( NSString * )  getVirtualCurrencyNameForZone:( NSString * )zoneID;
+ ( NSString * )  getVirtualCurrencyNameForSlot:( int )slotNumber;

//Returns the amount of virtual currency rewarded on each video play in the zone
//The returned value will match the value set in the the adcolony.com control panel
//Note: You must first initialize AdColony using initAdColonyWithDelegate: before using this function
//Returns 0 if the VC has not been set for the zone
+ ( int ) getVirtualCurrencyRewardAmountForZone:( NSString * )zoneID;
+ ( int ) getVirtualCurrencyRewardAmountForSlot:( int )slotNumber;

//returns yes if an ad is currently running. Starting another ad when this is true is not
//advised
+ ( BOOL ) videoAdCurrentlyRunning;

//This method permanently turns off all AdColony ads. After this method is called, no ads will be played unless the app is deleted and reinstalled
+ ( void ) turnAllAdsOff;

//Calls to check if video ads for the zone are ready to be played.
//Returns YES if the video playlist has been filled and readied successfully.
//deprecated, use zoneStatusForZone: and zoneStatusForSlot: methods instead
//ADCOLONY_ZONE_STATUS_ACTIVE corresponds to a YES return value
//other status values correspond to NO
+ ( BOOL )  didVideoFinishLoadingForZone:( NSString * )zoneID;
+ ( BOOL )  didVideoFinishLoadingForSlot:( int )slotNumber;

// *************** FRACTIONAL CURRENCY SUPPORT *************** //
//Returns the number of videos that the user must watch to earn the designated reward for the specified currency
+ ( int ) getVideosPerReward:( NSString * )currency_name;

//Returns the number of videos that the user has watched towards their next reward
//Usage Example:  int remaining_videos = [AdColonyPublic getVideosPerReward:@"Gold"] - [AdColonyPublic getVideoCreditBalance:@"Gold"];
+ ( int ) getVideoCreditBalance:( NSString * )currency_name;

@end
