//
//  DiveGraphViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 10/1/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveGraphViewController.h"
#import "MRZoomScrollView.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
@interface DiveGraphViewController ()
{
    MRZoomScrollView* zoomScrollView;
    DiveInformation* m_DiveInformation;
}
@end

@implementation DiveGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDiveData:(DiveInformation *)diveInfo
{
 
    
    NSString *nibFilename;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibFilename = @"DiveGraphViewController";
    } else {
        nibFilename = @"DiveGraphViewController-ipad";
    }
    
    self = [self initWithNibName:nibFilename bundle:nil];
    
    if (self) {
        
        m_DiveInformation = diveInfo;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    
    zoomScrollView = [[MRZoomScrollView alloc] initWithFrame:frame];
    [m_viewContainer addSubview:zoomScrollView];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    

    
    NSString *myNickName = [[AppManager sharedManager].loginResult.user.nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *diveShakenID   = m_DiveInformation.shakenID;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/profile.png?g=mobile_v003&u=m", SERVER_URL, myNickName, diveShakenID];
    
    
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        
        [zoomScrollView.imageView setImage:[[DiveOfflineModeManager sharedManager] getImageWithUrl:urlString]];

        [SVProgressHUD dismiss];
        
    }else{
        
        [zoomScrollView.imageView clearImageCacheForURL:[NSURL URLWithString:urlString]];
        UIImageView *imgviewGraph = zoomScrollView.imageView;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [zoomScrollView.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            [imgviewGraph setImage:image];
            
            [SVProgressHUD dismiss];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            [imgviewGraph setImage:[[DiveOfflineModeManager sharedManager] getImageWithUrl:urlString]];
            [SVProgressHUD dismiss];
            
        }];
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)onClose:(id)sender{
    
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
