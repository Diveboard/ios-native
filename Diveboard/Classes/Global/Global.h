//
//  Global.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
//#import <BugSense-iOS/BugSenseController.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginResult.h"
#import "DiveListViewController.h"
#import "DiveEditViewController.h"


#define AUTH_TOKEN              @"9P+7PrBkhMBfrYrqk03g362xiwe8ETL0bJCubq7V8Bs="
#define API_KEY                 @"vr7J6gUuy4ChTUUp2TJybFk"
#define FLAVOUR                 @"mobile"
#define SERVER_URL              @"https://www.diveboard.com"
//#define SERVER_URL              @"http://stage.diveboard.com"

#define kLoginMode              @"loginMode"
#define kLoginModeNative        @"nativeLoginMode"
#define kLoginModeFB            @"facebookLoginMode"
#define kLoginUserInfo          @"loginUserInformation"
#define kLoginUserID            @"loginUserID"
#define kDiveboardUnit          @"diveboardUnit"
#define kPictureQuality         @"pictureQuality"
#define kDownloadMethod         @"downloadMethod"
#define kSpotDBUpdateDate       @"spotDBUpdateDate"

#define kAPP_STORE_ID           @"497339427"

#define kLoadedDiveData(userid) [NSString stringWithFormat:@"userid_%@_loadedDiveData", userid]

#define kMainDefaultColor [UIColor colorWithRed:1.0f green:0.68f blue:0.1f alpha:1.0f]
#define getStringValue(v)     (v == nil || [v isEqual:[NSNull null]] || [v isEqual:@"<null>"] || [v isEqual:@"(null)"]  || [v isEqual:@"Null"] ? @"" : [NSString stringWithFormat:@"%@", v])
#define getIntegerValue(v)    (v == [NSNull null] || v == nil) ? 0 : [v integerValue]
#define getDoubleValue(v)     (v == [NSNull null] || v == nil) ? 0 : [v doubleValue]

#define kDefaultFontName        @"Quicksand-Regular"
#define kDefaultFontNameBold    @"Quicksand-Bold"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define isPortrateScreen ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown )

#define kLoginResultPlistFileName @"loginResult.plist"

#define REQUEST_TIME_OUT 15.0


#pragma mark -

@interface Global : NSObject

@end


#pragma mark - UserSettings Class
enum {
    UserSettingUnitTypeImperial = 0,
    UserSettingUnitTypeMetric = 1
};
typedef NSUInteger UserSettingUnitType;

enum {
    UserSettingPictureQualityTypeMedium = 0,
    UserSettingPictureQualityTypeHigh = 1
};

typedef NSUInteger UserSettingPictureQualityType;

enum {
    UserSettingDownloadTypeWifi = 0,
    UserSettingDownloadTypeWWAN = 1
};

typedef NSUInteger UserSettingDownloadType;


@interface UserSettings : NSObject

@property (nonatomic) int unit;
@property (nonatomic) int pictureQuality;
@property (nonatomic) int downloadMethod;

@end

#pragma mark - AppManager class

//@class LoginResult;
@interface AppManager : NSObject
{
    NSMutableDictionary *loadedDivesofMaster;
    NSMutableDictionary *loadedDivesofSudo;
    
}

+ (AppManager *)sharedManager;

@property (nonatomic, strong) LoginResult *loginResult;
@property (nonatomic, strong) FBSession   *fbSession;
@property (nonatomic, strong) NSMutableDictionary *loadedDives;
@property (nonatomic)         int           currentSudoID;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSMutableArray* remainingPictures;
@property (nonatomic, strong) UserSettings* userSettings;
@property (nonatomic, strong) DiveListViewController* diveListVC;
@property (nonatomic, strong) DiveEditViewController* diveEditVC;

-(void) getUserData:(NSDictionary*)loginResultData;

//-(void) startPreloadDiveData;

@end

#pragma mark - GlobalMethods Class

@interface GlobalMethods : NSObject

+ (void) setRoundView:(UIView *)view cornorRadious:(float)rad borderColor:(UIColor *)color border:(float)border;

+ (NSString *) encodeValueToFloat:(NSString *)value;
+ (void)setBorderView:(UIView*)view borderColor:(UIColor *)color borderWidth:(float)borderWidth position:(NSString*)position;


@end






