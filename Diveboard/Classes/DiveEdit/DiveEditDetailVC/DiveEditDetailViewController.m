//
//  DiveEditDetailViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditDetailViewController.h"
#import "DiveInformation.h"
#import "DiveDatePicker.h"
#import "DiveEditValueViewController.h"
#import "KLCPopup.h"
#import "TKListPickerView.h"
#import "DiveEditReviewViewController.h"
#import "CheckListPickerView.h"
#import "DiveEditSafetyStopsViewController.h"
#import "DiveEditTanksUsedViewController.h"
#import "DrawerMenuViewController.h"
@interface DiveEditDetailViewController ()<DiveDatePickerDelegate,DiveEditValueViewControllerDataSource,DiveEditValueViewControllerDelegate,TKListPickerViewDelegate,CheckListPickerViewDelegate,DiveEditReviewViewControllerDelegate,SafetyStopsEditViewDelegate,DiveEditTanksUsedViewDelegate>
{
    DiveInformation *m_DiveInformation;
    NSMutableArray* m_tableData;
    int m_currentSelectedRow;
    KLCPopup* m_KLCPopup;
    DiveEditValueViewController *m_editValueVC;
    DiveEditSafetyStopsViewController *m_editSafetyStopView;
    DiveEditTanksUsedViewController *m_editTanksUsedView;
}

@end

