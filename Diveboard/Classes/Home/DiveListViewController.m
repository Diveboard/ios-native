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
    OneDiveView *oneDiveView;
    
    int diveCount;
    int currentDiveIndex;
    
    int preloadDiveDataIndex;
    
    UIInterfaceOrientation m_currentOrientation;
//    NSMutableArray *preloadRequestManagers;
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

        [self initMethod];
        [self startPreloadDiveData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMethod
{
    currentDiveIndex = -1;
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        NSLog(@"Portrait");
        
        [self setLayoutControllersToPortrate];
    } else {
        
        [self setLayoutControllersToLandscape];
    }
    
    
}


#pragma mark - Preload each Dive Information from server

- (void) startPreloadDiveData
{
    // get dive IDs from saved data in local database
//    NSDictionary *tempData = [userDefault objectForKey:kLoadedDiveData(appManager.loginResult.user.ID)];
//    if (tempData && tempData.count > 0) {
//        appManager.loadedDives = [[NSMutableDictionary alloc] initWithDictionary:tempData];
//    }
//    else {
//        appManager.loadedDives = [[NSMutableDictionary alloc] init];
//    }
    
    preloadDiveDataIndex = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(preloadDiveData)
                                   userInfo:Nil
                                    repeats:NO];

}

- (void) preloadDiveData
{
    // from max index - to index 0
    int tIndex = ([AppManager sharedManager].loginResult.user.allDiveIDs.count - 1) - preloadDiveDataIndex;
    
    if (tIndex >= 0 && tIndex < [AppManager sharedManager].loginResult.user.allDiveIDs.count) {
        
        NSString *diveID = [[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:tIndex];
        
            OneDiveView *diveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + tIndex)];
            [diveView setDiveID:diveID];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(preloadDiveData)
                                       userInfo:Nil
                                        repeats:NO];

    } else {
        

        
    }
    preloadDiveDataIndex ++;
}


#pragma mark - Layout

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [DrawerMenuViewController sharedMenu].isShowList = YES;
    
    

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (m_currentOrientation == orientation) {
        
        return;
        
    }
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        NSLog(@"Portrait");
        
        [self setLayoutControllersToPortrate];
        
    } else {
        
        [self setLayoutControllersToLandscape];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [DrawerMenuViewController sharedMenu].isShowList = NO;
    
}

