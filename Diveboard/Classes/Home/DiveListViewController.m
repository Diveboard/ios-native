//
//  DiveListViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/26/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveListViewController.h"
#import "AFNetworking.h"
#import "DiveInformation.h"
#import "DivePicturesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+LBBlurredImage.h"
#import "DiveDetailContainerController.h"
#import "DiveEditViewController.h"
#import "SettingViewController.h"
#import "SVProgressHUD.h"
#import "DrawerMenuViewController.h"

#define kDiveViewTag       300

@interface DiveListViewController () <DiveEditViewControllerDelegate>
{
    
    DiveCountlineView *rulerView;

}
@end

@implementation DiveListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

//    self.carousel.type = icarouseltype
    
    self.carousel.type = iCarouselTypeLinear;
    
    
    self.carousel.pagingEnabled = YES;
    
    [self initMethod];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMethod
{
    
    int diveCount = (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;

    [self.carousel scrollToItemAtIndex:diveCount-1 animated:NO];
    
//    if (![DiveOfflineModeManager sharedManager].isOffline) {
    
        [self startPreloadDiveData];
        
//    }
    
    
}

- (void) startPreloadDiveData
{
    
    NSMutableArray* params_list = [[NSMutableArray alloc] init];
    
    NSMutableArray* params;
    
    
    for (int i = 0; i < [AppManager sharedManager].loginResult.user.allDiveIDs.count; i++) {
        
        if ( i % 15 == 0) {
            
            params = [[NSMutableArray alloc] init];
            
            [params_list addObject:params];
            
        }
        
        NSDictionary* dic = @{@"id":[[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:i]};
        
        [params addObject:dic];
        
    }
    
    [self preloadDiveData:params_list :0 :^{
        
       self.isCompletePreLoad = YES;
        
    }];
    
}

- (void)preloadDiveData:(NSMutableArray*)params_list :(int)index :(void (^)())finish
{
    
    NSString *authToken = [AppManager sharedManager].loginResult.token;
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/dive", SERVER_URL];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[params_list objectAtIndex:index] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *params = @{@"auth_token": authToken,
                             @"apikey"    : API_KEY,
                             @"flavour"   : FLAVOUR,
                             @"arg"       : jsonString
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"multipart/form-data"  forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:@"application/json"     forHTTPHeaderField:@"Accept"];
    
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[data objectForKey:@"success"] boolValue]) {
            
            NSArray* dive_list = [data objectForKey:@"result"];
            
            for (int i = 0; i < dive_list.count; i++) {
                
                NSDictionary* diveDic = [dive_list objectAtIndex:i];
                
                DiveInformation  *dive = [[DiveInformation alloc] initWithDictionary:diveDic];
                
                NSDictionary* dic = @{
                                      @"error"              :[data objectForKey:@"error"],
                                      
                                      @"result"             : diveDic,
                                      
                                      @"success"            :[data objectForKey:@"success"],
                                      
                                      @"user_authentified"  :[data objectForKey:@"user_authentified"]
                                      
                                      };
                
                [[AppManager sharedManager].loadedDives setObject:dic forKey:[NSNumber numberWithLong:[dive.ID integerValue]]];
                
                
                [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:dic overwrite:YES];
                
                
            }
            
        }
        
        if (index < params_list.count-1) {
            
            [self preloadDiveData:params_list :index+1 :finish];
            
        }else{
            
            finish();
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSArray* diveIDs = [params_list objectAtIndex:index];
        
        for (int i = 0 ; i < diveIDs.count ; i++) {
            
            NSString* diveID = [diveIDs objectAtIndex:i];
            
           id responseObject =  [[DiveOfflineModeManager sharedManager] getOneDiveInformation:diveID];
           
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject];
            
            if ([[data objectForKey:@"success"] boolValue]) {
            
                DiveInformation* dive = [[DiveInformation alloc] initWithDictionary:[data objectForKey:@"result"]];
                
                [[AppManager sharedManager].loadedDives setObject:responseObject forKey:[NSNumber numberWithLong:[dive.ID integerValue]]];
                
                [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:responseObject overwrite:NO];
                
            }
            
        }
        
        if (index < params_list.count-1) {
            
            [self preloadDiveData:params_list :index+1 :finish];
            
        }else{
            
            finish();
            
        }
        
    }];
    
    
    
}


