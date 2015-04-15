//
//  SettingViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "SettingViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "DiveListViewController.h"
#import "DrawerMenuViewController.h"
#import "KLCPopup.h"
#import "RadioPickerViewController.h"
#import "SVProgressHUD.h"
#import "OSBlurSlideMenu.h"

#define sudoIDAlertTag   140
#define clearCacheAlertTag   150

@interface SettingViewController () <UIAlertViewDelegate,RadioPickerViewControllerDelegate>
{
    NSMutableArray* m_arrSections;
    NSMutableArray* m_arrSettingData;
    KLCPopup* m_KLCPopup;
    RadioPickerViewController *m_unitChangeVC ;
    RadioPickerViewController *m_picQualityChangeVC ;
    
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
    
    
    m_arrSections =[NSMutableArray arrayWithObjects:@"   USER SETTINGS",@"   SYSTEM SETTINGS",@"   APPLICATION INFORMATION",@"   ADMIN",nil];

    if ([[AppManager sharedManager].loginResult.user.adminRight intValue] >= 4) {
//        if ([AppManager sharedManager].currentSudoID > 0) {
//            [m_arrSections removeLastObject];
//        }
    }
    else {
        
        if ([AppManager sharedManager].currentSudoID < 1) {
         
            [m_arrSections removeLastObject];
            
        }
        
        
        
    }
    
    
    m_arrSettingData = [[NSMutableArray alloc] init];
    
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([m_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [m_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(settingDataShow) userInfo:nil repeats:YES];
    
    [self settingDataShow];
    
}

-(void)settingDataShow
{
 
    [m_arrSettingData removeAllObjects];
    
///////// USER SETTINGS
    NSDictionary* unitDic = @{@"title": @"Unit",
                              @"description": ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial ? @"Imperial" : @"Metric"),
                              @"value":@""
                              };
    
    NSMutableArray* arrUserData = [NSMutableArray arrayWithObject:unitDic];
    
    [m_arrSettingData addObject:arrUserData];
    
    
//////// SYSTEM SETTINGS
    

    NSDictionary* picQualityDic = @{@"title": @"Picture Quality",
                              @"description": ([AppManager sharedManager].userSettings.pictureQuality == UserSettingPictureQualityTypeMedium ? @"Medium Definition" : @"High Definition"),
                              @"value":@""
                              };
    
    NSDictionary* downloadMethodDic = @{@"title": @"Download Method",
                                    @"description": @"Allow pictures download over 3G/4G network",
                                    @"value":@""
                                    };
    
    
    NSMutableArray* arrSystemData = [NSMutableArray arrayWithObjects:picQualityDic,downloadMethodDic, nil];
    
    [m_arrSettingData addObject:arrSystemData];
    
//////// APPLICATION INFORMATION
    
    NSString* strRemainPic = [NSString stringWithFormat:@"%d",(int)[AppManager sharedManager].remainingPictures.count];
    
    if (![AppManager sharedManager].diveListVC.isCompletePreLoad) {
        
        strRemainPic = @"Loading...";
        
    }
    
    NSDictionary* remainPicDic = @{@"title": @"Remaining Pictures:",
                                        @"description": @"",
                                        @"value":strRemainPic
                                        };
    
    NSDictionary* pendingReqDic = @{@"title": @"Pending Requests:",
                                   @"description": @"",
                                   @"value":[NSString stringWithFormat:@"%d", [DiveOfflineModeManager sharedManager].pendingRequestCount]
                                   };

    NSDictionary* clearCacheDic = @{@"title": @"Clear Cache",
                                   @"description": @"",
                                   @"value":@""
                                   };

    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString* strSpotDBUpdate = @"Not yet";
    NSDate* spotDBUpdateDate = [ud objectForKey:kSpotDBUpdateDate];
    
    if (spotDBUpdateDate) {
     
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        
        strSpotDBUpdate = [NSString stringWithFormat:@"Latest update: %@",[formatter stringFromDate:spotDBUpdateDate]];
    }

    NSDictionary* spotDBDic = @{@"title": @"Spot Database",
                                    @"description": strSpotDBUpdate,
                                    @"value":@""
                                    };
    
    NSDictionary* appVersionDic = @{@"title": @"Application Version",
                                    @"description": [NSString stringWithFormat:@"Application Version : %@",
                                                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]],
                                @"value":@""
                                };
    
    
    NSMutableArray* arrAppData = [NSMutableArray arrayWithObjects:remainPicDic,pendingReqDic,clearCacheDic,spotDBDic,appVersionDic, nil];
    
