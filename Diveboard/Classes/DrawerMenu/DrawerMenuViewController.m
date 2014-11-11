//
//  DrawerMenuViewController.m
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/14/14.
//  Copyright (c) 2014 threek. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "DrawerMenuViewController.h"
#import "OSBlurSlideMenu.h"
#import "DiveListViewController.h"
#import "DiveEditViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "ClosestShopViewController.h"
#import "WalletViewController.h"
#import "Global.h"
#import "Appirater.h"
#import "UserVoice.h"
@interface DrawerMenuViewController ()<UIAlertViewDelegate>
{

}
@end
static DrawerMenuViewController *sharedMenu = nil;

@implementation DrawerMenuViewController

+ (DrawerMenuViewController*)sharedMenu {
	
	if(sharedMenu == nil)
		sharedMenu = [[DrawerMenuViewController alloc] initWithNibName:@"DrawerMenuViewController" bundle:nil];
	
    
	return sharedMenu;
}

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
    m_MenuArray = [[NSMutableArray alloc] initWithObjects:@"Logbook",@"NewDive",@"Wallet",@"Closest Shop",@"REFRESH",@"SETTINGS",@"REPORT A BUG",@"LOGOUT",@"RATE APP", nil];
    
    m_CurrentMenuIndex = 0;
    
    

    
    
    [self reloadMenu];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMenuIndex:(int)menuIndex{
    m_CurrentMenuIndex = menuIndex;
    [self reloadMenu];
}
-(void)reloadMenu{
    
    if (([[NSUserDefaults standardUserDefaults] boolForKey:kAppiraterRatedCurrentVersion] || [[NSUserDefaults standardUserDefaults] boolForKey:kAppiraterDeclinedToRate]) && m_MenuArray.count > 8) {
        
        [m_MenuArray removeLastObject];
        
    }
    
    [m_tableViewMenu reloadData];
    
}

#pragma mark - UITableView Datasource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {

        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIView* selectedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
//        [selectedBackView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0]];
        
        [selectedBackView setBackgroundColor:[UIColor grayColor]];
        [cell setSelectedBackgroundView:selectedBackView];
        
    }else{
        
        UIImageView* img = (UIImageView*)[cell viewWithTag:100];
        [img removeFromSuperview];
        
    }

    if (indexPath.row == m_CurrentMenuIndex) {
        
        UIImageView *sel_img =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 2, cell.bounds.size.height-2)];
        [sel_img setTag:100];
        sel_img.backgroundColor = kMainDefaultColor;
        [sel_img setTag:100];

        [cell addSubview:sel_img];
        m_CurrentMenuIndex = (int)indexPath.row;
    }
    
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    if (indexPath.row > 3) {
        
        [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontName size:13.0f]];
        
    }else{
        
        [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontName size:18.0f]];
        
    }
    [cell.textLabel setText:m_MenuArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (self.isEditedDive) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"EXIT" message:@"Exit without save?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert setTag:100];
        [alert show];
        
    }else{
        [self didSelectDrawerMenu:(int)indexPath.row];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return m_MenuArray.count;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 100) {

        if (buttonIndex == 1) {
            
            [self didSelectDrawerMenu:(int)m_tableViewMenu.indexPathForSelectedRow.row];
            
        }else{
            
            [m_tableViewMenu deselectRowAtIndexPath:[NSIndexPath indexPathForRow:m_tableViewMenu.indexPathForSelectedRow.row inSection:0] animated:YES];
            [self.slideMenuController closeMenuAnimated:YES completion:nil];
        }
        
    }
    
}
-(void)didSelectDrawerMenu:(int)menuIndex{
    
    [m_tableViewMenu deselectRowAtIndexPath:[NSIndexPath indexPathForRow:menuIndex inSection:0] animated:YES];
    
    [self.slideMenuController closeMenuAnimated:YES completion:nil];
    
    if (m_CurrentMenuIndex == menuIndex) {

        
        switch (menuIndex) {
            case 0:
                if (self.isShowList) {
                    return;
                }
                break;
            case 1:
                if (!self.isEditedDive) {
                    return;
                }
            default:
                return;
                break;
        }
        
    }
    
        self.isEditedDive = NO;
    
        switch (menuIndex) {
            case 0:
                [self logBookAction];
                break;
            case 1:
                [self newDiveAction];
                break;
            case 2:
                [self walletAction];
                break;
            case 3:
                [self closestShopAction];
                break;
            case 4:
                menuIndex = 0;
                [self refreshAction];
                break;
            case 5:
                [self settingViewAction];
                break;
            case 6:
                menuIndex = m_CurrentMenuIndex;
                [self reportABugAction];
                break;
            case 7:
                menuIndex = m_CurrentMenuIndex;
                [self logoutAction];
                break;
            case 8:
                menuIndex = m_CurrentMenuIndex;
                [self rateAppAction];
                break;
            default:
                break;
        }
        m_CurrentMenuIndex = menuIndex;
        

        [self reloadMenu];
    
}