#pragma mark - Layout

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [DrawerMenuViewController sharedMenu].isShowList = YES;
    
    [self.carousel scrollToItemAtIndex:self.carousel.currentItemIndex animated:NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [DrawerMenuViewController sharedMenu].isShowList = NO;
    
}

-(void)viewWillLayoutSubviews
{
    
    
    
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;

    
     int diveCount = (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;
    
    if (diveCount == 0) {
        
        [self.lblCoordinate setText:@"No dive found!"];
        
    }
    
    
    CGRect rect;

    if (isPortrateScreen) {
        
        if (deviceSize.height == 568) {  // iPhone 5
            
            rect = CGRectMake(0, 45, deviceSize.width, 420);
            
        }
        else if (deviceSize.height == 480) {  // iPhone 4
            
            rect = CGRectMake(0, 35, deviceSize.width, 360);
            
        }
        else {  // iPad
            
            rect = CGRectMake(0, 90, deviceSize.width, 700);
            
        }
        
        // if iOS 7, move offset to top by 20 pixcel
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))  rect = CGRectOffset(rect, 0, -20);

    }else{
        
        float oneDiveViewWidth = 420.0f;
        
        float oneDiveViewHeight = 200.0f;
        
        float dx = (deviceSize.width - oneDiveViewWidth) / 8;
        
        rect = CGRectMake((deviceSize.width - oneDiveViewWidth) / 2 - dx, 20, oneDiveViewWidth + dx * 2,  oneDiveViewHeight);

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  // iPad
            
            oneDiveViewWidth = 840.0f;
            
            oneDiveViewHeight = 385.0f;
            
            dx = (deviceSize.width - oneDiveViewWidth) / 8;
            
            rect = CGRectMake((deviceSize.width - oneDiveViewWidth) / 2 - dx, 120, oneDiveViewWidth + dx * 2,  oneDiveViewHeight);
            
        }

        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) rect = CGRectOffset(rect, 0, -10);

    }
    
    [self.carousel setFrame:rect];
    
    [self.carousel reloadData];

    [self rulerViewUpdate];
    
    
    
}

