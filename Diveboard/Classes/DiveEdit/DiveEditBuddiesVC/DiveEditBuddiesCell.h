//
//  DiveEditBuddiesCell.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/29/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@protocol DiveEditBuddiesCellDelegate <NSObject>

@optional
-(void)didSearchUsers:(NSArray*)arrUser;
-(void)didAddNewUserName:(NSString*)name email:(NSString*)email;
-(void)didAddFBFriends:(NSArray*)FBFriends;
@end

@interface DiveEditBuddiesCell : UICollectionViewCell <UITextFieldDelegate>
{
    IBOutlet UIButton* btn_DiveNotifyCheck;
    IBOutlet UIButton* btn_NameNotifyCheck;
    
    IBOutlet UIView* m_viewFaceBook;
    IBOutlet UIView* m_viewDiveboard;
    IBOutlet UIView* m_viewNameEmail;
    
    IBOutlet UITextField* m_txtSearchDiveUser;
    IBOutlet UITextField* m_txtSearchFBUser;

    IBOutlet UITextField* m_txtUserName;
    IBOutlet UITextField* m_txtUserEmail;
    
}

@property (nonatomic, assign) id<DiveEditBuddiesCellDelegate> delegate;

- (IBAction)checkboxSelected:(id)sender;
- (IBAction)onChangeBuddyType:(id)sender;
- (IBAction)onChangeText:(id)sender;
- (IBAction)onAddNewBuddy:(id)sender;

- (BOOL)isDiveUserNotifyChecked;
- (BOOL)isNameUserNotifyChecked;



@end