    [m_arrSettingData addObject:arrAppData];
    
    
///////// ADMIN
    if (m_arrSections.count > 3) {
        
        NSDictionary* accessSudo = @{@"title": @"Access Sudo",
                                     @"description": @"",
                                     @"value":@""
                                     };
        
        
        NSDictionary* exitSudo = @{@"title": @"Exit Sudo",
                                   @"description": @"",
                                   @"value":@""
                                   };
        
        NSMutableArray* arrAdminData = [[NSMutableArray alloc] init];
        
        [arrAdminData addObject:accessSudo];
        
        
        if ([AppManager sharedManager].currentSudoID > 0) {
            
            [arrAdminData  addObject:exitSudo];
            
        }
        
        
        [m_arrSettingData addObject:arrAdminData];
        
    }
    
    [m_tableView reloadData];
    
    
}






- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void) updatePendingRequestAction
{
    
    DiveOfflineModeManager *offlineManager = [DiveOfflineModeManager sharedManager];
    
    if (offlineManager.isOffline) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    }else{
        
        if (offlineManager.pendingRequestCount) {
            
            [[AppManager sharedManager].diveListVC refreshAction];
//            [offlineManager updateLocalDiveToServer:^{
//                [self settingDataShow];
//            }];
        }
        
    }
    
    
}

- (void) accessSudoAction
{
//    // exit sudo
//    if (btnAccessSudo.isSelected) {
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            [AppManager sharedManager].currentSudoID = 0;
//        }];
//    }
//    // access sudo
//    else {
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
//    }
}

- (void)exitSudoAction
{
    
    [AppManager sharedManager].currentSudoID = 0;
    
    if (![AppManager sharedManager].diveListVC) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
        } else {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
        }
    }
    
    
    [[AppManager sharedManager].diveListVC refreshAction];
    [[DrawerMenuViewController sharedMenu] setMenuIndex:0];
    UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
    
    [nav setViewControllers:@[[AppManager sharedManager].diveListVC]];
    
}

#pragma mark - UIAlerView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == sudoIDAlertTag) {
        if (buttonIndex == 1) {
            NSString *sudoID = [alertView textFieldAtIndex:0].text;
            if ([sudoID intValue] > 0) {
                [self loadDiveIDsWithSudoID:sudoID];
            }
        }
    }else if (alertView.tag == clearCacheAlertTag){
        
        if (buttonIndex == 1) {
            [self onClearCache];
        }
        
    }
    
}

#pragma mark - loading dive information by Sudo ID

- (void) loadDiveIDsWithSudoID:(NSString *)sudoID
{
    [SVProgressHUD showWithStatus:@"Loading Data" maskImage:[UIImage imageNamed:@"progress_mask"]];
    
    if ([AppManager sharedManager].diveListVC.preloadRequestManagers) {
        
        for (AFHTTPRequestOperationManager *manager in [AppManager sharedManager].diveListVC.preloadRequestManagers) {
            
            [manager.operationQueue cancelAllOperations];
        }
        
        [[AppManager sharedManager].diveListVC.preloadRequestManagers removeAllObjects];
        
        [AppManager sharedManager].diveListVC.preloadRequestManagers = nil;
    }
    
    
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/user/%@", SERVER_URL, sudoID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:REQUEST_TIME_OUT];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:requestURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                
                [AppManager sharedManager].currentSudoID = [sudoID intValue];
                [AppManager sharedManager].loginResult.user = [[UserInfomation alloc] initWithDictionary:[responseObject objectForKey:@"result"]];
                [[AppManager sharedManager].loadedDives removeAllObjects];
                
                if (![AppManager sharedManager].diveListVC) {
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                        [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
                    } else {
                        [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
                    }
                }
                
                
                [[AppManager sharedManager].diveListVC diveViewsUpdate];
                [[DrawerMenuViewController sharedMenu] setMenuIndex:0];
                UINavigationController* nav = (UINavigationController*)self.slideMenuController.contentViewController;
                
                [nav setViewControllers:@[[AppManager sharedManager].diveListVC]];

//                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[AppManager sharedManager].diveListVC];
//                [navController setNavigationBarHidden:YES animated:NO];
//                
//                [self.navigationController presentViewController:navController animated:YES completion:^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
                
            }
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't load dives" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    }];
    
}