-(void) rulerViewUpdate
{
    if (rulerView) {
        
        [rulerView removeFromSuperview];
        
        rulerView = nil;
    }
    int diveCount = (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;

    if (diveCount > 0) {
        
        rulerView = [[DiveCountlineView alloc] initWithFrame:[self getRectOfRulerView]];
        
        [rulerView setDelegate:self];
        
        [rulerView setMaxValue:diveCount];
        
        if (isPortrateScreen) {
            
            [rulerView setLayoutWithPortrate];
            
        }else{
            
            [rulerView setLayoutWithLandscape];
            
        }
        [rulerView setCurrentValue:(int)self.carousel.currentItemIndex+1];
        
        [self.view addSubview:rulerView];
        
    }
    
}
#pragma iCarousel DataSource&Delegate

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{

    return (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;

}

-(CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    
    return carousel.frame.size.width;
    
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view

{
    
    NSString *diveID = [[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:index];
    
    OneDiveView* diveView;
    
    if (view == nil) {
        
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        
        diveView = [[OneDiveView alloc] initWithFrame:[self getRectOfOneDiveView]
                                                            diveID:diveID
                                                            rotate:([[UIApplication sharedApplication] statusBarOrientation])];
        
        [diveView setTag:500];
        
        diveView.delegate = self;
        
        [view addSubview:diveView];
        
        
    }

    
    diveView = (OneDiveView*)[view viewWithTag:500];

    diveView.diveIndex = (int)index;
    
    [diveView setDiveID:diveID];

    
    return view;
    
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
    OneDiveView* diveView =(OneDiveView*)[carousel.currentItemView viewWithTag:500];
    
    if ([diveView getDiveInformation]) {
        
        [self oneDiveViewDataLoadFinish:diveView diveInfo:[diveView getDiveInformation]];
        
    }
    [rulerView setCurrentValue:(int)self.carousel.currentItemIndex+1];
    
    
}
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
    
}
-(CGRect) getRectOfOneDiveView
{

    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    
    CGRect rect;

    if (isPortrateScreen) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            rect = CGRectMake(20 , 0, 280, self.carousel.frame.size.height);
            
        } else {
            
            rect = CGRectMake(100, 0, 560, self.carousel.frame.size.height);
            
        }
        
    }else{
        
        float oneDiveViewWidth = 420.0f;
        
        float oneDiveViewHeight = 200.0f;
        
        float dx = (deviceSize.width - oneDiveViewWidth) / 8;
        

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  // iPad
            
            oneDiveViewWidth = 840.0f;
            
            oneDiveViewHeight = 385.0f;
            
        }

        rect = CGRectMake(dx , 0, oneDiveViewWidth, oneDiveViewHeight);
        

    }

    return rect;
    
}
-(CGRect) getRectOfRulerView
{
    
    CGRect rect;
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    
    if (isPortrateScreen) {
        
        if (deviceSize.height == 568) {  // iPhone 5
            
            rect = CGRectMake(deviceSize.width * 0.0625f,
                              deviceSize.height - 100,
                              deviceSize.width * 0.875f,
                              50);
        }
        else if (deviceSize.height == 480) { // iPhone 4
            
            rect = CGRectMake(deviceSize.width * 0.0625f,
                              deviceSize.height - 80,
                              deviceSize.width * 0.875f,
                              50);
        }
        else {  // iPad
            rect = CGRectMake(deviceSize.width * 0.13f,
                              deviceSize.height - 180,
                              deviceSize.width * 0.74f,
                              50);
    
        }
            
        
    }else{
        
        if (deviceSize.width == 568) {  // iPhone 5
            
            rect = CGRectMake(deviceSize.width * 0.11,
                              deviceSize.height - 90,
                              deviceSize.width * 0.78,
                              50);
            
        }else if (deviceSize.width == 480) {  // iPhone 4
            
            rect = CGRectMake(deviceSize.width * 0.04,
                              deviceSize.height - 90,
                              deviceSize.width * 0.92,
                              50);
            
        }else {  // iPad
            
            rect = CGRectMake(deviceSize.width * 0.05f,
                              deviceSize.height - 200,
                              deviceSize.width * 0.9f,
                              50);
            
        }
        
        
    }
    
    return rect;
    
}

#pragma mark -

- (void)setCoordinateValue:(DiveInformation *)diveInfoOfSelf
{
//    if (([diveInfoOfSelf.spotInfo.lat floatValue] == 0) && ([diveInfoOfSelf.spotInfo.lng floatValue] == 0)) {
    if ([diveInfoOfSelf.spotInfo.ID floatValue] != 1) {
        // coordinate value is empty
        self.lblCoordinate.text = [NSString stringWithFormat:@"%.4f°N,  %.4f°E", [diveInfoOfSelf.spotInfo.lat floatValue], [diveInfoOfSelf.spotInfo.lng floatValue]];
        
    }
    else {
        
        // coordinate value is exist
        self.lblCoordinate.text = @"No spot assigned";
        
    }
    
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        // internet is offline
        
        NSString* imgURL = diveInfoOfSelf.imageURL;
        UIImage *backgroundImage = nil;
        if ([[imgURL lowercaseString] hasPrefix:@"http://"] || [[imgURL lowercaseString] hasPrefix:@"https://"])
        {
            backgroundImage = [[DiveOfflineModeManager sharedManager] getImageWithUrl:imgURL];
            
        }else{
            
            backgroundImage = [[DiveOfflineModeManager sharedManager] getLocalDivePicture:imgURL];
        }
        
        [self.imgviewBackground setImageToBlur:backgroundImage blurRadius:3.0f completionBlock:^(NSError *error) {
            
        }];
    }
    else {
        
        // internet is online
        dispatch_queue_t dqueue = dispatch_queue_create("image.loading", 0);
        dispatch_async(dqueue, ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:diveInfoOfSelf.imageURL]];
            
            UIImage *backgroundImage = [UIImage imageWithData:imageData];
            [[DiveOfflineModeManager sharedManager] writeImage:backgroundImage url:diveInfoOfSelf.imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imgviewBackground setImageToBlur:backgroundImage blurRadius:3.0f completionBlock:^(NSError *error) {
                    
                }];
            });
            
        });
    }
}