// portrate layout
- (void) setLayoutControllersToPortrate
{

    [self.imgviewBackground setImage:nil];
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    CGSize rootSize = deviceSize;
    
 
    diveCount = (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;
    if (diveCount == 0) {
        [self.lblCoordinate setText:@"No dive found!"];
    }
    if (rulerView) {
        [rulerView removeFromSuperview];
    }
    
    // remove all dive views
    for (UIView *view in self.scrviewMain.subviews) {
        [view removeFromSuperview];
    }
    [self.scrviewMain setContentSize:CGSizeMake(0, 0)];
    
    CGRect rect;
    
    if (rootSize.height == 568) {  // iPhone 5
        rect = CGRectMake(0, 45, rootSize.width, 420);
    }
    else if (rootSize.height == 480) {  // iPhone 4
        rect = CGRectMake(0, 35, rootSize.width, 360);
    }
    else {  // iPad
        rect = CGRectMake(0, 90, rootSize.width, 700);
    }
    
    // if iOS 7, move offset to top by 20 pixcel
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))  rect = CGRectOffset(rect, 0, -20);
    
    [self.scrviewMain setFrame:rect];

    if (rootSize.height == 568) {  // iPhone 5
        rect = CGRectMake(rootSize.width * 0.0625f,
                          rootSize.height - 100,
                          rootSize.width * 0.875f,
                          50);
    }
    else if (rootSize.height == 480) { // iPhone 4
        rect = CGRectMake(rootSize.width * 0.0625f,
                          rootSize.height - 80,
                          rootSize.width * 0.875f,
                          50);
    }
    else {  // iPad
        rect = CGRectMake(rootSize.width * 0.13f,
                          rootSize.height - 180,
                          rootSize.width * 0.74f,
                          50);

    }
    
    // if iOS 7, move offset to top by 20 pixcel
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))  rect = CGRectOffset(rect, 0, -20);
    
    if (diveCount > 0) {
        
        // ruler create
        rulerView = [[DiveCountlineView alloc] initWithFrame:rect];
        [rulerView setDelegate:self];
        [rulerView setMaxValue:diveCount];
        [rulerView setLayoutWithPortrate];
        if (currentDiveIndex < 0) {
            currentDiveIndex = diveCount - 1;
        }
        [rulerView setCurrentValue:(currentDiveIndex + 1)];
        [self.view addSubview:rulerView];
        


        // add dive views
        for (int i = 0; i < diveCount; i ++) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                rect = CGRectMake(20 + (rootSize.width * i), 0, 280, self.scrviewMain.frame.size.height);
            } else {
                rect = CGRectMake(100 + (rootSize.width * i), 0, 560, self.scrviewMain.frame.size.height);
            }
            NSString *diveID = [[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:i];
            OneDiveView *diveView = [[OneDiveView alloc] initWithFrame:rect
                                                                diveID:diveID
                                                                rotate:(UIInterfaceOrientationPortrait)];
            diveView.tag = (kDiveViewTag + i);
            diveView.diveIndex = i;
            diveView.delegate = self;
            [self.scrviewMain addSubview:diveView];
            if (i == 0) {
                [diveView setDiveID:diveID];
            }
        }
        
        [self.scrviewMain setContentSize:CGSizeMake(rootSize.width * diveCount, rect.size.height)];
        
        // scroll to lastest dive view
        [self.scrviewMain setContentOffset:CGPointMake(self.scrviewMain.frame.size.width * (currentDiveIndex), 0)
                                  animated:YES];
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        // viewBottom is view of coordinate information and menu button
        [self.viewBottom setFrame:CGRectMake(0,
                                             self.view.frame.size.height - self.viewBottom.frame.size.height,
                                             self.view.frame.size.width,
                                             self.viewBottom.frame.size.height)];
    }
    
    m_currentOrientation =[[UIApplication sharedApplication] statusBarOrientation];
    
}

