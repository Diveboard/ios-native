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
#import "KxMenu.h"
#import "DiveDetailViewController.h"
#import "DiveEditViewController.h"
#import "SettingViewController.h"
#import "MBProgressHUD.h"


#define kDiveViewTag       300

@interface DiveListViewController () <DiveEditViewControllerDelegate>
{
    AppManager *appManager;
    NSUserDefaults *userDefault;
    int        diveLengthUnit;
    DiveCountlineView *rulerView;
    OneDiveView *oneDiveView;
    
    int diveCount;
    int currentDiveIndex;
    
    int preloadDiveDataIndex;
    
    UIInterfaceOrientation oOrientation;
    
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
    
    appManager = [AppManager sharedManager];
    userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([userDefault objectForKey:kDiveboardUnit]) {
        diveLengthUnit = [[userDefault objectForKey:kDiveboardUnit] intValue];
    } else {
        [userDefault setObject:@(1) forKey:kDiveboardUnit];
        [userDefault synchronize];
        diveLengthUnit = 1;
    }
    
    [self initMethod];
    
    [self startPreloadDiveData];
    
//    [self preloadDiveData];
    
//    [self roadDiveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMethod
{
//    _lblBottomTitle.font = [UIFont fontWithName:kDefaultFontName size:10.0f];
//    _lblCoordinate.font  = [UIFont fontWithName:kDefaultFontName size:18.0f];
    currentDiveIndex = -1;
    
    if (isPortrateScreen) {
        NSLog(@"Portrait");
//        [self setLayoutControllersToPortrate];
        oOrientation = UIInterfaceOrientationLandscapeLeft;

    } else {
        NSLog(@"Landscape");
//        [self setLayoutControllersToLandscape];
        oOrientation = UIInterfaceOrientationPortrait;
        
    }
    
//    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait ||
//        [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
//        [self setLayoutControllersToPortrate];
//    } else {
//        [self setLayoutControllersToLandscape];
//    }
//    oOrientation = UIInterfaceOrientationPortraitUpsideDown;
    
}

- (void) startPreloadDiveData
{
    NSDictionary *tempData = [userDefault objectForKey:kLoadedDiveData(appManager.loginResult.user.ID)];
    if (tempData && tempData.count > 0) {
        appManager.loadedDives = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    } else {
        appManager.loadedDives = [[NSMutableDictionary alloc] init];
    }
    
    preloadDiveDataIndex = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(preloadDiveData) userInfo:Nil repeats:NO];

}

- (void) preloadDiveData
{
    int tIndex = (appManager.loginResult.user.allDiveIDs.count - 1) - preloadDiveDataIndex;
    if (tIndex >= 0 && tIndex < appManager.loginResult.user.allDiveIDs.count) {
        NSString *diveID = [appManager.loginResult.user.allDiveIDs objectAtIndex:tIndex];
        NSDictionary *diveData = [appManager.loadedDives objectForKey:diveID];
        if (!diveData || diveData.count == 0) {
            // request
            [self requestDiveData:diveID];
        }
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(preloadDiveData) userInfo:Nil repeats:NO];

    } else {
        
    }
    preloadDiveDataIndex ++;
}

- (void) requestDiveData:(NSString *)diveID
{
    NSString *authToken = appManager.loginResult.token;
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/dive/%@", SERVER_URL, diveID] ; //]@"77197"];
    
    NSDictionary *params = @{@"auth_token": authToken,
                             @"apikey"    : API_KEY,
                             @"flavour"   :FLAVOUR,
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data"  forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json"     forHTTPHeaderField:@"Accept"];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@ preload one complete!---- \n %@", diveID, responseObject);
        if (responseObject) {
            [appManager.loadedDives setObject:responseObject forKey:diveID];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@", error);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (isPortrateScreen) {
        NSLog(@"Portrait");
        if (oOrientation == UIInterfaceOrientationLandscapeLeft) {
            [self setLayoutControllersToPortrate];
        }
        
    } else {
        NSLog(@"Landscape");
        if (oOrientation == UIInterfaceOrientationPortrait) {
            [self setLayoutControllersToLandscape];
        }
    }
}

