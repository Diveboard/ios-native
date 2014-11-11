//
//  DiveEditBuddiesViewController.m
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import "DiveEditBuddiesViewController.h"
#import "DiveEditBuddiesPhotoCell.h"
#import "DiveEditBuddiesCell.h"
#import "DiveInformation.h"
#import "XDPopupListView.h"
#import "AsyncUIImageView.h"
#import "DrawerMenuViewController.h"
@interface DiveEditBuddiesViewController () <DiveEditBuddiesCellDelegate,XDPopupListViewDataSource,XDPopupListViewDelegate>
{
    DiveInformation* m_DiveInformation;
    NSMutableArray* m_OldBuddies;
    NSArray* m_arrUsers;
    XDPopupListView* m_AutoCompleteList;
    DiveEditBuddiesCell* editcell;
    UIView* m_viewBoundAudoComplete;
}
@end

@implementation DiveEditBuddiesViewController

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
        nibFilename = @"DiveEditBuddiesViewController";
    } else {
        nibFilename = @"DiveEditBuddiesViewController-ipad";
    }
    nibFilename = @"DiveEditBuddiesViewController";

    self = [self initWithNibName:nibFilename bundle:nil];
    
    if (self) {
        m_DiveInformation = diveInfo;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [m_CollectionViewBuddies registerNib:[UINib nibWithNibName:@"DiveEditBuddiesPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"BuddyPhotoCell"];
    
    [m_CollectionViewBuddies registerNib:[UINib nibWithNibName:@"DiveEditBuddiesCell" bundle:nil] forCellWithReuseIdentifier:@"BuddyEditCell"];
    
	[m_CollectionViewBuddies registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    m_arrUsers = [[NSArray alloc] init];
    
    m_AutoCompleteList = [[XDPopupListView alloc] initWithBoundView:nil dataSource:self delegate:self popupType:XDPopupListViewDropDown];
    

    [self getOldBuddies];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    
    [m_CollectionViewBuddies reloadData];
}

#pragma mark UICollectionView DataSource & Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell ;
    
    if (indexPath.section == 0) {
        DiveEditBuddiesPhotoCell* photocell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuddyPhotoCell" forIndexPath:indexPath];
        Buddy* buddy = [m_DiveInformation.buddies objectAtIndex:indexPath.row];
        
        [photocell setBuddyData:buddy];
        
        cell = photocell;
        
    }else if (indexPath.section == 1){
        
        DiveEditBuddiesPhotoCell* photocell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuddyPhotoCell" forIndexPath:indexPath];
        Buddy* buddy = [m_OldBuddies objectAtIndex:indexPath.row];
        
        [photocell setBuddyData:buddy];
        
        cell = photocell;

        
    }else if (indexPath.section == 2){
        editcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuddyEditCell" forIndexPath:indexPath];
        
        editcell.delegate = self;
        
        cell = editcell;
    
    }
    
    return  cell;
    
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    int count = 0;
    
    if (section == 0) {
        
        count = m_DiveInformation.buddies.count;
        
    }else if (section == 1){
        
        count = m_OldBuddies.count;
        
    }else{
        
        count = 1;
    }
    
    return  count;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 3;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	if (kind != UICollectionElementKindSectionHeader)
		return nil;
   
	UICollectionReusableView *cell =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
	UILabel *label = nil;
    
    label = (UILabel*)[cell viewWithTag:100];
    
    if (!label) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        label.tag = 100;
        label.textAlignment = NSTextAlignmentCenter;
        
        
        [cell addSubview:label];
        
    }
    
    [label setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
	NSString *title = nil;
	if (indexPath.section == 0)
		title = @"My buddies";
	else if (indexPath.section == 1)
		title = @"Add one of your past dive buddies";
    else
		title = @"Or search and add buddies from";
    
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                        NSForegroundColorAttributeName: [UIColor colorWithWhite:0.1 alpha:1.0],
                                                                                        NSFontAttributeName: [UIFont fontWithName:kDefaultFontNameBold size:14]
                                                                                        }];
    
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    if (indexPath.section == 2) {
        size.width = m_CollectionViewBuddies.bounds.size.width;
        size.height =  220;
        
    }else{
       
        size.width = 106;
        size.height = 130;
    }

    
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        [m_OldBuddies addObject:[m_DiveInformation.buddies objectAtIndex:indexPath.row]];
        [m_DiveInformation.buddies removeObjectAtIndex:indexPath.row];
        [m_CollectionViewBuddies reloadData];
        
    }else if (indexPath.section == 1){
        
        [m_DiveInformation.buddies addObject:[m_OldBuddies objectAtIndex:indexPath.row]];
        [m_OldBuddies removeObjectAtIndex:indexPath.row];
        [m_CollectionViewBuddies reloadData];
    }
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)getOldBuddies {
    
    m_OldBuddies = [[NSMutableArray alloc] init];
    
    for (NSString* diveId in [AppManager sharedManager].loginResult.user.allDiveIDs) {
        
        NSDictionary *diveInfo ;
        
        if ([AppManager sharedManager].loadedDives) {
            
            diveInfo = [[AppManager sharedManager].loadedDives objectForKey:diveId];
            
            if (!diveInfo) {
                
                
               diveInfo = [[DiveOfflineModeManager sharedManager] getOneDiveInformation:diveId];
                if (diveInfo) {
                    [[AppManager sharedManager].loadedDives setObject:diveInfo forKey:diveId];
                }
                
            }
            
        } else {
            
            [AppManager sharedManager].loadedDives = [[NSMutableDictionary alloc] init];
            
            [[AppManager sharedManager].loadedDives setObject:diveInfo forKey:diveId];
            
        }
        
        
        DiveInformation *dive = [[DiveInformation alloc] initWithDictionary:[diveInfo objectForKey:@"result"]];
        
        for (Buddy* buddy in dive.buddies) {
        
            BOOL flag = YES;
            
            for (Buddy *oldBuddy in m_OldBuddies) {
                
                if ([buddy.nickName isEqualToString:oldBuddy.nickName]) {
                    
                    flag = NO;
                    break;
                }
                
            }

            for (Buddy *oldBuddy in m_DiveInformation.buddies) {
                
                if ([buddy.nickName isEqualToString:oldBuddy.nickName]) {
                    
                    flag = NO;
                    break;
                }
                
            }
            
            
            
            if (flag) {
                [m_OldBuddies addObject:buddy];
            }
        }
        
    }
    
    
    
}

