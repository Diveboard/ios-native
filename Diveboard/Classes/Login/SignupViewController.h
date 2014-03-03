//
//  SignupViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/11/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface SignupViewController : UIViewController<UINavigationControllerDelegate,
    UITextFieldDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrMainView;
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtDiveboardURL;
@property (retain, nonatomic) IBOutlet UITextField *txtNickname;
@property (retain, nonatomic) IBOutlet UIButton *btnSignup;
@property (retain, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblKeep;
@property (retain, nonatomic) IBOutlet UILabel *lblIAgree;
@property (retain, nonatomic) IBOutlet UIButton *btnKeep;
@property (retain, nonatomic) IBOutlet UIButton *btnAgree;


- (IBAction)backAction:(id)sender;
- (IBAction)actionKeep:(id)sender;
- (IBAction)actionAgree:(id)sender;

- (IBAction)actionSignup:(id)sender;

@end