- (void) setLayoutControllersToPortrate
{
    oOrientation = UIInterfaceOrientationPortrait;
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    CGSize rootSize = deviceSize;
    
//    oneDiveView = [[OneDiveView alloc] initWithFrame:CGRectMake(20, 40, 280, 420)
//                                              diveID:[appManager.loginResult.user.allDiveIDs lastObject]];
//    [self.view addSubview:oneDiveView];
 
    diveCount = (int)appManager.loginResult.user.allDiveIDs.count;
    if (rulerView) {
        [rulerView removeFromSuperview];
    }
    CGRect rect;
    
    if (deviceSize.height == 568) {
        rect = CGRectMake(0, 45, rootSize.width, 420);
    } else if (deviceSize.height == 480) {
        rect = CGRectMake(0, 35, rootSize.width, 360);
    } else {
        rect = CGRectMake(0, 90, rootSize.width, 700);
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))  rect = CGRectOffset(rect, 0, -20);
    
    [self.scrviewMain setFrame:rect];

    if (deviceSize.height == 568) {
        rect = CGRectMake(rootSize.width * 0.0625f,
                          rootSize.height - 100,
                          rootSize.width * 0.875f,
                          50);
    } else if (deviceSize.height == 480) {
        rect = CGRectMake(rootSize.width * 0.0625f,
                          rootSize.height - 80,
                          rootSize.width * 0.875f,
                          50);
    } else {
        rect = CGRectMake(rootSize.width * 0.13f,
                          rootSize.height - 180,
                          rootSize.width * 0.74f,
                          50);

    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))  rect = CGRectOffset(rect, 0, -20);
    
    if (appManager.loginResult.user.allDiveIDs.count > 0) {
        rulerView = [[DiveCountlineView alloc] initWithFrame:rect];
        [rulerView setDelegate:self];
        [rulerView setMaxValue:diveCount];
        [rulerView setLayoutWithPortrate];
        if (currentDiveIndex < 0) {
            currentDiveIndex = diveCount - 1;
        }
        [rulerView setCurrentValue:(currentDiveIndex + 1)];
        [self.view addSubview:rulerView];
        
        
        for (UIView *view in self.scrviewMain.subviews) {
            [view removeFromSuperview];
        }
        
        
        for (int i = 0; i < diveCount; i ++) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                rect = CGRectMake(20 + (rootSize.width * i), 0, 280, self.scrviewMain.frame.size.height);
            } else {
                rect = CGRectMake(100 + (rootSize.width * i), 0, 560, self.scrviewMain.frame.size.height);
            }
            
            OneDiveView *diveView = [[OneDiveView alloc] initWithFrame:rect
                                                                diveID:[appManager.loginResult.user.allDiveIDs objectAtIndex:i] rotate:(UIInterfaceOrientationPortrait)];
            diveView.tag = (kDiveViewTag + i);
            diveView.diveIndex = i;
            diveView.delegate = self;
            [self.scrviewMain addSubview:diveView];
        }
        
        [self.scrviewMain setContentSize:CGSizeMake(rootSize.width * diveCount, rect.size.height)];
        
        [self.scrviewMain setContentOffset:CGPointMake(self.scrviewMain.frame.size.width * (currentDiveIndex), 0)
                                  animated:YES];
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.viewBottom setFrame:CGRectMake(0, self.view.frame.size.height - self.viewBottom.frame.size.height, self.view.frame.size.width, self.viewBottom.frame.size.height)];
    }
    
}

