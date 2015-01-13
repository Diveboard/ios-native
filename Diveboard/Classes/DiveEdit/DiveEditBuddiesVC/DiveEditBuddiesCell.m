//
//  DiveEditBuddiesCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/29/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditBuddiesCell.h"
#import "NIDropDown.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+FindUIViewController.h"

@interface DiveEditBuddiesCell() <NIDropDownDelegate,FBFriendPickerDelegate>
{
    NIDropDown* m_dropDown;
    int m_editState;
    UITextField* m_currentText;
    CGPoint m_prevScrollPoint;
    CGSize  m_prevContentSize;

}
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@end


@implementation DiveEditBuddiesCell
@synthesize delegate;
@synthesize friendPickerController = _friendPickerController;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    
    [btn_DiveNotifyCheck setBackgroundImage:[UIImage imageNamed:@"btn_unchecked.png"]
                             forState:UIControlStateNormal];
    [btn_DiveNotifyCheck setBackgroundImage:[UIImage imageNamed:@"btn_checked.png"]
                             forState:UIControlStateSelected];
    [btn_DiveNotifyCheck setBackgroundImage:[UIImage imageNamed:@"btn_checked.png"]
                             forState:UIControlStateHighlighted];
    btn_DiveNotifyCheck.adjustsImageWhenHighlighted=YES;

    
    [btn_NameNotifyCheck setBackgroundImage:[UIImage imageNamed:@"btn_unchecked.png"]
                                   forState:UIControlStateNormal];
    [btn_NameNotifyCheck setBackgroundImage:[UIImage imageNamed:@"btn_checked.png"]
                                   forState:UIControlStateSelected];
    [btn_NameNotifyCheck setBackgroundImage:[UIImage imageNamed:@"btn_checked.png"]
                                   forState:UIControlStateHighlighted];
    btn_NameNotifyCheck.adjustsImageWhenHighlighted=YES;

    
    [btn_DiveNotifyCheck setSelected:YES];
    [btn_NameNotifyCheck setSelected:YES];
    m_editState = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self changeEditState:m_editState];

}



-(void)checkboxSelected:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    [btn setSelected:![btn isSelected]];
}

- (void)onChangeBuddyType:(id)sender{
    
    NSArray* arrType = @[@"Diveboard",@"Facebook",@"Name/Email"];
    
    if(m_dropDown == nil) {
        CGFloat f = 90;
        m_dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrType :@"down"];
        m_dropDown.delegate = self;
    }
    else {
        [m_dropDown hideDropDown:sender];
        m_dropDown = nil;
    }
    
}
-(void)niDropDownDelegateMethod:(int)selectedRow :(NIDropDown *)sender{
    
    m_dropDown = nil;
    m_editState = selectedRow;
    [self changeEditState:m_editState];
}

-(void)changeEditState:(int)state{
    
    if (state == 0) {
        
        [m_viewDiveboard setHidden:NO];
        [m_viewFaceBook setHidden:YES];
        [m_viewNameEmail setHidden:YES];
        
    }else if (state == 1){
        
        [m_viewFaceBook setHidden:NO];
        [m_viewDiveboard setHidden:YES];
        [m_viewNameEmail setHidden:YES];
        
        
    }else if (state == 2){
        
        [m_viewNameEmail setHidden:NO];
        [m_viewDiveboard setHidden:YES];
        [m_viewFaceBook setHidden:YES];
        
    }
    
}
-(void)onChangeText:(id)sender
{
    
    UITextField* txt = (UITextField*)sender;
    
    if (txt == m_txtSearchDiveUser) {
        
        if (m_txtSearchDiveUser.text.length > 1) {
            
            [self searchBuddy:m_txtSearchDiveUser.text];
            
        }
        
    }else if (txt == m_txtSearchFBUser){
        
        if (m_txtSearchFBUser.text.length > 1) {
            
            [self searchFBFriends];
            
        }
        
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    m_currentText = textField;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
//    UICollectionView* cv =(UICollectionView*)self.superview;
//    
//    float y = cv.contentSize.height-cv.frame.size.height;
//    
//    if (y < 0 ) {
//        
//        y = 0;
//    }
//    
//    
//    [cv setContentOffset:CGPointMake(0,y) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self onChangeText:textField];
    return YES;
}


-(void)searchBuddy:(NSString*)search_name
{
 
    
    NSDictionary *params = @{@"q": search_name,
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/search/user.json", SERVER_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:REQUEST_TIME_OUT];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                          
                                                               error:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchUsers:)]) {
            
            [self.delegate didSearchUsers:arr];
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

-(void)onAddNewBuddy:(id)sender{
    
    if (m_txtUserName.text.length < 2) {
     
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"The buddy name must be more than 2 characters." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddNewUserName:email:)]) {
        
        [self.delegate didAddNewUserName:m_txtUserName.text email:m_txtUserEmail.text];
        
        m_txtUserName.text = @"";
        m_txtUserEmail.text = @"";
        
    }
    
}