@implementation DiveEditDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithDiveData:(DiveInformation *)diveInfo;
{
    NSString *nibFilename;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibFilename = @"DiveEditDetailViewController";
    } else {
        nibFilename = @"DiveEditDetailViewController-ipad";
    }
    nibFilename = @"DiveEditDetailViewController";
    
    self = [self initWithNibName:nibFilename bundle:nil];
    if (self) {
        m_DiveInformation = diveInfo;
        m_tableData = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([m_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [m_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self diveDataShow];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillLayoutSubviews
{
    [m_tableView reloadData];
}
- (void) diveDataShow
{
 
    [m_tableData removeAllObjects];
    
    
    NSString *dateString;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    //Optionally for time zone converstions
    dateString  = [formatter1 stringFromDate:today];
    
    NSString *timeString;
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm"];
    //Optionally for time zone converstions
    timeString   = [formatter2 stringFromDate:today];
    
    if ([m_DiveInformation.date isEqualToString:@""]) {
        m_DiveInformation.date = dateString;
    }
    
    
    if ([m_DiveInformation.time isEqualToString:@""]) {
        m_DiveInformation.time = timeString;
    }
    
    if ([m_DiveInformation.maxDepthUnit isEqualToString:@""]) {
        
        m_DiveInformation.maxDepthUnit =  ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"ft" : @"m" ;
//        m_DiveInformation.maxDepthUnit = [AppManager sharedManager].loginResult.preferredUnits.distance;
        
    }

    
    if ([m_DiveInformation.weight.unit isEqualToString:@""]) {
        
       m_DiveInformation.weight.unit =  ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"lbs" : @"kg";
//       m_DiveInformation.weight.unit =  [AppManager sharedManager].loginResult.preferredUnits.weight;
        
    }
    
    if ([m_DiveInformation.temp.surfaceUnit isEqualToString:@""]) {
     
        m_DiveInformation.temp.surfaceUnit = ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"F" : @"C";
//        m_DiveInformation.temp.surfaceUnit = [AppManager sharedManager].loginResult.preferredUnits.temperature;
        
    }
    
    if ([m_DiveInformation.temp.bottomUnit isEqualToString:@""]) {
        
        m_DiveInformation.temp.bottomUnit = ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"F" : @"C";
//        m_DiveInformation.temp.bottomUnit = [AppManager sharedManager].loginResult.preferredUnits.temperature;
        
        
        
    }
    
    
    
    NSDictionary* dicDiveDate = @{@"title":@"DATE",@"value": m_DiveInformation.date};
    [m_tableData addObject:dicDiveDate];
    
    NSDictionary* dicDiveTime = @{@"title":@"TIME IN",@"value": m_DiveInformation.time };
    [m_tableData addObject:dicDiveTime];

    NSDictionary* dicDiveDepth = @{@"title":@"MAX DEPTH",@"value":([m_DiveInformation.maxDepth floatValue] > 0) ? [m_DiveInformation maxDepthValueWithUnit] : @""};
    
    [m_tableData addObject:dicDiveDepth];
    
    NSDictionary* dicDiveDuration = @{@"title":@"DURATION",@"value":([m_DiveInformation.duration floatValue] > 0) ? [NSString stringWithFormat:@"%@ mins",m_DiveInformation.duration] : @""};
    
    [m_tableData addObject:dicDiveDuration];

     NSString* strSafety = @"";
     NSString* ints = @"";
    for (SafetyStop* safetyStop in m_DiveInformation.SafetyStops) {
        
        strSafety = [NSString stringWithFormat:@"%@%@%@%@ - %@mins",strSafety,ints,safetyStop.depth,safetyStop.depthUnit,safetyStop.duration];
        ints = @", ";
        
    }
    
    
    NSDictionary* dicDiveSafetyStops = @{@"title":@"SAFETY STOPS",@"value": strSafety};
    [m_tableData addObject:dicDiveSafetyStops];
    
    NSDictionary* dicDiveWeights = @{@"title":@"WEIGHTS",@"value":([m_DiveInformation.weight.value floatValue] > 0) ? [m_DiveInformation.weight valueWithUnit] : @""};
    
    
    
    [m_tableData addObject:dicDiveWeights];
    
    
    NSDictionary* dicDiveNumber = @{@"title":@"DIVE NUMBER",@"value": m_DiveInformation.number};
    [m_tableData addObject:dicDiveNumber];
    
    NSDictionary* dicDiveGuideName = @{@"title":@"GUIDE NAME",@"value": m_DiveInformation.guideName};
    [m_tableData addObject:dicDiveGuideName];

    NSDictionary* dicDiveTripName = @{@"title":@"TRIP NAME",@"value": m_DiveInformation.tripName};
    [m_tableData addObject:dicDiveTripName];
    
    
    NSString* strDiveType = @"";
    
    if (m_DiveInformation.diveType && m_DiveInformation.diveType.count > 0) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSString* diveType in m_DiveInformation.diveType) {
            
            [arr addObject:[diveType capitalizedString]];
            
        }
        
        strDiveType = [arr componentsJoinedByString:@", "];
        
    }
    NSDictionary* dicDiveType = @{@"title":@"DIVING TYPE",@"value": strDiveType};
    [m_tableData addObject:dicDiveType];


    NSDictionary* dicDiveVisibility = @{@"title":@"VISIBILITY",@"value": [m_DiveInformation.visibility capitalizedString]};
    [m_tableData addObject:dicDiveVisibility];
    
    NSDictionary* dicDiveCurrent = @{@"title":@"CURRENT",@"value": [m_DiveInformation.current capitalizedString]};
    [m_tableData addObject:dicDiveCurrent];

    
    NSDictionary* dicDiveSurfaceTemp = @{@"title":@"SURFACE TEMPERATURE",@"value":[m_DiveInformation.temp surfaceValueWithUnit]};
    [m_tableData addObject:dicDiveSurfaceTemp];
    
    
    
    NSDictionary* dicDiveBottomTemp = @{@"title":@"BOTTOM TEMPERATURE",@"value": [m_DiveInformation.temp bottomValueWithUnit]};
    [m_tableData addObject:dicDiveBottomTemp];

    NSDictionary* dicDiveAltitude = @{@"title":@"ALTITUDE",@"value":([m_DiveInformation.altitude floatValue] > 0) ? [DiveInformation unitOfLengthWithValue:m_DiveInformation.altitude defaultUnit:@"m"] : @""};
    [m_tableData addObject:dicDiveAltitude];

    NSDictionary* dicDiveWater = @{@"title":@"WATER TYPE",@"value": [m_DiveInformation.water capitalizedString]};
    [m_tableData addObject:dicDiveWater];

    NSDictionary* dicDivePrivacy = @{@"title":@"DIVE PRIVACY",@"value": [m_DiveInformation.privacy isEqualToString:@"0"] ? @YES : @NO};
    
    [m_tableData addObject:dicDivePrivacy];

    
    NSString* strTanksUsed = @"";
    
    if (m_DiveInformation.tanksUsed.count > 0) {
        
        if (m_DiveInformation.tanksUsed.count > 1) {
            
            strTanksUsed = [NSString stringWithFormat:@"%d tanks used",(int)m_DiveInformation.tanksUsed.count];
            
        }else{
            
            strTanksUsed = [NSString stringWithFormat:@"%d tank used",(int)m_DiveInformation.tanksUsed.count];
            
        }
        
    }
    
    NSDictionary* dicDiveTanksUsed = @{@"title":@"TANKS USED",@"value":strTanksUsed};
    [m_tableData addObject:dicDiveTanksUsed];

    NSArray* arrRatings1 = @[@"",@"Terrible",@"Poor",@"Average",@"Very good",@"Excellent!"];
    NSArray* arrRatings2 = @[@"",@"Trivial",@"Simple",@"Somewhat simple",@"Tricky",@"Hardcore!"];
    
    NSString* strReview = @"";
    
    if (m_DiveInformation.review.overall > 0) {
        
        strReview = [NSString stringWithFormat:@"Overall: %@. ",arrRatings1[m_DiveInformation.review.overall]];
    }
    
    if (m_DiveInformation.review.difficulty > 0) {
        
        strReview = [NSString stringWithFormat:@"%@Dive difficulty: %@. ",strReview,arrRatings2[m_DiveInformation.review.difficulty]];
        
    }
    
    if (m_DiveInformation.review.marine > 0) {
        
        strReview = [NSString stringWithFormat:@"%@Marine life: %@. ",strReview,arrRatings1[m_DiveInformation.review.marine]];
        
    }

    if (m_DiveInformation.review.bigfish > 0) {
        
        strReview = [NSString stringWithFormat:@"%@Big fish: %@. ",strReview,arrRatings1[m_DiveInformation.review.bigfish]];
        
    }

    if (m_DiveInformation.review.wreck > 0) {
        
        strReview = [NSString stringWithFormat:@"%@Wrecks sighted: %@. ",strReview,arrRatings1[m_DiveInformation.review.wreck]];
        
    }
    
    
    NSDictionary* dicDive = @{@"title":@"REVIEW",@"value": strReview};
    [m_tableData addObject:dicDive];
    
    
    [m_tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel* lblTitle;
    UILabel* lblValue;
    UISwitch* switchPrivacy;
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];

        
        UIView* selectedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        [selectedBackView setBackgroundColor:kMainDefaultColor];
        [cell setSelectedBackgroundView:selectedBackView];
        
        
            lblTitle = [[UILabel alloc] init];
            [lblTitle setTag:100];
            [lblTitle setFont:[UIFont fontWithName:kDefaultFontNameBold size:12.0f]];
            [lblTitle setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:lblTitle];
            
            lblValue = [[UILabel alloc] init];
            [lblValue setTag:101];
            [lblValue setFont:[UIFont fontWithName:kDefaultFontName size:11.0f]];
            [lblValue setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
            [cell.contentView addSubview:lblValue];
        
        
        
    }else{
        
        
        lblTitle = (UILabel*)[cell.contentView viewWithTag:100];
        lblValue = (UILabel*)[cell.contentView viewWithTag:101];
        switchPrivacy = (UISwitch*)[cell.contentView viewWithTag:102];
        
    }
    
    NSDictionary* row = [m_tableData objectAtIndex:indexPath.row];
    
    
        [lblTitle setText:[NSString stringWithFormat:@"%@ :",[row objectForKey:@"title"]]];
        [lblTitle sizeToFit];
    
        CGRect frame = lblTitle.frame;
        frame.origin.x = 15;
        frame.size.height = cell.contentView.frame.size.height;
        [lblTitle setFrame:frame];
        
    if (indexPath.row != 16) {

        
        [lblValue setText:[NSString stringWithFormat:@"%@",[row objectForKey:@"value"]]];
        [lblValue setNumberOfLines:3];
        frame = lblValue.frame;
        frame.origin.x = lblTitle.frame.origin.x + lblTitle.frame.size.width+5;
        frame.size.height = cell.contentView.frame.size.height;
        frame.size.width = cell.contentView.frame.size.width - frame.origin.x-5;
        [lblValue setFrame:frame];
        [switchPrivacy removeFromSuperview];
        
        
    }else{
        [lblValue setText:@""];
        if (!switchPrivacy) {
            
                switchPrivacy = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 49, 31)];
                switchPrivacy.center = cell.contentView.center;
                [switchPrivacy setTag:102];
                [cell.contentView addSubview:switchPrivacy];
            [switchPrivacy addTarget:self action:@selector(onChangePrivacy:) forControlEvents:UIControlEventValueChanged];
            
        }
        
        CGRect frame = switchPrivacy.frame;
        [cell.contentView addSubview:switchPrivacy];
        frame.origin.x = lblTitle.frame.origin.x + lblTitle.frame.size.width+5;
        [switchPrivacy setFrame:frame];
        
        if ([[row objectForKey:@"value"] boolValue]) {
            [switchPrivacy setOn:YES];
        } else {
            [switchPrivacy setOn:NO];
        }
        
        
    }

    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return m_tableData.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    m_currentSelectedRow = (int)indexPath.row;
    
    switch (indexPath.row) {
        case 0:
        case 1:
            [self onChangeDate];
            break;
        case 2:
        case 3:
        case 5:
        case 6:
        case 7:
        case 8:
        case 12:
        case 13:
        case 14:
            [self onChangeValue];
            break;
        case 4:
            [self onChangeSafetyStops];
            break;
        case 9:
            [self onChangeDivingType];
            break;
        case 10:
            [self onChangeVisibility];
            break;
        case 11:
            [self onChangeCurrent];
            break;
        case 15:
            [self onChangeWater];
            break;
            
        case 17:
            
            [self onChangeTanksUsed];
            break;
            
        case 18:
            [self onChangeReview];
            break;
        default:
            break;
    }
    
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
- (void)onChangeTanksUsed{
    
    if (!m_editTanksUsedView) {
        
        m_editTanksUsedView = [[DiveEditTanksUsedViewController alloc] initWithTanks:m_DiveInformation.tanksUsed];
        m_editTanksUsedView.delegate =self;
    }
    [m_editTanksUsedView setTanksUsed:m_DiveInformation.tanksUsed];
    
    [self showPopupView:m_editTanksUsedView.view];

}
- (void)didChangeTanksUsed:(NSArray *)tanks{
    
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    m_DiveInformation.tanksUsed = [NSMutableArray arrayWithArray:tanks];
    [self diveDataShow];
    [m_KLCPopup dismissPresentingPopup];

}
- (void)didCancelTanksUsed{
    
    [m_KLCPopup dismissPresentingPopup];

}
- (void)onChangeSafetyStops{
    
    
    if (!m_editSafetyStopView) {
         m_editSafetyStopView = [[DiveEditSafetyStopsViewController alloc] initWithSafetyStops:m_DiveInformation.SafetyStops];
        m_editSafetyStopView.delegate = self;
    
    }
    
    [m_editSafetyStopView setSafetyStops:m_DiveInformation.SafetyStops];
    
    [self showPopupView:m_editSafetyStopView.view];
    
}
-(void)didChangeSafetyStops:(NSArray *)safetyStops{
    
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    m_DiveInformation.SafetyStops = [NSArray arrayWithArray:safetyStops];
    [self diveDataShow];
    
    NSString *myNickName = [[AppManager sharedManager].loginResult.user.nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *diveShakenID   = m_DiveInformation.shakenID;
    NSString *tempURLString = [NSString stringWithFormat:@"%@/%@%@graph.png", SERVER_URL, myNickName, diveShakenID];
    [[DiveOfflineModeManager sharedManager] removeImageWithUrl:tempURLString];
    
    NSString *largeURLString = [NSString stringWithFormat:@"%@/%@%@graph2.png", SERVER_URL, myNickName, diveShakenID];
    [[DiveOfflineModeManager sharedManager] removeImageWithUrl:largeURLString];
    
    
    
    [m_KLCPopup dismissPresentingPopup];
    
}

-(void)didCancelSafetyStops{
    
    [m_KLCPopup dismissPresentingPopup];
    
}


-(void)onChangeReview{
    
    DiveEditReviewViewController *reviewVC  = [[DiveEditReviewViewController alloc] initWithDiveReview:m_DiveInformation.review];
    reviewVC.delegate = self;
    [self showPopupView:reviewVC.view];
    
    
}
-(void)didSelectReview:(DiveReview *)review{
    
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    m_DiveInformation.review = review;
    
    [self diveDataShow];
    [m_KLCPopup dismissPresentingPopup];
}

-(void)didCancelReview{
    
    [m_KLCPopup dismissPresentingPopup];
    
}
-(void)onChangeDivingType{
    
    NSArray* list = @[@"Recreational",@"Training",@"Night Dive",@"Deep Dive",@"Drift",@"Wreck",@"Cave",@"Reef",@"Photo",@"Research"];
    
    NSMutableArray* indexList = [[NSMutableArray alloc] init];
    
    for (NSString* diveType in m_DiveInformation.diveType) {

        for (int i = 0 ; i < list.count; i++) {
            
            NSString* str = [list objectAtIndex:i];
            if ([[diveType capitalizedString] isEqualToString:str]) {
                
                [indexList addObject:[NSNumber numberWithInt:i]];
                
            }
            
        }
        
    }
    
    
    CheckListPickerView *checkListView = [[CheckListPickerView alloc] initWithTitle:@"DIVING TYPE" list: list checkedIndexList:indexList];
    
    checkListView.delegate = self;
    [self showPopupView:checkListView];
    
}
#pragma mark - CheckListPickerView delegate

- (void)didCheckedSelectedItems:(NSArray *)selectedItems{
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (NSString* diveType in selectedItems) {
        
        [arr addObject:[diveType lowercaseString]];
        
    }
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    m_DiveInformation.diveType = arr;
    [self diveDataShow];
    [m_KLCPopup dismissPresentingPopup];
    
}
-(void)didCancelCheckList{
    [m_KLCPopup dismissPresentingPopup];
}



-(void)onChangePrivacy:(id)sender{
    
    UISwitch* switchPrivacy = (UISwitch*)sender;
    if (switchPrivacy.isOn) {
        
        m_DiveInformation.privacy = @"0";
                                     
    }else{
        
        m_DiveInformation.privacy = @"1";
        
    }
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self diveDataShow];
    
}

