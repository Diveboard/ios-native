//
//  Global.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "Global.h"
#import "AFNetworking.h"
//#import "LoginResult.h"


@implementation Global

@end


#pragma mark - AppManager class
@interface AppManager()<CLLocationManagerDelegate>
{
    
    CLLocationManager*  m_LocationManager;
    
    NSMutableArray* arrPictureDownloadOperations;
    
    
    
}

@end
@implementation AppManager
@synthesize currentLocation;
static AppManager *_sharedManager;
+ (AppManager *) sharedManager
{
    if (!_sharedManager) {
        _sharedManager = [[AppManager alloc] init];
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        m_LocationManager = [[CLLocationManager alloc] init];
        m_LocationManager.delegate = self;
        m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _remainingPictures = [[NSMutableArray alloc] init];

        if ([m_LocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [m_LocationManager requestWhenInUseAuthorization];
            
        }
        
        
        [m_LocationManager startUpdatingLocation];
        _userSettings = [[UserSettings alloc] init];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0f
                                         target:self
                                       selector:@selector(downloadPictures)
                                       userInfo:Nil
                                        repeats:YES];
        
        
    }
    return self;
}

- (void)downloadPictures
{
    

    if (self.remainingPictures.count < 1) {
        return;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.remainingPictures.lastObject]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [[DiveOfflineModeManager sharedManager] writeImage:responseObject url:operation.request.URL.absoluteString];
        [arrPictureDownloadOperations removeObject:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [arrPictureDownloadOperations removeObject:operation];
    }];
    
    [requestOperation start];
    
    [arrPictureDownloadOperations addObject:requestOperation];
    
    
    
}
- (void)setLoadedDives:(NSMutableDictionary *)loadedDives
{
    if (_currentSudoID > 0) {
        loadedDivesofSudo = loadedDives;
    }
    else {
        loadedDivesofMaster = loadedDives;
    }
}

- (NSMutableDictionary *)loadedDives
{
    if (_currentSudoID > 0) {
        return loadedDivesofSudo;
    }
    else {
        return loadedDivesofMaster;
    }
}

-(void)getUserData:(NSDictionary *)loginResultData
{
    
    
    NSMutableDictionary* loginResult = [NSMutableDictionary dictionaryWithDictionary:loginResultData];
    
    NSDictionary* updateParams = @{@"id": self.loginResult.user.ID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateParams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (jsonData) {

        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *params = @{@"auth_token": self.loginResult.token,
                                 @"apikey" : API_KEY,
                                 @"flavour"     : FLAVOUR,
                                 @"arg" : jsonString,
                                 };
        
        
        NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/V2/user", SERVER_URL];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager.requestSerializer setTimeoutInterval:REQUEST_TIME_OUT];
        
        [manager POST:requestURLStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (responseObject) {
                NSDictionary *data;
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    data = [NSDictionary dictionaryWithDictionary:responseObject];
                    
                }
                else {
                    
                    data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                           options:NSJSONReadingAllowFragments
                                                             error:nil];
                }
                
                if ([[data objectForKey:@"success"] boolValue]) {
                    
                    [loginResult setObject:[data objectForKey:@"result"] forKey:@"user"];
                    
                    
                    if (![DiveOfflineModeManager sharedManager].isOffline) {
                        [[DiveOfflineModeManager sharedManager] writeLoginResultData:loginResult];
                    }
                    
                    self.loginResult = [[LoginResult alloc] initWithDictionary:loginResult];
                    self.loginResult.user.allDiveIDs = [NSMutableArray arrayWithArray:[[self.loginResult.user.allDiveIDs reverseObjectEnumerator] allObjects]];
                
                }
                
                
            
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        

        
    }
    
    
    
}



#pragma mark - CLLocationManagerDelegate

#define kUserLastLocation @"userLastLocation"

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.currentLocation = [locations objectAtIndex:0];
    
    NSNumber *lat = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
    
    NSNumber *lng = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
    
    NSDictionary *userLocation=@{@"lat":lat,@"long":lng};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:kUserLastLocation];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSDictionary* userLocation = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLastLocation];
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:[[userLocation objectForKey:@"lat"] doubleValue] longitude:[[userLocation objectForKey:@"long"] doubleValue]];
    
    self.currentLocation = location;
    
}
@end


#pragma mark - GlobalMethods class

@implementation GlobalMethods

+ (void) setRoundView:(UIView *)view cornorRadious:(float)rad borderColor:(UIColor *)color border:(float)border
{
    view.layer.cornerRadius = rad;
    view.layer.masksToBounds = YES;
    view.layer.borderColor  = color.CGColor;
    view.layer.borderWidth  = border;
}

+ (NSString *)encodeValueToFloat:(NSString *)value
{
    
    return nil;
}
+ (void)setBorderView:(UIView*)view borderColor:(UIColor *)color borderWidth:(float)borderWidth position:(NSString*)position{
    
    CGSize mainViewSize = view.bounds.size;
    
    
    UIView *borderView = [[UIView alloc] init];
    
    borderView.opaque = YES;
    borderView.backgroundColor = color;
    
    CGRect frame = CGRectMake(0, 0, 0, 0);

    if ([position isEqualToString:@"top"]) {
        
        frame = CGRectMake(0, 0, mainViewSize.width, borderWidth);
        borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }else if([position isEqualToString:@"bottom"]){
        
        frame = CGRectMake(0, mainViewSize.height - borderWidth, mainViewSize.width, borderWidth);
        borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }else if([position isEqualToString:@"left"]){
        
        frame = CGRectMake(0, 0, borderWidth, mainViewSize.height);
        borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        
    }else if([position isEqualToString:@"right"]){
        
        frame = CGRectMake(mainViewSize.width - borderWidth, 0, borderWidth, mainViewSize.height);
        
        borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        
    }
    
    
    [borderView setFrame:frame];
    
    [view addSubview:borderView];
    
}


@end

#pragma mark UserSettings class

@implementation UserSettings


-(int) unit
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:kDiveboardUnit] == nil ? 1 : [[ud objectForKey:kDiveboardUnit] intValue];
    
}

-(void)setUnit:(int)unit{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (self.unit != unit) {
        [ud setObject:@(unit) forKey:kDiveboardUnit];
        [ud synchronize];
        if ([AppManager sharedManager].diveListVC) {
           
            [[AppManager sharedManager].diveListVC updateUnit];
            
        }
        
    }
    
}

-(int)pictureQuality
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return  [ud objectForKey:kPictureQuality] == nil ? 0 : [[ud objectForKey:kPictureQuality] intValue];
    
}
-(void)setPictureQuality:(int)pictureQuality{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (self.pictureQuality != pictureQuality) {
        [ud setObject:@(pictureQuality) forKey:kPictureQuality];
        [ud synchronize];
    }
    
}
-(int)downloadMethod{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:kDownloadMethod] == nil ? 0 : [[ud objectForKey:kDownloadMethod] intValue];
    
}
-(void)setDownloadMethod:(int)downloadMethod{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(downloadMethod) forKey:kDownloadMethod];
    [ud synchronize];
    
}

@end