-(BOOL)isDiveUserNotifyChecked{
    
    return  [btn_DiveNotifyCheck isSelected];
    
}

- (BOOL)isNameUserNotifyChecked{
    
    return [btn_NameNotifyCheck isSelected];
    
}



-(void)searchFBFriends
{
    
    if ([AppManager sharedManager].fbSession.isOpen) {
        [self showFBFriendPicker];
    }
    else
    {
        if ([AppManager sharedManager].fbSession.state != FBSessionStateCreated || ![AppManager sharedManager].fbSession) {
            [AppManager sharedManager].fbSession = [[FBSession alloc] init];
        }
        
        [[AppManager sharedManager].fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            [self showFBFriendPicker];
            
        }];
        
    }
    
    
    
    
    
}

-(void)showFBFriendPicker
{
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select Friends";
        self.friendPickerController.delegate = self;
    }
    [self.friendPickerController setSession:[AppManager sharedManager].fbSession];
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    
    
    UICollectionView* cv =(UICollectionView*)self.superview;
    UIView* buddiesView = cv.superview;
    
    UIViewController *viewController =(UIViewController*)[buddiesView.superview firstAvailableUIViewController];
    
    [viewController presentViewController:self.friendPickerController
                                 animated:YES
                               completion:^(void){
                                   
                                   CGRect frame =self.friendPickerController.tableView.frame;
                                   frame.size.height +=20;
                                   self.friendPickerController.tableView.frame = frame;
                                   
                               }
     ];
    
    
}

#pragma mark - FBFriendPickerDelegate methods
- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self.friendPickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddFBFriends:)]) {
        
        [self.delegate didAddFBFriends:self.friendPickerController.selection];
        
    }
    [self.friendPickerController dismissViewControllerAnimated:YES completion:nil];
    
}

/*
 * This delegate method is called to decide whether to show a user
 * in the friend picker list.
 */
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    // If there is a search query, filter the friend list based on this.
    if (m_txtSearchFBUser && ![m_txtSearchFBUser.text isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:m_txtSearchFBUser.text
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            // If friend name matches partially, show the friend
            return YES;
        } else {
            // If no match, do not show the friend
            return NO;
        }
    } else {
        // If there is no search query, show all friends.
        return YES;
    }
    return YES;
}

-(void)keyboardWillHide:(NSNotification *)_notification
{
    
    UICollectionView* cv =(UICollectionView*)self.superview;
    [cv setContentOffset:m_prevScrollPoint animated:YES];
    
}


-(void)keyboardWillShow:(NSNotification *)_notification
{
    
    UICollectionView* cv =(UICollectionView*)self.superview;
    
    
    m_prevScrollPoint = cv.contentOffset;
    CGRect aRect = cv.frame;
    
    aRect.origin.x = 0;
    
    CGSize keyboardSize = [[[_notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    float keyboardHeight = keyboardSize.height;
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            keyboardHeight = keyboardSize.width;
        }
        
    }
    
    aRect.size.height -= keyboardHeight;
    
    
    CGPoint origin = [m_currentText.superview convertPoint:m_currentText.frame.origin toView:cv];
    
    
//    origin.y -=m_prevScrollPoint.y;
    //    origin.y +=m_currentEditView.frame.size.height;
    
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        
        CGPoint scrollPoint = CGPointMake(0.0,origin.y - aRect.size.height);
        [cv setContentOffset:scrollPoint animated:YES];
        
    }
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
