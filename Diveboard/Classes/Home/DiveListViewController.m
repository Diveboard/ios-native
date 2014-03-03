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


#define kDiveViewTag       300

@interface DiveListViewController ()
{
    AppManager *appManager;
    NSUserDefaults *userDefault;
    
    DiveCountlineView *rulerView;
    OneDiveView *oneDiveView;
    
    int diveCount;
    int currentDiveIndex;
    
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

- (void) startPreloadDiveData
{
    NSDictionary *tempData = [userDefault objectForKey:kLoadedDiveData(appManager.loginResult.user.ID)];
    if (tempData && tempData.count > 0) {
        appManager.loadedDives = [[NSMutableDictionary alloc] initWithDictionary:tempData];
    } else {
        appManager.loadedDives = [[NSMutableDictionary alloc] init];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(preloadDiveData) userInfo:Nil repeats:NO];

}

- (void) preloadDiveData
{
    static int index = 0;
    int tIndex = (appManager.loginResult.user.allDiveIDs.count - 1) - index;
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
    index ++;
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
        NSLog(@"%@ preload one complete!----", diveID);
        if (responseObject) {
            [appManager.loadedDives setObject:responseObject forKey:diveID];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@", error);
    }];
    
}

- (void) initMethod
{
    _lblBottomTitle.font = [UIFont fontWithName:kDefaultFontName size:10.0f];
    _lblCoordinate.font  = [UIFont fontWithName:kDefaultFontName size:18.0f];
    currentDiveIndex = -1;
    
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        NSLog(@"Landscape");
        [self setLayoutControllersToLandscape];
        
    } else {
        NSLog(@"Portrait");
        [self setLayoutControllersToPortrate];
        
    }
    
//    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait ||
//        [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
//        [self setLayoutControllersToPortrate];
//    } else {
//        [self setLayoutControllersToLandscape];
//    }

}

- (void)viewDidAppear:(BOOL)animated
{
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        NSLog(@"Landscape");
        if (oOrientation == UIInterfaceOrientationPortrait) {
            [self setLayoutControllersToLandscape];
        }
        
        
    } else {
        NSLog(@"Portrait");
        if (oOrientation == UIInterfaceOrientationLandscapeLeft) {
            [self setLayoutControllersToPortrate];
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
    rulerView = [[DiveCountlineView alloc] initWithFrame:CGRectMake(rootSize.width * 0.0625,
                                                                    rootSize.height - 100,
                                                                    rootSize.width * 0.875,
                                                                    50)];
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
    
    [self.scrviewMain setFrame:CGRectMake(0, 45, rootSize.width, 420)];

    for (int i = 0; i < diveCount; i ++) {
        OneDiveView *diveView = [[OneDiveView alloc] initWithFrame:CGRectMake(20 + (rootSize.width * i), 0, 280, 420)
                                                            diveID:[appManager.loginResult.user.allDiveIDs objectAtIndex:i] rotate:(UIInterfaceOrientationPortrait)];
        diveView.tag = (kDiveViewTag + i);
        diveView.diveIndex = i;
        diveView.delegate = self;
        [self.scrviewMain addSubview:diveView];
    }
    
    [self.scrviewMain setContentSize:CGSizeMake(rootSize.width * diveCount, 420)];
    
    [self.scrviewMain setContentOffset:CGPointMake(self.scrviewMain.frame.size.width * (currentDiveIndex), 0)
                              animated:YES];

    
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
    rulerView = [[DiveCountlineView alloc] initWithFrame:CGRectMake(rootSize.width * 0.11,
                                                                    rootSize.height - 90,
                                                                    rootSize.width * 0.78,
                                                                    50)];
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
    
    [self.scrviewMain setFrame:CGRectMake((rootSize.width - oneDiveViewWidth) / 2 - dx, 20, oneDiveViewWidth + dx * 2,  oneDiveViewHeight)];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self setLayoutControllersToLandscape];
    } else {
        [self setLayoutControllersToPortrate];
    }

}

- (void)setCoordinateValue:(DiveInformation *)diveInfoOfSelf
{
    self.lblCoordinate.text = [NSString stringWithFormat:@"%@°N,  %@°E", diveInfoOfSelf.spotInfo.lat, diveInfoOfSelf.spotInfo.lng];
    
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
    [rulerView setCurrentValue:(index + 1)];
    
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
        
    }];
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
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"New dive"
                     image:Nil
                    target:self
                    action:@selector(pushMenuItem:)],

      [KxMenuItem menuItem:@"Settings"
                     image:Nil
                    target:self
                    action:@selector(pushMenuItem:)],

      [KxMenuItem menuItem:@"Report a bug"
                     image:Nil
                    target:self
                    action:@selector(pushMenuItem:)],

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

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
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