#pragma mark - DiveEditBuddiesCellDelegate

-(void)didSearchUsers:(NSArray *)arrUser{
    
    m_arrUsers = arrUser;
    if (!m_viewBoundAudoComplete) {
        m_viewBoundAudoComplete = [[UIView alloc] initWithFrame:CGRectMake(8, editcell.frame.origin.y+60, 305, 30)];
    }
    
    [m_viewBoundAudoComplete setFrame:CGRectMake(8, editcell.frame.origin.y+60, 305, 30)];
    [m_CollectionViewBuddies addSubview:m_viewBoundAudoComplete];
    
    [m_AutoCompleteList setBoundView:m_viewBoundAudoComplete];
    [m_AutoCompleteList show];
    
    [m_AutoCompleteList reloadListData];
    
    [m_CollectionViewBuddies setScrollEnabled:NO];

    
}

-(void)didAddNewUserName:(NSString *)name email:(NSString *)email{
    
    Buddy* buddy = [[Buddy alloc] initWithDictionary:nil];
    
    buddy.nickName = name;
    if ([self NSStringIsValidEmail:email]) {
        buddy.email = email;
    }
    
    [buddy setNotify:[editcell isNameUserNotifyChecked]];
    
    
    BOOL flag = YES;
    for (Buddy* pBuddy in m_DiveInformation.buddies) {
        
        if ([pBuddy.nickName isEqualToString:buddy.nickName]) {
            
            flag = NO;
        }
        
    }
    if (flag) {
        
        [m_DiveInformation.buddies addObject:buddy];
        [DrawerMenuViewController sharedMenu].isEditedDive = YES;
        [m_CollectionViewBuddies reloadData];
        
    }
    
    
}

