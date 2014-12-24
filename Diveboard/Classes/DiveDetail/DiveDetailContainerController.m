//
//  Diveboard
//
//  Created by Vladimir Popov on 3/4/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#define kDetailBtnName    @"details"
#define kPhotosBtnName    @"photos"
#define kMapBtnName       @"map"

#define kPhotoImageViewTag  100

#import "DiveDetailContainerController.h"
#import <CoreLocation/CoreLocation.h>
#import "DiveEditViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DivePicturesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+LBBlurredImage.h"
#import "DXStarRatingView.h"
#import "DiveGraphViewController.h"
#import "DiveDetailViewController.h"
#import "DiveDetailMapViewController.h"
#import "DiveDetailPhotosViewController.h"
@interface DiveDetailContainerController () <DiveDetailPhotosViewDelegate,DiveDetailViewControllerDelegate,DiveEditViewControllerDelegate>
{
    DiveInformation *m_DiveInformation;
    BOOL       isFirst;
    DiveDetailViewController        *m_detailViewController;
    DiveDetailPhotosViewController  *m_photosViewController;
    DiveDetailMapViewController     *m_mapViewController;
    
    
}

@end

@implementation DiveDetailContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDiveInformation:(DiveInformation *) diveInfo
{
    NSString *nibFilename;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibFilename = @"DiveDetailContainerController";
    } else {
        nibFilename = @"DiveDetailContainerController-ipad";
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
    
    [self initMethod];
    
}

- (void) initMethod
{
    
    isFirst = YES;
    m_detailViewController = [[DiveDetailViewController alloc] initWithDiveInformation:m_DiveInformation];
    m_detailViewController.delegate = self;
    
    m_photosViewController = [[DiveDetailPhotosViewController alloc] initWithDiveInformation:m_DiveInformation];
    m_photosViewController.delegate = self;
    m_mapViewController = [[DiveDetailMapViewController alloc] initWithDiveInformation:m_DiveInformation];
    
    
    
    
    
}
- (void)showDiveData
{
    // trip name
    [lblTripName            setText:m_DiveInformation.tripName];
    
     NSMutableString* strCityCountry = [NSMutableString stringWithFormat:@""];
    
    if ([m_DiveInformation.spotInfo.ID floatValue] !=1 ) {
        
         strCityCountry = [NSMutableString stringWithFormat:@"%@",m_DiveInformation.spotInfo.locationName];
        
        if (![m_DiveInformation.spotInfo.countryName isEqualToString:@""]) {
            
            [strCityCountry appendFormat:@", %@",m_DiveInformation.spotInfo.countryName];
        }
        
    }
    
    
    [lblCityCountry         setText:strCityCountry];
    
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        // internet is offline
        
        
        NSString* imgURL = m_DiveInformation.imageURL;
        UIImage *backgroundImage = nil;
        if ([[imgURL lowercaseString] hasPrefix:@"http://"] || [[imgURL lowercaseString] hasPrefix:@"https://"])
        {
            backgroundImage = [[DiveOfflineModeManager sharedManager] getImageWithUrl:imgURL];
            
        }else{
            
            backgroundImage = [[DiveOfflineModeManager sharedManager] getLocalDivePicture:imgURL];
        }
        [self.imgViewBackground setImageToBlur:backgroundImage blurRadius:3.0f completionBlock:^(NSError *error) {
            
        }];
        
    }
    else {
        
        // internet is online
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:m_DiveInformation.imageURL]];
        [self.imgViewBackground setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.imgViewBackground setImageToBlur:image blurRadius:3.0f completionBlock:^(NSError *error) {
                
            }];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            [DiveOfflineModeManager sharedManager].isOffline = YES;
            NSString* imgURL = m_DiveInformation.imageURL;
            UIImage *backgroundImage = nil;
            if ([[imgURL lowercaseString] hasPrefix:@"http://"] || [[imgURL lowercaseString] hasPrefix:@"https://"])
            {
                backgroundImage = [[DiveOfflineModeManager sharedManager] getImageWithUrl:imgURL];
                
            }else{
                
                backgroundImage = [[DiveOfflineModeManager sharedManager] getLocalDivePicture:imgURL];
            }
            [self.imgViewBackground setImageToBlur:backgroundImage blurRadius:3.0f completionBlock:^(NSError *error) {
                
            }];
            
            

        }];
    }
    


}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        [viewContent addSubview:m_detailViewController.view];
        [m_detailViewController.view setHidden:YES];
        
        [viewContent addSubview:m_photosViewController.view];
        [m_photosViewController.view setHidden:YES];
        
        [viewContent addSubview:m_mapViewController.view];
        [m_mapViewController.view setHidden:YES];
        [self clickButtonWithName:btnDetails];
        isFirst = NO;
    }
    [self showDiveData];
    
}