- (void)diveViewsUpdate
{
    
    [self.imgviewBackground setImage:nil];
    
    int diveCount = (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;
    
    [self.carousel reloadData];
    
    [self rulerViewUpdate];
    
    [self.carousel scrollToItemAtIndex:diveCount-1 animated:NO];
    
    
    
}

- (void)currentDiveViewUpdate{
    
    [self.carousel reloadData];
    
}

// change unit visible of all dive values
- (void)updateUnit
{

    [self.carousel reloadData];
    
}


#pragma mark - DiveCountline Delegate

- (void) diveCountlineView:(DiveCountlineView *)diveCountlineView Number:(int)number
{
    NSLog(@"%d",number);
    
    [self.carousel scrollToItemAtIndex:number-1 animated:NO];
   
    
}

#pragma mark - OneDiveView Delegate

- (void)oneDiveViewDataLoadFinish:(OneDiveView *)diveView diveInfo:(DiveInformation *)diveInfoOfSelf
{
    NSString *diveID = [[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:self.carousel.currentItemIndex];

    if ([diveInfoOfSelf.ID isEqualToString:[NSString stringWithFormat:@"%@",diveID]]) {
        
        [self setCoordinateValue:diveInfoOfSelf];
        
    }
    
}
- (void)oneDiveViewImageTouch:(OneDiveView *)diveView diveInfo:(DiveInformation *)diveInfoOfSelf
{
    DivePicturesViewController *viewController = [[DivePicturesViewController alloc] initWithPicturesData:diveInfoOfSelf.divePictures];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:^{
        [viewController showPictureWithIndex:0];
    }];
}

- (void)oneDiveViewDetailClick:(OneDiveView *)diveView diveInfo:(DiveInformation *)diveInfoOfSelf
{
    
    [SVProgressHUD show];
    
    __block DiveDetailContainerController *viewController;
    
    dispatch_queue_t dqueue = dispatch_queue_create("com.diveboard.gotodivedetail", 0);
    
    dispatch_async(dqueue, ^{
        
        viewController = [[DiveDetailContainerController alloc] initWithDiveInformation:diveInfoOfSelf];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController pushViewController:viewController animated:YES];
            
            [SVProgressHUD dismiss];
            
        });
        
    });
    
}


#pragma mark -

- (IBAction)menuAction:(id)sender {
    
    [[DrawerMenuViewController sharedMenu] toggleDrawerMenu];
}

#pragma mark - Refresh

- (void) refreshAction
{
    
    if (self.preloadRequestManagers) {
        
        for (AFHTTPRequestOperationManager *manager in self.preloadRequestManagers) {
            
            [manager.operationQueue cancelAllOperations];
            
        }
        
        [self.preloadRequestManagers removeAllObjects];
        
        self.preloadRequestManagers = nil;
        
    }
    
    [DiveOfflineModeManager sharedManager].isRefresh = YES;

    [SVProgressHUD showWithStatus:@"Loading Data" maskImage:[UIImage imageNamed:@"progress_mask"]];
    
    [[AppManager sharedManager].loadedDives removeAllObjects];
    
    
    
    NSString *loginMode = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginMode];
    
    if ([loginMode isEqualToString:kLoginModeNative]) {
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserInfo];
        
        NSString *email = [userInfo objectForKey:@"email"];
        
        NSString *password = [userInfo objectForKey:@"password"];
        
        [self loginWithNativeUser:email password:password];
        
    }
    else if ([loginMode isEqualToString:kLoginModeFB]) {
        
        NSDictionary *fbUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserInfo];
        
        [self loginActionWithFacebookUser:fbUserInfo];
    }

}

