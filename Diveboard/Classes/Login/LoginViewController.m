//
//  LoginViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LoginResult.h"
#import "SignupViewController.h"
#import "DiveListViewController.h"


@interface LoginViewController ()
{
    NSUserDefaults *userDefault;
    AppManager *appManager;
    FBSession  *fbSession;
}

@end

@implementation LoginViewController

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
    
    userDefault = [NSUserDefaults standardUserDefaults];
    appManager = [AppManager sharedManager];
    fbSession  = appManager.fbSession;
    
    [self initMethod];
    
    [self autoLogin];
    
    [self keyboardShowHideAnimationSetting];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMethod
{
    // background color
    [self.view setBackgroundColor:kMainDefaultColor];
    
    // email, password box
    [_viewUserInfoBox setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    [GlobalMethods setRoundView:_viewUserInfoBox cornorRadious:8.0f borderColor:Nil border:0];
    
    // email textfield
    [self setBorderRoundOfTextField:_txtEmail];
    
    // password textfield
    [self setBorderRoundOfTextField:_txtPassword];
    
    NSDictionary *userInfo = [userDefault objectForKey:kLoginUserInfo];
    NSString *email = [userInfo objectForKey:@"email"];
    NSString *password = [userInfo objectForKey:@"password"];
    _txtEmail.text = email;
    _txtPassword.text = password;

    // login button
    [GlobalMethods setRoundView:_btnLogin   cornorRadious:5.0f borderColor:nil border:0];
    [_btnLogin.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
    
    // facebook login button
    [GlobalMethods setRoundView:_btnFBLogin cornorRadious:5.0f borderColor:nil border:0];
    
    // signup button
    [_btnSignup.titleLabel setFont:[UIFont fontWithName:kDefaultFontNameBold size:15.0f]];
}

- (void) setBorderRoundOfTextField:(UITextField*)textField
{
    [GlobalMethods setRoundView:textField
                  cornorRadious:5.0f
                    borderColor:nil
                         border:0];
    [textField setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, CGRectGetHeight(textField.frame))];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void) autoLogin
{
    NSString *loginMode = [userDefault objectForKey:kLoginMode];
    if ([loginMode isEqualToString:kLoginModeNative]) {
        
        NSDictionary *userInfo = [userDefault objectForKey:kLoginUserInfo];
        NSString *email = [userInfo objectForKey:@"email"];
        NSString *password = [userInfo objectForKey:@"password"];
        
        [self loginWithNativeUser:email password:password];
        
    } else if ([loginMode isEqualToString:kLoginModeFB]) {
        
        NSDictionary *fbUserInfo = [userDefault objectForKey:kLoginUserInfo];
        
        [self loginActionWithFacebookUser:fbUserInfo];
    }
    

}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        NSLog(@"Landscape");
        [UIView animateWithDuration:0.3f animations:^{
            [ self.view setFrame : CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height)] ;
        }];
        
    } else {
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtEmail) {
        [_txtPassword becomeFirstResponder];
    } else if (textField == _txtPassword) {
        if ([self checkingUserInformation]) {
            [self loginWithNativeUser:_txtEmail.text password:_txtPassword.text];
        }
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtEmail resignFirstResponder];
    [_txtPassword resignFirstResponder];
}


#pragma mark - UIButton Actions

- (IBAction)loginAction:(id)sender {
    if ([self checkingUserInformation]) {
        [_txtEmail resignFirstResponder];
        [_txtPassword resignFirstResponder];
        
        [self loginWithNativeUser:_txtEmail.text password:_txtPassword.text];
        
    }
}

- (IBAction)facebookLoginAction:(id)sender {
    [self internetConnecting:YES];
//    [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(facebookConnecting) userInfo:Nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(facebookConnecting) userInfo:nil repeats:NO];
}