-(void)logBookAction{
    
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    if (![AppManager sharedManager].diveListVC) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
        } else {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
        }
    }
    [nav setViewControllers:@[[AppManager sharedManager].diveListVC]];
    
    
    
}
-(void) newDiveAction{
    
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    DiveEditViewController *viewController = [[DiveEditViewController alloc] initWithDiveData:nil];
    //    viewController.delegate = self;
    [nav setViewControllers:@[viewController]];
    
    
}
- (void) walletAction
{
 
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    WalletViewController *viewController = [[WalletViewController alloc] initWithNibName:@"WalletViewController" bundle:nil];
    [nav setViewControllers:@[viewController]];
    
}

- (void) closestShopAction{
    
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    ClosestShopViewController *viewController = [[ClosestShopViewController alloc] init];
    [nav setViewControllers:@[viewController]];

    
}
- (void) refreshAction
{
    
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    [AppManager sharedManager].currentSudoID = 0;

    if (![AppManager sharedManager].diveListVC) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
        } else {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
        }
    }
    [[AppManager sharedManager].diveListVC refreshAction];
    
    [nav setViewControllers:@[[AppManager sharedManager].diveListVC]];
    
    
}

- (void) settingViewAction
{
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    SettingViewController *viewController = [[SettingViewController alloc] init];
    [nav setViewControllers:@[viewController]];

}

#pragma mark - Report a bug

-(void) reportABugAction
{
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserInfo];
    NSString *email = @"";
    if ([userInfo objectForKey:@"email"]) {
        email = [userInfo objectForKey:@"email"];
    }
    
    UVConfig *config = [UVConfig configWithSite:@"diveboard.uservoice.com" andKey:@"HQhxlFO3whmqF5eMOr5z8A" andSecret:@"zmfWzeYUQmDlO2BJzlHeLfaKiCHocp2UZDXYeREl0" andEmail:email andDisplayName:[AppManager sharedManager].loginResult.user.nickName andGUID:([email isEqualToString:@""]) ? nil : email];
    
    
    
    
    [UserVoice initialize:config];
    
    
    [UserVoice presentUserVoiceContactUsFormForParentViewController:self];

    
    
}

- (void) logoutAction
{
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [userDefault objectForKey:kLoginUserInfo];
    if ([userInfo objectForKey:@"email"]) {
        NSString *email = [userInfo objectForKey:@"email"];
        [userDefault setObject:@{@"email": email, @"password": @""} forKey:kLoginUserInfo];
    }
    [userDefault removeObjectForKey:kLoginMode];
    [userDefault synchronize];
    [[DiveOfflineModeManager sharedManager] deleteLoginResultData];

    //    if (preloadRequestManagers) {
    //        for (AFHTTPRequestOperationManager *manager in preloadRequestManagers) {
    //            [manager.operationQueue cancelAllOperations];
    //        }
    //        [preloadRequestManagers removeAllObjects];
    //        preloadRequestManagers = nil;
    //    }
    
    LoginViewController *loginVC;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
    } else {
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController-ipad" bundle:Nil];
        
    }
    [AppManager sharedManager].diveListVC = nil;
    [[AppManager sharedManager].loadedDives removeAllObjects];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    
    [navigationController setNavigationBarHidden:YES];
    
    [self.view.window setRootViewController:navigationController];
    
}

- (void)rateAppAction
{
    
    [Appirater rateApp];
    [self reloadMenu];
    
}

- (void)toggleDrawerMenu{
    
    if (self.slideMenuController.isMenuOpen){
        
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
        
    }else{
        
        [self.slideMenuController openMenuAnimated:YES completion:nil];
    }
    
}

@end
