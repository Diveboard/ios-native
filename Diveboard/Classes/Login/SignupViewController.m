//
//  SignupViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/11/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#define kCOLOR(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]

#import "SignupViewController.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "DiveListViewController.h"


@interface SignupViewController ()
{
    BOOL isKeep, isAgree;
    AppManager *appManager;
    NSUserDefaults *userDefault;
    
    FBSession *fbSession;
}
@end

@implementation SignupViewController

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
    
    // setting custom font
//    UIFont *QuicksandRegular =      [UIFont fontWithName:@"Quicksand-Regular" size:10.0f];
//    UIFont *QuicksandRegular_small = [UIFont fontWithName:@"Quicksand-Regular" size:9.0f];
//    UIFont *QuicksandBold =         [UIFont fontWithName:@"Quicksand-Bold" size:17.0f];

    appManager = [AppManager sharedManager];
    userDefault = [NSUserDefaults standardUserDefaults];
    fbSession = appManager.fbSession;
    
    [self initMethod];
    
    [self.scrMainView setContentSize:CGSizeMake(CGRectGetWidth(self.scrMainView.frame), CGRectGetMaxY(self.btnFBLogin.frame) + 5)];
}

- (void) initMethod
{
//    float textFieldFontSize = 13.0f;
//    _lblTitle.font              = [UIFont fontWithName:kDefaultFontName size:18.0f];
//    _txtEmail.font              = [UIFont fontWithName:kDefaultFontName size:textFieldFontSize];
//    _txtPassword.font           = [UIFont fontWithName:kDefaultFontName size:textFieldFontSize];
//    _txtConfirmPassword.font    = [UIFont fontWithName:kDefaultFontName size:textFieldFontSize];
//    _txtDiveboardURL.font       = [UIFont fontWithName:kDefaultFontName size:textFieldFontSize];
//    _txtNickname.font           = [UIFont fontWithName:kDefaultFontName size:textFieldFontSize];
//    _btnSignup.titleLabel.font  = [UIFont fontWithName:kDefaultFontNameBold size:15.0f];
        _btnSignup.layer.cornerRadius = 4;
        _btnSignup.clipsToBounds = YES;

//    _btnFBLogin.titleLabel.font = [UIFont fontWithName:kDefaultFontName size:10.0f];
//    _lblKeep.font               = [UIFont fontWithName:kDefaultFontName size:12.0f];
//    _lblIAgree.font             = [UIFont fontWithName:kDefaultFontName size:12.0f];
    
    [self setCircleButton:_btnAgree];
    isAgree = FALSE;
    
    [self setCircleButton:_btnKeep];
    isKeep = FALSE;
}

- (void) setCircleButton:(UIButton *)button
{
    button.layer.cornerRadius = _btnKeep.frame.size.width / 2;
    button.layer.borderColor  = [UIColor darkGrayColor].CGColor;
    button.layer.borderWidth  = 0.65f;
    button.backgroundColor = kCOLOR(0.9f, 0.9f, 0.9f, 1.0f);
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton actions

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionKeep:(id)sender {
    isKeep = !isKeep;
    [self checkOfOption:_btnKeep option:isKeep];
}

- (IBAction)actionAgree:(id)sender {
    isAgree = !isAgree;
    [self checkOfOption:_btnAgree option:isAgree];
}

- (void) checkOfOption:(UIButton *)button option:(BOOL)option
{
    if (option) {
        button.backgroundColor = kCOLOR(0.98f, 0.68f, 0.09f, 1.0f);
    } else {
        button.backgroundColor = kCOLOR(0.9f, 0.9f, 0.9f, 1.0f);
    }
}

#pragma mark - Sign Up

- (IBAction)actionSignup:(id)sender {
    if ([self checkingUserInformation]) {
        
        [self signUpToServer];
        
    }
}

- (BOOL) checkingUserInformation
{
    BOOL result = NO;
    
    if (_txtEmail.text.length < 6) {
        [self alertViewShow:@"Please enter correct email address."];
    }
    else if (_txtPassword.text.length < 5 || _txtPassword.text.length > 20) {
        [self alertViewShow:@"Please enter password from 5 to 20 characters."];
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        [self alertViewShow:@"Please enter correct password."];
    }
    else if (_txtDiveboardURL.text.length < 5) {
        [self alertViewShow:@"Please enter correct Diveboard URL address."];
    }
    else if (_txtNickname.text.length < 3 || _txtNickname.text.length > 20) {
        [self alertViewShow:@"Please enter ninkname from 3 to 20 characters."];
    }
    else if (!isAgree) {
        [self alertViewShow:@"You must agree our terms."];
    }
    else {
        result = YES;
    }
    
    return result;
}

- (void) alertViewShow:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
    
}

- (void) signUpToServer
{
    [self internetConnecting:YES];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/register_email", SERVER_URL];
    NSString * email         = _txtEmail.text;
    NSString * password      = _txtPassword.text;
    NSString * diveURL       = _txtDiveboardURL.text;
    NSString * nickName      = _txtNickname.text;
    NSString * keep          = (isKeep ? @"true" : @"false");

    NSDictionary *params = @{@"apikey": API_KEY,
                             @"email" : email,
                             @"vanity_url" : diveURL,
                             @"password" : password,
                             @"password_check" : password,
                             @"nickname" : nickName,
                             @"accept_newsletter_email" : keep,
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---- signup result ---\n%@", operation.responseString);
        
        [self signUpFinishAction:responseObject];
        
        [self internetConnecting:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                    message:@"A connection failure occurred"
                                   delegate:Nil
                          cancelButtonTitle:@"Retry"
                          otherButtonTitles: nil]
         show];
        [self internetConnecting:NO];
    }];
}

- (void) signUpFinishAction:(id)responseObject
{
    if (responseObject) {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        NSLog(@"%@", data);
        BOOL signUpSuccess = [[data objectForKey:@"success"] boolValue];
        if (!signUpSuccess) {   // error
            NSMutableString *errorMsg = [[NSMutableString alloc] init];
            for (NSDictionary *oneError in [data objectForKey:@"errors"]) {
                [errorMsg appendString:[oneError objectForKey:@"error"]];
                [errorMsg appendString:@".\n"];
            }
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:errorMsg
                                       delegate:Nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
        }
        else  // success!
        {
            
            [self requestResultCheckingWithObject:data];
            
        }
        

    }
}


- (void) requestResultCheckingWithObject:(NSDictionary *)data
{
    
        [userDefault setObject:kLoginModeNative forKey:kLoginMode];
        [userDefault setObject:@{@"email": _txtEmail.text, @"password": _txtPassword.text} forKey:kLoginUserInfo];
        [userDefault synchronize];

        appManager.loginResult = [[LoginResult alloc] initWithDictionary:data];
        appManager.loginResult.user.allDiveIDs = [NSMutableArray arrayWithArray:[[appManager.loginResult.user.allDiveIDs reverseObjectEnumerator] allObjects]];
        
        DiveListViewController *viewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewController = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
        } else {
            viewController = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - Facebook Login

- (IBAction)fbConnect:(id)sender {
        [self internetConnecting:YES];
        //    [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(facebookConnecting) userInfo:Nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(facebookConnecting) userInfo:nil repeats:NO];
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
        if (responseObject) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            NSLog(@"%@", data);
            if ([[data objectForKey:@"success"] boolValue]) {
                [self requestResultCheckingWithObject:data];
            } else {
                
            }
        }

        [self internetConnecting:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self internetConnecting:NO];
    }];
}


#pragma mark -



#pragma mark - UITextField delegate


#pragma mark -

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


@end