- (IBAction)signupAction:(id)sender {
    SignupViewController *viewController = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -

- (BOOL) checkingUserInformation
{
    BOOL result = NO;
    if (_txtEmail.text.length == 0) {
        [self alertViewShowWithMessage:@"Please enter your email."];
        [_txtEmail becomeFirstResponder];
    } else if (_txtPassword.text.length == 0) {
        [self alertViewShowWithMessage:@"Please enter your password."];
        [_txtPassword becomeFirstResponder];
    } else if (_txtEmail.text.length < 5) {
        [self alertViewShowWithMessage:@"Incorrect your email address"];
        [_txtEmail resignFirstResponder];
    } else {
        result = YES;
    }
    return result;
}

- (void) alertViewShowWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void) internetConnecting:(BOOL)flag
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = flag;
    if (flag) {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"Connecting...";
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - Server connecting

- (void) loginWithNativeUser:(NSString *)email password:(NSString *)password
{
    [userDefault setObject:kLoginModeNative forKey:kLoginMode];
    [userDefault setObject:@{@"email": email, @"password": password} forKey:kLoginUserInfo];
    [userDefault synchronize];
    
    [self internetConnecting:YES];
    
    NSString     *requestURLString = [NSString stringWithFormat:@"%@/api/login_email", SERVER_URL];
    NSDictionary *params = @{@"apikey": API_KEY,
                             @"flavour" : FLAVOUR,
                             @"email" :email,
                             @"password" : password,
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---- LOGIN RESULT ----\n%@", operation.responseString);
        
        [self internetConnecting:NO];
        [self requestResultCheckingWithObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self internetConnecting:NO];
        
    }];
}

- (void) requestResultCheckingWithObject:(id)responseObject
{
    if (responseObject) {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        NSLog(@"%@", data);
        if ([[data objectForKey:@"success"] boolValue]) {
            appManager.loginResult = [[LoginResult alloc] initWithDictionary:data];
            
            DiveListViewController *viewController = [[DiveListViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            self.txtPassword.text = @"";
            
        } else {
            
        }
    }
}

#pragma mark - Facebook connecting

- (void) facebookConnecting
{
    if (fbSession.isOpen) {
        [fbSession closeAndClearTokenInformation];
    }
    else
    {
        if (fbSession.state != FBSessionStateCreated || !fbSession) {
            fbSession = [[FBSession alloc] init];
        }
        
        [fbSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            NSDictionary *fbUserInfo = [self LoadingFacebookInformation];
            if (fbUserInfo) {
                [userDefault setObject:kLoginModeFB forKey:kLoginMode];
                [userDefault setObject:fbUserInfo forKey:kLoginUserInfo];
                [userDefault synchronize];
                [self loginActionWithFacebookUser:fbUserInfo];
            }
            
        }];
        
    }

}

-(NSDictionary *) LoadingFacebookInformation
{
    if (fbSession.isOpen)
    {
        
        NSLog(@"--- access token is ---: %@", fbSession.accessTokenData.accessToken);
        
        NSString *requestURL = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", fbSession.accessTokenData.accessToken];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"FACEBOOK USER INFORMATION : %@", returnString);

        if (returnData) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:returnData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            NSDictionary *loginInfo = @{@"fbid":     [data objectForKey:@"id"],
                                        @"fbtoken" : fbSession.accessTokenData.accessToken,
                                        };
            return loginInfo;
        }
    }
    else
    {
        NSLog(@"access token is not get.");
    }
    return Nil;
}

- (void) loginActionWithFacebookUser:(NSDictionary *)info
{
    NSString *fbLoginURLString = [NSString stringWithFormat:@"%@/api/login_fb", SERVER_URL];
    NSDictionary *params = @{@"apikey": API_KEY,
                             @"flavour" : FLAVOUR,
                             @"fbid" : [info objectForKey:@"fbid"],
                             @"fbtoken": [info objectForKey:@"fbtoken"],
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:fbLoginURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        [self requestResultCheckingWithObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Notification

- (void) keyboardShowHideAnimationSetting
{
    NSNotificationCenter*   notificationCenter  = [ NSNotificationCenter defaultCenter ] ;
    
    //    [ notificationCenter addObserver : self selector : @selector( didShowKeyBoard: ) name : UIKeyboardDidShowNotification object : nil ] ;
    [ notificationCenter addObserver : self selector : @selector( willHideKeyBoard: ) name : UIKeyboardWillHideNotification object : nil ] ;
    
}

- ( void ) didShowKeyBoard : ( NSNotification* ) _notification
{
    
}

- ( void ) willHideKeyBoard : ( NSNotification* ) _notification
{
    [UIView animateWithDuration:0.3f animations:^{
        [ self.view setFrame : CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
    }];
}

@end