-(void)onChangeVisibility{
    
    TKListPickerView *listView = [[TKListPickerView alloc] initWithTitle:@"Visibility"
                                                                     list:@[@"None",
                                                                            @"Bad (under 5m / 15ft)",
                                                                            @"Average (5-10m / 15-30ft)",
                                                                            @"Good (10-25m / 40-75ft)",
                                                                            @"Excellent (over 25m / 75ft)"]
                                                                   ];
    [listView setDelegate:self];
    
    [self showPopupView:listView];
    
}

-(void)onChangeCurrent{
    TKListPickerView *listView = [[TKListPickerView alloc] initWithTitle:@"Current"
                                                                     list:@[@"None",
                                                                            @"Light (up to 1 knot)",
                                                                            @"Medium (up to 2 knots)",
                                                                            @"Strong (up to 3 knots)",
                                                                            @"Extreme (over 3 knots)"]
                                                                   ];
    [listView setDelegate:self];
    
    [self showPopupView:listView];

    
}

-(void)onChangeWater{
    TKListPickerView *listView = [[TKListPickerView alloc] initWithTitle:@"Water"
                                                                     list:@[@"Salt",
                                                                            @"Fresh",
                                                                            ]
                                                                   ];
    [listView setDelegate:self];
    [self showPopupView:listView];

}
#pragma mark - TKListPickerView delegate