-(void)onDrawer:(id)sender{
    
    [[DrawerMenuViewController sharedMenu] toggleDrawerMenu];
    
    
}

-(void)onChangeUnit
{
    if (!m_unitChangeVC) {
        m_unitChangeVC = [[RadioPickerViewController alloc] initWithList:@[@"Imperial",@"Metric"] selectedIndex:[AppManager sharedManager].userSettings.unit];
        m_unitChangeVC.delegate = self;
    }
    [self showPopupView:m_unitChangeVC.view];
    
    
}

-(void)onChangePicQuality{

    if (!m_picQualityChangeVC) {
        
        m_picQualityChangeVC = [[RadioPickerViewController alloc] initWithList:@[@"Medium Definition",@"High Definition"] selectedIndex:[AppManager sharedManager].userSettings.pictureQuality];
        m_picQualityChangeVC.delegate = self;
        
    }
    [self showPopupView:m_picQualityChangeVC.view];
}
- (void)onClearCache{
    
    [SVProgressHUD showWithStatus:@"Cleaning..."];
    
    [[DiveOfflineModeManager sharedManager] clearCache];
    [SVProgressHUD showSuccessWithStatus:@"Cache cleared"];
    
}
#pragma mark TableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    @try {
        NSArray* arrData = [m_arrSettingData objectAtIndex:section];
        return arrData.count;
    }
    @catch (NSException *exception) {
        return 0;
    }

    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return m_arrSections.count;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return m_arrSections[section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
        
        
        UIView* selectedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        [selectedBackView setBackgroundColor:kMainDefaultColor];
        [cell setSelectedBackgroundView:selectedBackView];
        
        [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontNameBold size:14]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:kDefaultFontName size:11]];
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        NSString* strImageName = @"btn_unchecked.png";
        if ([AppManager sharedManager].userSettings.downloadMethod == UserSettingDownloadTypeWWAN) {
            strImageName = @"btn_checked.png";
        }
        [imgView setImage:[UIImage imageNamed:strImageName]];
        cell.accessoryView = imgView;
        
    }else{
        cell.accessoryView = nil;
    }
    NSArray* arrData = [m_arrSettingData objectAtIndex:indexPath.section];
    
    NSDictionary* dicData = [arrData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[dicData objectForKey:@"title"],[dicData objectForKey:@"value"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dicData objectForKey:@"description"]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                [self onChangeUnit];
                break;
            default:
                break;
        }
        
        
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [self onChangePicQuality];
                break;
            case 1:
                {
                    [[AppManager sharedManager].userSettings setDownloadMethod:![AppManager sharedManager].userSettings.downloadMethod];
                    [self settingDataShow];
                    
                }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        
        switch (indexPath.row) {
            case 1:
                
                [self updatePendingRequestAction];
                
                break;
            case 2:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Clear Cache"
                                                                    message:@"Are you sure want to clear cache?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"OK", nil];
                [alertView setTag:clearCacheAlertTag];
                [alertView show];
            }

                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 3){
        
        switch (indexPath.row) {
            case 0:
                [self accessSudoAction];
                break;
            case 1:
                [self exitSudoAction];
                break;
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma KLCPopup

-(void) showPopupView:(UIView*)view{
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    m_KLCPopup = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [m_KLCPopup showWithLayout:layout];
    
}

#pragma RadioPickerViewControllerDelegate

-(void)didCancelRadioPickerViewController:(RadioPickerViewController *)pickerViewController{
    
    [m_KLCPopup dismissPresentingPopup];
    
}

-(void)didSelectRadioIndex:(int)selectedIndex pickerViewController:(RadioPickerViewController *)pickerViewController
{
    
    if (pickerViewController == m_unitChangeVC) {
        
        [[AppManager sharedManager].userSettings setUnit:selectedIndex];
        
    }else if (pickerViewController == m_picQualityChangeVC){
        
        [[AppManager sharedManager].userSettings setPictureQuality:selectedIndex];
        
    }
    
    [m_KLCPopup dismissPresentingPopup];
    [self settingDataShow];
    
}


@end