// landscape layout
- (void) setLayoutControllersToLandscape
{
    [self.imgviewBackground setImage:nil];
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;

    CGSize rootSize = CGSizeMake(deviceSize.height, deviceSize.width);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        rootSize = deviceSize;
        
    }
    [self.view setFrame:CGRectMake(0, 0, rootSize.width, rootSize.height)];
    
    diveCount = (int)[AppManager sharedManager].loginResult.user.allDiveIDs.count;
    if (diveCount == 0) {
        [self.lblCoordinate setText:@"No dive found!"];
    }
    if (rulerView) {
        [rulerView removeFromSuperview];
    }
    // remove all dive views
    for (UIView *view in self.scrviewMain.subviews) {
        [view removeFromSuperview];
    }
    [self.scrviewMain setContentSize:CGSizeMake(0, 0)];
    
    CGRect rect;
    if (rootSize.width == 568) {  // iPhone 5
        rect = CGRectMake(rootSize.width * 0.11,
                          rootSize.height - 90,
                          rootSize.width * 0.78,
                          50);
    }
    else if (rootSize.width == 480) {  // iPhone 4
        rect = CGRectMake(rootSize.width * 0.04,
                          rootSize.height - 90,
                          rootSize.width * 0.92,
                          50);
    }
    else {  // iPad
        rect = CGRectMake(rootSize.width * 0.05f,
                          rootSize.height - 200,
                          rootSize.width * 0.9f,
                          50);
    }
    
    // if iOS7, move offset to top by -20 pixcel
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) rect = CGRectOffset(rect, 0, -15);

    if (diveCount > 0) {
        
        // create ruler
        rulerView = [[DiveCountlineView alloc] initWithFrame:rect];
        [rulerView setDelegate:self];
        [rulerView setMaxValue:diveCount];
        [rulerView setLayoutWithLandscape];
        if (currentDiveIndex < 0) {
            currentDiveIndex = diveCount - 1;
        }
        
        [rulerView setCurrentValue:(currentDiveIndex + 1)];

        [self.view addSubview:rulerView];
        
        
        
        float oneDiveViewWidth = 420.0f;
        float oneDiveViewHeight = 200.0f;
        float dx = (rootSize.width - oneDiveViewWidth) / 8;
        rect = CGRectMake((rootSize.width - oneDiveViewWidth) / 2 - dx, 20, oneDiveViewWidth + dx * 2,  oneDiveViewHeight);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  // iPad
            oneDiveViewWidth = 840.0f;
            oneDiveViewHeight = 385.0f;
            dx = (rootSize.width - oneDiveViewWidth) / 8;
            rect = CGRectMake((rootSize.width - oneDiveViewWidth) / 2 - dx, 120, oneDiveViewWidth + dx * 2,  oneDiveViewHeight);
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) rect = CGRectOffset(rect, 0, -10);
        
        
        [self.scrviewMain setFrame:rect];
        
        // add dive views
        for (int i = 0; i < diveCount; i ++) {
            
            CGRect rect = CGRectMake(dx + (self.scrviewMain.frame.size.width * i), 0, oneDiveViewWidth, oneDiveViewHeight);
            NSString *diveID = [[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:i];
            
            OneDiveView *diveView = [[OneDiveView alloc] initWithFrame:rect
                                                                diveID:diveID
                                                                rotate:(UIInterfaceOrientationLandscapeLeft)];
            diveView.tag = (kDiveViewTag + i);
            diveView.diveIndex = i;
            diveView.delegate = self;
            [self.scrviewMain addSubview:diveView];
            if (i == 0) {
                [diveView setDiveID:diveID];
            }

        }
        
        [self.scrviewMain setContentSize:CGSizeMake(self.scrviewMain.frame.size.width * diveCount, oneDiveViewHeight)];

        [self.scrviewMain setContentOffset:CGPointMake(self.scrviewMain.frame.size.width * (currentDiveIndex), 0)
                                  animated:YES];
    }
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.viewBottom setFrame:CGRectMake(0,
                                             self.view.frame.size.height - self.viewBottom.frame.size.height - 20,
                                             self.view.frame.size.width,
                                             self.viewBottom.frame.size.height)];
    }
    
    m_currentOrientation =[[UIApplication sharedApplication] statusBarOrientation];


}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self setLayoutControllersToLandscape];
    } else {
        [self setLayoutControllersToPortrate];
    }

}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrviewMain) {
        int index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self loadDiveData:index];
        
        int preIndex = index-1;
        int nextIndex = index+1;
        
        if (preIndex > -1) {
            
            OneDiveView *preDiveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + preIndex)];
            
            [preDiveView setDiveID:[[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:preIndex]];
            
        }

        if (nextIndex < [AppManager sharedManager].loginResult.user.allDiveIDs.count) {
            
            OneDiveView *nextDiveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + nextIndex)];
            [nextDiveView setDiveID:[[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:nextIndex]];
            
        }
        
        
        
        

    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.scrviewMain) {
        int index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self loadDiveData:index];
        
        int preIndex = index-1;
        int nextIndex = index+1;
        
        if (preIndex > -1) {
            
            OneDiveView *preDiveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + preIndex)];
            
            [preDiveView setDiveID:[[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:preIndex]];
            
        }
        
        if (nextIndex < [AppManager sharedManager].loginResult.user.allDiveIDs.count) {
            
            OneDiveView *nextDiveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + nextIndex)];
            [nextDiveView setDiveID:[[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:nextIndex]];
            
        }
        

    }

}