-(void)listPickerView:(TKListPickerView *)view selectedString:(NSString *)string index:(int)index{
    
    switch (m_currentSelectedRow) {
        case 10:
            m_DiveInformation.visibility = [string lowercaseString];
            break;
        case 11:
            m_DiveInformation.current = [string lowercaseString];
            break;
        case 15:
            
            m_DiveInformation.water = [string lowercaseString];
            break;
            
        default:
            break;
    }
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self diveDataShow];
    [m_KLCPopup dismissPresentingPopup];
    
}

-(void)onChangeValue
{
    
    if (!m_editValueVC) {
        
        m_editValueVC = [[DiveEditValueViewController alloc] initWithNibName:@"DiveEditValueViewController" bundle:nil];
        m_editValueVC.delegate = self;
        m_editValueVC.dataSource =  self;
        
    }

    [self showPopupView:m_editValueVC.view];
    
    
}
-(void)onChangeDate{
    DiveDatePicker *datePicker = [DiveDatePicker sharedInstance] ;
    datePicker.delegate = self;
    if (m_currentSelectedRow == 0) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:m_DiveInformation.date];
        [datePicker setPickerMode:UIDatePickerModeDate];
       [datePicker setDate:date];
        
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *time = [formatter dateFromString:m_DiveInformation.time];
        [datePicker setPickerMode:UIDatePickerModeTime];
        [datePicker setDate:time];
        
        
    }
    [self showPopupView:datePicker.view];
}

