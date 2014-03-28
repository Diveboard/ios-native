//
//  Global.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginResult.h"


#define AUTH_TOKEN              @"9P+7PrBkhMBfrYrqk03g362xiwe8ETL0bJCubq7V8Bs="
#define API_KEY                 @"iuADSyYZUDqwe986wq21"
#define FLAVOUR                 @"mobile"
//#define SERVER_URL              @"http://www.divaboard.com"
#define SERVER_URL              @"http://stage.diveboard.com"

#define kLoginMode              @"loginMode"
#define kLoginModeNative        @"nativeLoginMode"
#define kLoginModeFB            @"facebookLoginMode"
#define kLoginUserInfo          @"loginUserInformation"
#define kLoginUserID            @"loginUserID"
#define kDiveboardUnit          @"diveboardUnit"


#define kLoadedDiveData(userid) [NSString stringWithFormat:@"userid_%@_loadedDiveData", userid]

#define kMainDefaultColor [UIColor colorWithRed:1.0f green:0.68f blue:0.1f alpha:1.0f]
#define getStringValue(v)     ([v isEqual:[NSNull null]] || [v isEqual:@"<null>"] || [v isEqual:@"(null)"]? @"" : [NSString stringWithFormat:@"%@", v]);
#define kDefaultFontName        @"Quicksand-Regular"
#define kDefaultFontNameBold    @"Quicksand-Bold"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define isPortrateScreen ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown )

#pragma mark -

@interface Global : NSObject

@end




#pragma mark - AppManager class

//@class LoginResult;

@interface AppManager : NSObject
{
    
}

+ (AppManager *)sharedManager;

@property (nonatomic, strong) LoginResult *loginResult;
@property (nonatomic, strong) FBSession   *fbSession;
@property (nonatomic, strong) NSMutableDictionary *loadedDives;

@end

#pragma mark - GlobalMethods Class

@interface GlobalMethods : NSObject

+ (void) setRoundView:(UIView *)view cornorRadious:(float)rad borderColor:(UIColor *)color border:(float)border;

@end