-(void)viewWillLayoutSubviews
{
    
    [m_detailViewController.view setFrame:viewContent.bounds];
    [m_photosViewController.view setFrame:viewContent.bounds];
    [m_mapViewController.view setFrame:viewContent.bounds];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button & Tap Actions

- (IBAction)tapButtonAction:(id)sender {
    [self clickButtonWithName:(UIButton *)sender];
    
}
- (void)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) clickButtonWithName:(UIButton *)button
{
    if (button == btnDetails) {
        viewDetailBox.backgroundColor = [UIColor whiteColor];
        [imgviewDetailBtn setImage:[UIImage imageNamed:@"ic_details_grey"]];
        lblDetailBtn.textColor = [UIColor blackColor];
        
        [m_detailViewController.view setHidden:NO];
        
    } else {
        viewDetailBox.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        
        [imgviewDetailBtn setImage:[UIImage imageNamed:@"ic_details_white"]];
        lblDetailBtn.textColor = [UIColor whiteColor];
        
        [m_detailViewController.view setHidden:YES];
    }
    
    if (button == btnPhotos) {
        viewPhotosBox.backgroundColor = [UIColor whiteColor];
        [imgviewPhotosBtn setImage:[UIImage imageNamed:@"ic_photos_grey"]];
        lblPhotosBtn.textColor = [UIColor blackColor];
        
        [m_photosViewController.view setHidden:NO];

    } else {
        viewPhotosBox.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        [imgviewPhotosBtn setImage:[UIImage imageNamed:@"ic_photos_white"]];
        lblPhotosBtn.textColor = [UIColor whiteColor];

        [m_photosViewController.view setHidden:YES];
    }
    
    if (button == btnMap) {
        viewMapBox.backgroundColor = [UIColor whiteColor];
        [imgviewMapBtn setImage:[UIImage imageNamed:@"ic_map_grey"]];
        lblMapBtn.textColor = [UIColor blackColor];
        
        [m_mapViewController.view setHidden:NO];
        
    } else {
        viewMapBox.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        [imgviewMapBtn setImage:[UIImage imageNamed:@"ic_map_white"]];
        lblMapBtn.textColor = [UIColor whiteColor];
        
        [m_mapViewController.view setHidden:YES];

    }
    
    m_btnCurrentTab = button;
    
    
}

-(void)didSelectedPhotoCell:(int)index
{
    DivePicturesViewController *viewController = [[DivePicturesViewController alloc] initWithPicturesData:m_DiveInformation.divePictures];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:^{
        [viewController showPictureWithIndex:index];
    }];

}

-(void)didClickedDeleteButton
{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete Dive"
                                                          message:@"Are you about to delete this dive?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Delete", nil];
    [deleteAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Delete Dive"]) {
        if (buttonIndex == 1) {
            
            [self diveDeleteRequest];
            
        }
    }
}
#pragma mark - Dive delete

- (void) diveDeleteRequest
{
    
    [SVProgressHUD showWithStatus:@"Deleting..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/dive/%@", SERVER_URL, m_DiveInformation.ID];
    NSDictionary *params = @{@"auth_token": [AppManager sharedManager].loginResult.token,
                             @"apikey"    : API_KEY,
                             };
    
    // offline
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        NSDictionary *dic = @{kRequestKey: requestURLString,
                              kRequestParamKey : params
                              };
        [[DiveOfflineModeManager sharedManager] diveEdit:dic :m_DiveInformation.isLocal :m_DiveInformation.ID];
        
        [[DiveOfflineModeManager sharedManager] deleteDiveID:m_DiveInformation.ID];
        
        [self deleteDiveSuccess];
        
    }
    // online
    else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager DELETE:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"success"] boolValue]) {
                    //                [self.diveListViewController diveViewsUpdate];
                    
                    [self deleteDiveSuccess];
                    
                } else {
                    
                    [[DiveOfflineModeManager sharedManager] deleteDiveID:m_DiveInformation.ID];
                    
                    [self deleteDiveSuccess];
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [DiveOfflineModeManager sharedManager].isOffline = YES;
            
            [self diveDeleteRequest];
            
        }];
    }
}

- (void) deleteDiveSuccess
{
    for (id diveID in [AppManager sharedManager].loginResult.user.allDiveIDs) {
        NSString *diveIDStr = [NSString stringWithFormat:@"%@", diveID];
        if ([m_DiveInformation.ID isEqualToString:diveIDStr]) {
            [[AppManager sharedManager].loginResult.user.allDiveIDs removeObject:diveID];
            
            [[AppManager sharedManager].diveListVC diveViewsUpdate];
            break;
        }
    }
    
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)didClickedEditButton

{
    [SVProgressHUD show];
    
//    __block DiveEditViewController *viewController;
    
    dispatch_queue_t dqueue = dispatch_queue_create("com.diveboard.gotodiveedit", 0);
    
    dispatch_async(dqueue, ^{
        
        DiveEditViewController *viewController = [[DiveEditViewController alloc] initWithDiveData:m_DiveInformation];

        [viewController setEditDelegate:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
            [SVProgressHUD dismiss];
            
        });
        
    });
    
    
}
-(void)diveEditFinish:(DiveInformation *)diveInfo{
 
    m_DiveInformation = diveInfo;
    [m_detailViewController setDiveInformation:m_DiveInformation];
    [m_photosViewController setDiveInformation:m_DiveInformation];
    [m_mapViewController setDiveInformation:m_DiveInformation];
    
}



@end