-(void) showPopupView:(UIView*)view{
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    m_KLCPopup = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [m_KLCPopup showWithLayout:layout];
    
}

#pragma mark DiveDatePickerDelegate

-(void)didSelectedDate:(NSDate *)date{
    
    if (m_currentSelectedRow == 0) {
     
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //Optionally for time zone converstions
        NSString *dateString = [formatter stringFromDate:date];
        m_DiveInformation.date = dateString;
        
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        //Optionally for time zone converstions
        NSString *timeString = [formatter stringFromDate:date];
        m_DiveInformation.time = timeString;
    }
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self diveDataShow];
    [m_KLCPopup dismissPresentingPopup];
    
}

-(void)didCancelDate{

    [m_KLCPopup dismissPresentingPopup];
    
}


#pragma mark DiveEdiveValueViewControllerDelegate

-(void)didChangeValueForDiveEdit:(NSString *)value :(NSString *)selectedUnit{
    
    switch (m_currentSelectedRow) {
        case 2:
            m_DiveInformation.maxDepth = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.maxDepthUnit = selectedUnit;
            break;
        case 3:
            m_DiveInformation.duration = [DiveInformation convertInternationalFormatValue:value];
            break;
        case 5:
           m_DiveInformation.weight.weight = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.weight.value = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.weight.unit = selectedUnit;
            break;
        case 6:
           m_DiveInformation.number = value;
            break;
            
        case 7:
            m_DiveInformation.guideName = value;
            break;
            
        case 8:
            m_DiveInformation.tripName = value;
            break;
            
        case 12:
            m_DiveInformation.temp.surface = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.temp.surfaceValue = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.temp.surfaceUnit = selectedUnit;
            break;
        case 13:
            m_DiveInformation.temp.bottom = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.temp.bottomValue = [DiveInformation convertInternationalFormatValue:value];
            m_DiveInformation.temp.bottomUnit = selectedUnit;
            break;
        case 14:
            {
                NSString* newValue = [DiveInformation convertInternationalFormatValue:value];
                
                if ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeMetric) {
                    
                    m_DiveInformation.altitude = newValue;
                    
                }else{
                    
                    m_DiveInformation.altitude =  [NSString stringWithFormat:@"%.2f", [newValue floatValue] * 0.3048f];
                }
            }
            break;
        default:
            break;
    }
    
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self diveDataShow];
    [m_KLCPopup dismissPresentingPopup];
    
    
}