- (void) loadDiveData:(int)index
{
    currentDiveIndex = index;
    OneDiveView *diveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + index)];
    if (diveView) {
        if (diveView.isLoadedData) {
            // dive information is exist
            
            DiveInformation *diveInfoOfSelf = [diveView getDiveInformation];
            
            // show coordinate information of dive
            [self setCoordinateValue:diveInfoOfSelf];
        }
        else {
            // if dive information is empty
            // load dive information from server
            [diveView setDiveID:[[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:index]];
            
            DiveInformation *diveInfoOfSelf = [diveView getDiveInformation];
            
            // show coordinate information of dive
            [self setCoordinateValue:diveInfoOfSelf];

        }
    }
    
    if ([AppManager sharedManager].loginResult.user.allDiveIDs.count > 0) {
        [rulerView setHidden:NO];
        [rulerView setCurrentValue:(index + 1)];
    } else {
        [rulerView setHidden:YES];
        for (UIView *view in self.scrviewMain.subviews) {
            [view removeFromSuperview];
        }
        [self.imgviewBackground setImage:nil];
    }
    
    
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


// reload all
- (void)diveViewsUpdate
{
    currentDiveIndex = -1;
//    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
    
    if (isPortrateScreen) {
        // orientation is portrate
        [self setLayoutControllersToPortrate];
    }
    else {
        // orientation is landscape
        [self setLayoutControllersToLandscape];
    }
    
    currentDiveIndex = [AppManager sharedManager].loginResult.user.allDiveIDs.count - 1;
    
    [self loadDiveData:currentDiveIndex];
    
}

- (void)currentDiveViewUpdate{
    
    NSString *diveID = [[AppManager sharedManager].loginResult.user.allDiveIDs objectAtIndex:currentDiveIndex];
    
    OneDiveView *diveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + currentDiveIndex)];
    [diveView setDiveID:diveID];
    
    [self loadDiveData:currentDiveIndex];
}

// change unit visible of all dive values
- (void)updateUnit
{
    for (id diveView in self.scrviewMain.subviews) {
        if ([diveView isKindOfClass:[OneDiveView class]]) {
            [(OneDiveView *)diveView  changeDepthUnit:[AppManager sharedManager].userSettings.unit];
        }
    }
}

#pragma mark - DiveCountline Delegate

- (void) diveCountlineView:(DiveCountlineView *)diveCountlineView Number:(int)number
{
//    NSLog(@"%d", index);
    [self.scrviewMain setContentOffset:CGPointMake(self.scrviewMain.frame.size.width * (number - 1), 0)
                              animated:YES];
}

#pragma mark - OneDiveView Delegate

- (void)oneDiveViewDataLoadFinish:(OneDiveView *)diveView diveInfo:(DiveInformation *)diveInfoOfSelf
{
    if (currentDiveIndex == diveView.diveIndex) {
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
    [DiveOfflineModeManager sharedManager].isRefresh = YES;

    [SVProgressHUD showWithStatus:@"Loading Data" maskImage:[UIImage imageNamed:@"progress_mask"]];
    
    [[AppManager sharedManager].loadedDives removeAllObjects];
//    [appManager startPreloadDiveData];
    
//    if ([DiveOfflineModeManager sharedManager].isOffline) {
//        [self requestResultCheckingWithObject:[DiveOfflineModeManager sharedManager].getLoginResultData];
//        return;
//    }
    
    
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

            NSLog(@"%@",[AppManager sharedManager].loginResult.user.allDiveIDs);
            currentDiveIndex = -1;
            [self.scrviewMain setContentOffset:CGPointMake(0, 0) animated:NO];
            
            if (isPortrateScreen) {
                [self setLayoutControllersToPortrate];
            } else {
                [self setLayoutControllersToLandscape];
            }
            
            if (![DiveOfflineModeManager sharedManager].isOffline) {
                [self startPreloadDiveData];
            }
            
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