#pragma mark - Server connecting

- (void) loginWithNativeUser:(NSString *)email password:(NSString *)password
{
    NSString     *requestURLString = [NSString stringWithFormat:@"%@/api/login_email", SERVER_URL];
    
    NSDictionary *params = @{@"apikey": API_KEY,
                             @"flavour" : FLAVOUR,
                             @"email" :email,
                             @"password" : password,
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [[DiveOfflineModeManager sharedManager] checkUpdateDive];
        
        if ([self updatedDiveInformation:responseObject]) {
            
            
            [[DiveOfflineModeManager sharedManager] updateLocalDiveToServer:^{
                
                [DiveOfflineModeManager sharedManager].isUpdated = NO;
                
                [self loginWithNativeUser:email password:password];
                
            }];
            
        } else {
            
            [self requestResultCheckingWithObject:responseObject];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[DiveOfflineModeManager sharedManager] setIsOffline:YES];
        [self requestResultCheckingWithObject:[DiveOfflineModeManager sharedManager].getLoginResultData];
        
    }];
}
- (BOOL) updatedDiveInformation:(id)responseObject
{
    if (![[DiveOfflineModeManager sharedManager] getLoginResultData]) {
        return NO;
    }
    if (![DiveOfflineModeManager sharedManager].isUpdated) {
        return NO;
    }
    
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
            
            LoginResult *nowLoginResult = [[LoginResult alloc] initWithDictionary:data];
            LoginResult *oldLoginResult = [[LoginResult alloc] initWithDictionary:[[DiveOfflineModeManager sharedManager] getLoginResultData]];
            
            if ([nowLoginResult.ID isEqualToString:oldLoginResult.ID]) {
                
                return YES;
                
            } else {
                [[DiveOfflineModeManager sharedManager] cleanOldInformation];
                return NO;
            }
            
        } else {
            
            return NO;
        }
    } else {
        return NO;
    }
}

- (void) loginActionWithFacebookUser:(NSDictionary *)info
{
    NSString *fbLoginURLString = [NSString stringWithFormat:@"%@/api/login_fb", SERVER_URL];
    NSDictionary *params = @{@"apikey": API_KEY,
                             @"flavour" : FLAVOUR,
                             @"fbid" : [info objectForKey:@"fbid"],
                             @"fbtoken": [info objectForKey:@"fbtoken"],
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:fbLoginURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self requestResultCheckingWithObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [[DiveOfflineModeManager sharedManager] setIsOffline:YES];
        [self requestResultCheckingWithObject:[DiveOfflineModeManager sharedManager].getLoginResultData];
        
    }];
}

- (void) requestResultCheckingWithObject:(id)responseObject
{
    if (responseObject) {
        
        NSDictionary *data = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            data = [NSDictionary dictionaryWithDictionary:responseObject];
            
        }else{
            data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                   options:NSJSONReadingAllowFragments
                                                     error:nil];
            
        }
        if ([[data objectForKey:@"success"] boolValue]) {
            [AppManager sharedManager].loginResult = [[LoginResult alloc] initWithDictionary:data];
            [AppManager sharedManager].loginResult.user.allDiveIDs = [NSMutableArray arrayWithArray:[[[AppManager sharedManager].loginResult.user.allDiveIDs reverseObjectEnumerator] allObjects]];
            
            [[AppManager sharedManager] getUserData:data];

            
            int diveCount =(int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;
            
            [self.carousel reloadData];
            
            [self.carousel scrollToItemAtIndex:diveCount-1 animated:NO];

            [self startPreloadDiveData];
            
        } else {
            
        }
    }
    
    [DiveOfflineModeManager sharedManager].isRefresh = NO;
    
    [SVProgressHUD dismiss];
}

- (void)diveEditFinish:(DiveInformation *)diveInfo
{
    [[AppManager sharedManager].loginResult.user.allDiveIDs addObject:diveInfo.ID];
//    currentDiveIndex = -1;
    [self diveViewsUpdate];
}




@end