-(void)didCancelValueForDiveEdit{
    
    [m_KLCPopup dismissPresentingPopup];
}

#pragma mark DiveEdiveValueViewControllerDataSource




-(NSString *)valueForDiveEdit{
    
    
    NSString* strValue = @"";
    switch (m_currentSelectedRow) {
        case 2:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.maxDepth];
            break;
        case 3:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.duration];
            break;
        case 5:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.weight.value];
            break;
        case 6:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.number];
            break;
            
        case 7:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.guideName];
            break;

        case 8:
            
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.tripName];
            break;
            
        case 12:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.temp.surfaceValue];
            break;
        case 13:
            strValue = [NSString stringWithFormat:@"%@",m_DiveInformation.temp.bottomValue];
            break;

        case 14:
            
            strValue = [NSString stringWithFormat:@"%@",[DiveInformation unitOfLengthWithValue:m_DiveInformation.altitude defaultUnit:@"m" showUnit:NO]];
            break;
        default:
            break;
    }
    
    
    return strValue;
}

-(DiveEditValueType)valueTypeForDiveEdit{
  
    DiveEditValueType valueType = DiveEditValueTypeString;
    
    switch (m_currentSelectedRow) {
        case 2:
        case 3:
        case 5:
        case 6:
        case 12:
        case 13:
        case 14:
            
            valueType = DiveEditValueTypeNumber;
            break;
        default:
            break;
    }
    
    return valueType;
}
-(NSArray *)arrUnitsForDiveEdit{
   
    NSArray* arr = [[NSArray alloc] init];
    
    switch (m_currentSelectedRow) {
        case 2:
            arr = @[@"m",@"ft"];
            break;
        case 3:
            break;
        case 5:
            arr = @[@"kg",@"lbs"];
            break;
        case 12:
            arr = @[@"C",@"F"];
            break;
        case 13:
            arr = @[@"C",@"F"];
            break;
        case 14:
            break;
        default:
            break;
    }
    
    
    return  arr;
}

-(NSString *)strSelUnitForDiveEdit{
    
    NSString* strSelUnit = @"";
    
    switch (m_currentSelectedRow) {
            
        case 2:
            
            strSelUnit = m_DiveInformation.maxDepthUnit;
            break;
        case 3:
            
            strSelUnit = @"mins";
            break;
        case 5:
            
            strSelUnit = m_DiveInformation.weight.unit;
            break;
        case 12:
            
            strSelUnit = m_DiveInformation.temp.surfaceUnit;
            break;
        case 13:
            
            strSelUnit = m_DiveInformation.temp.bottomUnit;
            break;
        case 14:
            strSelUnit = ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"ft" : @"m";
            break;
        default:
            break;
    }
    
    
    return strSelUnit;
    
}

-(NSString *)titleForDiveEdit{
    
    NSDictionary* dic =  [m_tableData objectAtIndex:m_currentSelectedRow];
    return [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
}


@end