- (void) setLayoutControllersToLandscape
{
    oOrientation = UIInterfaceOrientationLandscapeLeft;
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;

    CGSize rootSize = CGSizeMake(deviceSize.height, deviceSize.width);
    [self.view setFrame:CGRectMake(0, 0, rootSize.width, rootSize.height)];
    
    diveCount = (int)appManager.loginResult.user.allDiveIDs.count;
    if (rulerView) {
        [rulerView removeFromSuperview];
    }
    CGRect rect;
    if (deviceSize.height == 568) {
        rect = CGRectMake(rootSize.width * 0.11,
                          rootSize.height - 90,
                          rootSize.width * 0.78,
                          50);
    } else if (deviceSize.height == 480) {
        rect = CGRectMake(rootSize.width * 0.04,
                          rootSize.height - 90,
                          rootSize.width * 0.92,
                          50);
    } else {
        rect = CGRectMake(rootSize.width * 0.05f,
                          rootSize.height - 200,
                          rootSize.width * 0.9f,
                          50);
    }
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) rect = CGRectOffset(rect, 0, -15);

    if (appManager.loginResult.user.allDiveIDs.count > 0) {
        rulerView = [[DiveCountlineView alloc] initWithFrame:rect];
        [rulerView setDelegate:self];
        [rulerView setMaxValue:diveCount];
        [rulerView setLayoutWithLandscape];
        if (currentDiveIndex < 0) {
            currentDiveIndex = diveCount - 1;
        }
        [rulerView setCurrentValue:(currentDiveIndex - 1)];

        [self.view addSubview:rulerView];
        
        for (UIView *view in self.scrviewMain.subviews) {
            [view removeFromSuperview];
        }
        
        float oneDiveViewWidth = 420.0f;
        float oneDiveViewHeight = 200.0f;
        float dx = (rootSize.width - oneDiveViewWidth) / 8;
        rect = CGRectMake((rootSize.width - oneDiveViewWidth) / 2 - dx, 20, oneDiveViewWidth + dx * 2,  oneDiveViewHeight);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            oneDiveViewWidth = 840.0f;
            oneDiveViewHeight = 385.0f;
            dx = (rootSize.width - oneDiveViewWidth) / 8;
            rect = CGRectMake((rootSize.width - oneDiveViewWidth) / 2 - dx, 120, oneDiveViewWidth + dx * 2,  oneDiveViewHeight);
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) rect = CGRectOffset(rect, 0, -10);
        
        
        [self.scrviewMain setFrame:rect];
        
        
        for (int i = 0; i < diveCount; i ++) {
            OneDiveView *diveView = [[OneDiveView alloc] initWithFrame:CGRectMake(dx + (self.scrviewMain.frame.size.width * i), 0, oneDiveViewWidth, oneDiveViewHeight)
                                                                diveID:[appManager.loginResult.user.allDiveIDs objectAtIndex:i] rotate:(UIInterfaceOrientationLandscapeLeft)];
            diveView.tag = (kDiveViewTag + i);
            diveView.diveIndex = i;
            diveView.delegate = self;
            [self.scrviewMain addSubview:diveView];
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

- (void)setCoordinateValue:(DiveInformation *)diveInfoOfSelf
{
    if (([diveInfoOfSelf.spotInfo.lat floatValue] == 0) && ([diveInfoOfSelf.spotInfo.lng floatValue] == 0)) {
        self.lblCoordinate.text = @"";
        
    } else {
        self.lblCoordinate.text = [NSString stringWithFormat:@"%.4f°N,  %.4f°E", [diveInfoOfSelf.spotInfo.lat floatValue], [diveInfoOfSelf.spotInfo.lng floatValue]];
    }
    
    dispatch_queue_t dqueue = dispatch_queue_create("image.loading", 0);
    dispatch_async(dqueue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:diveInfoOfSelf.imageURL]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.imgviewBackground setImageToBlur:[UIImage imageWithData:imageData] blurRadius:3.0f completionBlock:^(NSError *error) {
                
            }];
        });
        
    });
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrviewMain) {
        int index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self loadDiveData:index];

    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.scrviewMain) {
        int index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self loadDiveData:index];

    }

}


- (void) loadDiveData:(int)index
{
    currentDiveIndex = index;
    OneDiveView *diveView = (OneDiveView *)[self.scrviewMain viewWithTag:(kDiveViewTag + index)];
    if (diveView) {
        if (diveView.isLoadedData) {
            DiveInformation *diveInfoOfSelf = [diveView getDiveInformation];
            [self setCoordinateValue:diveInfoOfSelf];
        } else {
            [diveView setDiveID:[appManager.loginResult.user.allDiveIDs objectAtIndex:index]];
            DiveInformation *diveInfoOfSelf = [diveView getDiveInformation];
            [self setCoordinateValue:diveInfoOfSelf];

        }
    }
    if (appManager.loginResult.user.allDiveIDs.count > 0) {
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

- (void)diveViewsUpdate
{
    currentDiveIndex = -1;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
            [self setLayoutControllersToLandscape];
    } else {
            [self setLayoutControllersToPortrate];
    }
    currentDiveIndex = appManager.loginResult.user.allDiveIDs.count - 1;
    [self loadDiveData:currentDiveIndex];
}

- (void)updateUnit
{
    diveLengthUnit = [[userDefault objectForKey:kDiveboardUnit] intValue];
    for (id diveView in self.scrviewMain.subviews) {
        if ([diveView isKindOfClass:[OneDiveView class]]) {
            [(OneDiveView *)diveView  changeDepthUnit:diveLengthUnit];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block DiveDetailViewController *viewController;
    dispatch_queue_t dqueue = dispatch_queue_create("com.diveboard.gotodivedetail", 0);
    dispatch_async(dqueue, ^{
        viewController = [[DiveDetailViewController alloc] initWithDiveInformation:diveInfoOfSelf];
        viewController.diveView = diveView;
        viewController.diveListViewController = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:viewController animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });

    });
    
}

- (void) gotoDiveDetailViewController:(NSTimer *)dt
{
    
}

#pragma mark - 

- (IBAction)menuAction:(id)sender {
    [self showMenu:sender];
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Refresh"
                     image:Nil
                    target:self
                    action:@selector(refreshAction:)],
      
      [KxMenuItem menuItem:@"New dive"
                     image:Nil
                    target:self
                    action:@selector(newDiveAction:)],

      [KxMenuItem menuItem:@"Settings"
                     image:Nil
                    target:self
                    action:@selector(settingViewAction:)],

      [KxMenuItem menuItem:@"Report a bug"
                     image:Nil
                    target:self
                    action:@selector(reportABugAction:)],

      [KxMenuItem menuItem:@"Logout"
                     image:Nil
                    target:self
                    action:@selector(logoutAction:)],

      ];
    
    for (KxMenuItem *item in menuItems) {
        item.foreColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    }
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.frame.size.width - 70, self.viewBottom.frame.origin.y, 70, 50)
                 menuItems:menuItems];
}