-(void)didAddFBFriends:(NSArray *)FBFriends{

    for (id<FBGraphUser> user in FBFriends) {
        
        Buddy* buddy = [[Buddy alloc] initWithDictionary:nil];
        
        buddy.nickName = user.name;
        buddy.fbID = user.id;
        NSDictionary* Obj = [user objectForKey:@"picture"];
        NSDictionary* picData = [Obj objectForKey:@"data"];
        buddy.picture = [picData objectForKey:@"url"];
        
        BOOL flag = YES;
        for (Buddy* pBuddy in m_DiveInformation.buddies) {
            
            if ([pBuddy.fbID isEqualToString:buddy.fbID]) {
                
                flag = NO;
            }
            
        }
        if (flag) {
            
            [m_DiveInformation.buddies addObject:buddy];
            [DrawerMenuViewController sharedMenu].isEditedDive = YES;
        }
        
    }
    [m_CollectionViewBuddies reloadData];

    
}

#pragma mark - XDPopupListViewDataSource & XDPopupListViewDelegate


- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return m_arrUsers.count;
}
- (CGFloat)itemCellHeight:(NSIndexPath *)indexPath
{
    return 30.0f;
}
- (void)clickedListViewAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* userDic =  m_arrUsers[indexPath.row];
    
    Buddy* buddy = [[Buddy alloc] initWithDictionary:userDic];
    buddy.class_ = @"User";
    buddy.notify = [editcell isDiveUserNotifyChecked];
    buddy.nickName = [userDic objectForKey:@"name"];
    
    BOOL flag = YES;
    for (Buddy* pBuddy in m_DiveInformation.buddies) {
        
        if (pBuddy.ID == buddy.ID) {
            
            flag = NO;
        }
        
    }
    if (flag) {
        
        [m_DiveInformation.buddies addObject:buddy];
        [DrawerMenuViewController sharedMenu].isEditedDive = YES;
        [m_CollectionViewBuddies reloadData];
        NSIndexPath* cindexPath = [NSIndexPath indexPathForRow:m_DiveInformation.buddies.count-1 inSection:0];
        [m_CollectionViewBuddies scrollToItemAtIndexPath:cindexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        
    }
    
    [self.view endEditing:YES];
    
}

-(void)didDismissXDPopupList{

    [m_viewBoundAudoComplete removeFromSuperview];
    [m_CollectionViewBuddies setScrollEnabled:YES];

    
}
- (UITableViewCell *)itemCell:(NSIndexPath *)indexPath
{
    if (m_arrUsers.count == 0) {
        return nil;
    }
    static NSString *identifier = @"AutoCompleteCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    NSDictionary* user = m_arrUsers[indexPath.row];
    AsyncUIImageView* imgPhoto;
    UILabel* lbl_name;
    
    imgPhoto =(AsyncUIImageView*)[cell viewWithTag:100];
    lbl_name =(UILabel*)[cell viewWithTag:200];
    
    if (!imgPhoto) {
        imgPhoto = [[AsyncUIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [imgPhoto setBackgroundColor:[UIColor lightGrayColor]];
        [imgPhoto setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [imgPhoto setTag:100];
        [cell.contentView addSubview:imgPhoto];
    }
    if (!lbl_name) {
        lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, cell.frame.size.width-40, 30)];
        lbl_name.font = [UIFont fontWithName:kDefaultFontName size:14];
        [lbl_name setTag:200];
        [cell.contentView addSubview:lbl_name];
    }
    [imgPhoto setImageURL:[NSURL URLWithString:[user objectForKey:@"picture"]] placeholder:nil];
    lbl_name.text = [user objectForKey:@"name"];

    
    
    return cell;
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
