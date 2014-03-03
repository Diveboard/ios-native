//
//  LoginViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"


@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *srcUserInfoBox;
@property (strong, nonatomic) IBOutlet UIView *viewMedium;
@property (strong, nonatomic) IBOutlet UIView *viewUserInfoBox;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnSignup;

- (IBAction)loginAction:(id)sender;
- (IBAction)facebookLoginAction:(id)sender;
- (IBAction)signupAction:(id)sender;
@end