#pragma mark - Refresh

- (void) refreshAction:(id)sender
{
    [self refreshLoadingViewShow:YES];
    [userDefault setObject:nil forKey:kLoadedDiveData(appManager.loginResult.user.ID)];
    [userDefault synchronize];
    
    NSString *loginMode = [userDefault objectForKey:kLoginMode];
    if ([loginMode isEqualToString:kLoginModeNative]) {
        NSDictionary *userInfo = [userDefault objectForKey:kLoginUserInfo];
        NSString *email = [userInfo objectForKey:@"email"];
        NSString *password = [userInfo objectForKey:@"password"];
        
        [self loginWithNativeUser:email password:password];
        
    } else if ([loginMode isEqualToString:kLoginModeFB]) {
        
        NSDictionary *fbUserInfo = [userDefault objectForKey:kLoginUserInfo];
        
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

        [self requestResultCheckingWithObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self refreshLoadingViewShow:NO];
    }];
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
        [self refreshLoadingViewShow:NO];
    }];
}

- (void) requestResultCheckingWithObject:(id)responseObject
{
    if (responseObject) {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        NSLog(@"%@", data);
        if ([[data objectForKey:@"success"] boolValue]) {
            appManager.loginResult = [[LoginResult alloc] initWithDictionary:data];
            appManager.loginResult.user.allDiveIDs = [NSMutableArray arrayWithArray:[[appManager.loginResult.user.allDiveIDs reverseObjectEnumerator] allObjects]];
            
            currentDiveIndex = -1;
            [self.scrviewMain setContentOffset:CGPointMake(0, 0) animated:NO];
            
            if (isPortrateScreen) {
                [self setLayoutControllersToPortrate];
            } else {
                [self setLayoutControllersToLandscape];
            }
            
            [self startPreloadDiveData];
        } else {
            
        }
    }
    [self refreshLoadingViewShow:NO];
}

- (void) refreshLoadingViewShow:(BOOL)flag
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = flag;
    if (flag) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Refreshing...";
        hud.labelFont = [UIFont fontWithName:kDefaultFontName size:14.0f];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - New Dive

- (void) newDiveAction:(id)sender
{
    DiveEditViewController *viewController = [[DiveEditViewController alloc] initWithDiveData:nil];
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)diveEditFinish:(DiveInformation *)diveInfo
{
    [appManager.loginResult.user.allDiveIDs addObject:diveInfo.ID];
//    currentDiveIndex = -1;
    [self diveViewsUpdate];
}

#pragma mark - Setting 

- (void) settingViewAction:(id)sender
{
    SettingViewController *viewController = [[SettingViewController alloc] init];
    viewController.parent = self;
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

#pragma mark - Report a bug

-(void) reportABugAction:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setToRecipients:@[@"support@diveboard.com"]];
        [mailView setSubject:@"Report a Bug"];
        [mailView setMessageBody:@"I have found a bug in DiveBoard app. That is as follows. \n" isHTML:YES];
        
        //        UIImage *newImage = self.detail_imgView.image;
        
        [self presentViewController:mailView animated:YES completion:nil];
        //        [mailView release];
        
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"error" message:[NSString stringWithFormat:@"error %@",[error description]] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles: nil];
        [alert show];
    }
    /* else {
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Mail transfered successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      [self dismissViewControllerAnimated:YES completion:nil];
      } */
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void) logoutAction:(id)sender
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:kLoginUserInfo];
    if ([userInfo objectForKey:@"email"]) {
        NSString *email = [userInfo objectForKey:@"email"];
        [userDefault setObject:@{@"email": email, @"password": @""} forKey:kLoginUserInfo];
    }
    [userDefault removeObjectForKey:kLoginMode];
    [userDefault synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
