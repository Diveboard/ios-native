//
//  SettingViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "SettingViewController.h"
//#import "SGActionView.h"
#import "UIViewController+MJPopupViewController.h"
#import "DBUnitSelectViewController.h"
#import "MBProgressHUD+Add.h"
#import "AFNetworking.h"
#import "DiveListViewController.h"


@interface SettingViewController () <DBUnitSelectDelegate, UIAlertViewDelegate>
{
    int selectedIndex;
    DBUnitSelectViewController *unitSelectViewController;
}

@end

@implementation SettingViewController

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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    selectedIndex = [ud objectForKey:kDiveboardUnit] == nil ? 1 : [[ud objectForKey:kDiveboardUnit] intValue];
    
    [lblVersionNumber setText:[NSString stringWithFormat:@"Application Version : %@",
                               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
<<<<<<< HEAD
    AppManager *appManager = [AppManager sharedManager];
    
    // ############
    // #### final version
    // ###############
    if ([appManager.loginResult.user.adminRight intValue] >= 4) {
        [btnAccessSudo setHidden:NO];
        if (appManager.currentSudoID > 0) {
            [btnAccessSudo setSelected:YES];
        }
        else {
            [btnAccessSudo setSelected:NO];
        }
    }
    else {
        [btnAccessSudo setHidden:YES];
    }
    
    // ############
    // #### test version
    // ###############
//    if (appManager.currentSudoID > 0) {
//        [btnAccessSudo setSelected:YES];
//    }
//    else {
//        [btnAccessSudo setSelected:NO];
//    }
=======
>>>>>>> 685ccbd31b49cbe284c2f1c0074f39fcac1849d8

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [btnUnit setTitle:(selectedIndex == 0 ? @"Imperial" : @"Metric")
             forState:(UIControlStateNormal)];
    [scrview setContentSize:CGSizeMake(320, 300)];
    
    [lblPendingRequest setText:[NSString stringWithFormat:@"%d", [DiveOfflineModeManager sharedManager].pendingRequestCount]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([[ud objectForKey:kDiveboardUnit] intValue] != selectedIndex) {
        [ud setObject:@(selectedIndex) forKey:kDiveboardUnit];
        [ud synchronize];
        [self.parent updateUnit];
    }
}

- (IBAction)backActions:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)unitSelectAction:(id)sender {
//    [SGActionView showSheetWithTitle:@"Select Unit"
//                          itemTitles:@[ @"Imperial", @"Metric"]
//                       itemSubTitles:@[ @"Feet", @"Meter"]
//                       selectedIndex:selectedIndex
//                      selectedHandle:^(NSInteger index){
//                          if (index != selectedIndex) {
//                              selectedIndex = index;
//                              if (index == 0)
//                                  [btnUnit setTitle:@"Imperial" forState:(UIControlStateNormal)];
//                              if (index == 1)
//                                  [btnUnit setTitle:@"Metric" forState:(UIControlStateNormal)];
//                          }
//                      }];
    unitSelectViewController = [[DBUnitSelectViewController alloc] initWithNibName:@"DBUnitSelectViewController" bundle:nil];
    [unitSelectViewController setDelegate:self];
    unitSelectViewController.selectedIndex = selectedIndex;
    [self presentPopupViewController:unitSelectViewController animationType:MJPopupViewAnimationFade];

    
}

- (void)DBUnitSelectAction:(NSString *)unit
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    unitSelectViewController = nil;
    if (![unit isEqualToString:@"Cancel"]) {
         [btnUnit setTitle:unit forState:(UIControlStateNormal)];
        if ([unit isEqualToString:@"Imperial"]) {
            selectedIndex = 0;
        } else {
            selectedIndex = 1;
        }
    }
}

- (IBAction) updatePendingRequestAction:(id)sender
{
    DiveOfflineModeManager *offlineManager = [DiveOfflineModeManager sharedManager];
    if (offlineManager.pendingRequestCount) {
        [offlineManager updateLocalDiveToServer:^{
            [lblPendingRequest setText:[NSString stringWithFormat:@"%d", offlineManager.pendingRequestCount]];
        }];
    }
}

#define sudoIDAlertTag   140

- (IBAction) accessSudoAction:(id)sender
{
    // exit sudo
    if (btnAccessSudo.isSelected) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [AppManager sharedManager].currentSudoID = 0;
        }];
    }
    // access sudo
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sudo ID"
                                                            message:@"Type sudo ID"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        [alertView setTag:sudoIDAlertTag];
        [alertView setAlertViewStyle:(UIAlertViewStylePlainTextInput)];
        [alertView textFieldAtIndex:0].placeholder = @"Sudo ID";
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView show];
    }
}

#pragma mark - UIAlerView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == sudoIDAlertTag) {
        if (buttonIndex == 1) {
            NSString *sudoID = [alertView textFieldAtIndex:0].text;
            if ([sudoID intValue] > 0) {
                NSLog(@"sudo ID : %@", sudoID);
                [self loadDiveIDsWithSudoID:sudoID];
            }
        }
    }
    NSLog(@"alert!");
    
}

#pragma mark - loading dive information by Sudo ID

- (void) loadDiveIDsWithSudoID:(NSString *)sudoID
{
    [MBProgressHUD showMessag:@"Loading..." toView:self.view];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/user/%@", SERVER_URL, sudoID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:requestURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                
                AppManager *appManager = [AppManager sharedManager];
                appManager.currentSudoID = [sudoID intValue];
                appManager.loginResult.user = [[UserInfomation alloc] initWithDictionary:[responseObject objectForKey:@"result"]];
                
                DiveListViewController *viewController;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    viewController = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
                } else {
                    viewController = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
                }
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [navController setNavigationBarHidden:YES animated:NO];
                
                [self.navigationController presentViewController:navController animated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't load dives" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    }];
    
}

@end
