//
//  DiveDetailViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/4/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#define kDetailBtnName    @"details"
#define kPhotosBtnName    @"photos"
#define kMapBtnName       @"map"

#define kPhotoImageViewTag  100

#import "DiveDetailViewController.h"
#import "AsyncUIImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "DiveEditViewController.h"
#import "DiveListViewController.h"
#import "AFNetworking.h"
#import "MMProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "DivePicturesViewController.h"


@interface DiveDetailViewController () <DiveEditViewControllerDelegate, UIAlertViewDelegate>
{
    AppManager *appManager;
    DiveInformation *diveInformation;
    BOOL       isFirst;
}

@end

@implementation DiveDetailViewController

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
        nibFilename = @"DiveDetailViewController";
    } else {
        nibFilename = @"DiveDetailViewController-ipad";
    }
    
    self = [self initWithNibName:nibFilename bundle:nil];
    if (self) {
        diveInformation = diveInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appManager = [AppManager sharedManager];
    [self initMethod];
    
}

- (void) initMethod
{
    
    isFirst = YES;
//    [viewContent addSubview:viewDetail];
    [self setBorderToView:vdGraphBox];
    [self setBorderToView:vdviewGraph];
//    [self setBorderToView:vdDateBox];
    [self setBorderToView:vdNoteBox];
    
    vdbtnDelete.layer.cornerRadius = 5.0f;
    vdbtnEdit.layer.cornerRadius = 5.0f;
}

- (void) setBorderToView:(UIView *)view
{
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderColor = [UIColor colorWithWhite:0.2f alpha:0.8f].CGColor;
    view.layer.borderWidth = 1.0f;
}

- (void) viewDidAppear:(BOOL)animated
{
    
    if (isFirst) {
        [self setDiveInformationToView];
        [self setDivePicturesToView];
        [self setMapToView];

        [self clickButtonWithName:btnDetails];
        isFirst = NO;
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self photosViewRelayout];
}

- (void) setDiveInformationToView
{
    
    
    [viewContent addSubview:viewDetail];

    // trip name
    [lblTripName            setText:diveInformation.tripName];
    [lblCityCountry         setText:[NSString stringWithFormat:@"%@, %@",
                                     diveInformation.spotInfo.locationName,
                                     diveInformation.spotInfo.countryName]];
    // username , photo
    [vdimgUserAvator setImageURL:[NSURL URLWithString:appManager.loginResult.user.pictureSmall]
                     placeholder:Nil];
    vdimgUserAvator.layer.cornerRadius = vdimgUserAvator.frame.size.width / 2;
    
    
    [vdlblNickname          setText:appManager.loginResult.user.nickName];
    
    if ([appManager.loginResult.user.danData.address isKindOfClass:[NSArray class]]) {
        id country = [appManager.loginResult.user.danData.address lastObject];
        if (country != [NSNull null]) {
            [vdlblCountry           setText:(NSString *)country];
        } else {
            [vdlblCountry setText:@""];
        }

    }
//    [vdlblCountry           setText:[appManager.loginResult.user.danData.address lastObject]];
    
//    return;

    // dive shop
    if (diveInformation.diveShop.name.length > 0) {
        [vdlblShopContent       setText:diveInformation.diveShop.name];
    } else {
        [vdlblShopContent       setText:@"No shop"];
    }
    
    if (diveInformation.diveShop.picture.length > 0) {
        [imgviewShop setImageURL:[NSURL URLWithString:diveInformation.diveShop.picture] placeholder:nil];
    }
    
    
    
    // graph
    if (![DiveOfflineModeManager sharedManager].isOffline) {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/profile.png?g=mobile_v002&u=m", SERVER_URL, appManager.loginResult.user.nickName, diveInformation.shakenID];
        [vdimgviewGraph setImageURL:[NSURL URLWithString:urlString] placeholder:Nil];
    }
    
    // dive max depth
    [vdlblDepth setText:[DiveInformation unitOfLengthWithValue:diveInformation.maxDepth
                                                   defaultUnit:diveInformation.maxDepthUnit]];
    

    // dieve date
    [vdlblDateContent       setText:[NSString stringWithFormat:@"%@ %@",
                                     diveInformation.date,
                                     diveInformation.time]];
    

    [vdlblDurationContent   setText:[NSString stringWithFormat:@"%@ mins", diveInformation.duration]];
    
    int itemCount = 0;
    if (diveInformation.date.length         > 0) itemCount++;
    if (diveInformation.duration.length     > 0) itemCount++;
    if (diveInformation.visibility.length   > 0) itemCount++;
    if (diveInformation.temp.bottom.length  > 0 ||
        diveInformation.temp.surface.length > 0) itemCount++;
    if (diveInformation.water.length        > 0) itemCount++;
    if (diveInformation.diveType.count      > 0) itemCount++;

    float dt = 32.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        dt = 54.0f;
    
    [vdDateBox    setFrame:CGRectMake(0,
                                     CGRectGetMaxY(vdGraphBox.frame),
                                     CGRectGetWidth(viewDetail.frame),
                                     (int)(itemCount / 2.0f + 0.5f) * dt)];
//    [vdDateBox setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.7f]];
    
    if (diveInformation.visibility.length > 0) {
        [vdlblVisibiltyContent setText:[diveInformation.visibility capitalizedString]];
    } else {
        [vdlblVisibiltyTitle setHidden:YES];
        [vdlblVisibiltyContent setHidden:YES];
        
        [vdlblWaterTitle setFrame:vdlblVisibiltyTitle.frame];
        [vdlblWaterContent setFrame:vdlblVisibiltyContent.frame];
    }
    
    if (diveInformation.temp.bottom.length > 0 || diveInformation.temp.surface.length > 0) {
        [vdlblTempContent setText:[NSString stringWithFormat:@"SURF %@ | BOTTOM %@",
                                   [DiveInformation unitOfTempWithValue:diveInformation.temp.surface defaultUnit:diveInformation.temp.surfaceUnit],
                                   [DiveInformation unitOfTempWithValue:diveInformation.temp.bottom defaultUnit:diveInformation.temp.bottomUnit]
                                   ]];
    } else {
        [vdlblTempTitle setHidden:YES];
        [vdlblTempContent setHidden:YES];
        
        [vdlblDivetypeTitle setFrame:vdlblTempTitle.frame];
        [vdlblDivetypeContent setFrame:vdlblTempContent.frame];
    }
    
    if (diveInformation.water.length > 0) {
        [vdlblWaterContent setText:[diveInformation.water capitalizedString]];
    } else {
        [vdlblWaterTitle setHidden:YES];
        [vdlblWaterContent setHidden:YES];
    }
    
    
    if (diveInformation.diveType && diveInformation.diveType.count > 0) {
        NSMutableString *diveType = [[NSMutableString alloc] init];
        for (NSString *ty in diveInformation.diveType) {
            [diveType appendString:[NSString stringWithFormat:@"%@, ", ty]];
        }
        [vdlblDivetypeContent setText:[diveType substringToIndex:(diveType.length - 2)]];
    } else {
        [vdlblDivetypeContent setHidden:YES];
        [vdlblDivetypeTitle setHidden:YES];
    }
    
    CGSize sizeToFit;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    sizeToFit = [diveInformation.note boundingRectWithSize: CGSizeMake(CGRectGetWidth(vdNoteBox.frame) * 0.95f, CGFLOAT_MAX)
                                                   options: NSStringDrawingUsesLineFragmentOrigin
                                                attributes: @{ NSFontAttributeName : [UIFont fontWithName:kDefaultFontName size:10.0f] }
                                                   context: nil].size;
#else
    sizeToFit = [diveInformation.note sizeWithFont:[UIFont fontWithName:kDefaultFontName size:10.0f]
                                 constrainedToSize:CGSizeMake(CGRectGetWidth(vdlblNoteContent.frame) * 0.9f, CGFLOAT_MAX)
                                     lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    if (sizeToFit.height < 20) {
        sizeToFit.height = 20.0f;
    }
    
    [vdNoteBox setFrame:CGRectMake(0, CGRectGetMaxY(vdDateBox.frame), CGRectGetWidth(viewContent.frame), sizeToFit.height * 1.1f)];
    [vdlblNoteContent setFrame:CGRectInset(vdNoteBox.bounds, 5.0f, 5.0f)];
    if (diveInformation.note.length > 0) {
        [vdlblNoteContent setText:diveInformation.note];
    } else {
        [vdlblNoteContent setText:@"No Note for thid dive."];
    }

    if (!btnViewDiveBrowser) {
        btnViewDiveBrowser = [UIUnderlineButton underlineButton];
        [btnViewDiveBrowser setBackgroundColor:[UIColor clearColor]];
        [btnViewDiveBrowser setTitle:@"View dive in Brower" forState:(UIControlStateNormal)];
        [btnViewDiveBrowser setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [btnViewDiveBrowser.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
        [btnViewDiveBrowser addTarget:self action:@selector(openBrowser) forControlEvents:UIControlEventTouchUpInside];
    }
    CGRect btnBrowerRect = CGRectMake(0, CGRectGetMaxY(vdNoteBox.frame) + 10.0f, 130, 30.0f);
    [btnViewDiveBrowser setFrame:btnBrowerRect];
    [viewDetail addSubview:btnViewDiveBrowser];
    
    [viewDetail setFrame:CGRectMake(0, 0, CGRectGetWidth(viewContent.frame), CGRectGetMaxY(btnViewDiveBrowser.frame) + 10)];
    [viewDetail setHidden:YES];
    
}

- (void) openBrowser
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, appManager.loginResult.user.nickName, diveInformation.shakenID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void) setDivePicturesToView
{
    if (diveInformation.divePictures.count > 0) {
        for (int i = 0; i < diveInformation.divePictures.count; i ++) {
            DivePicture *picture = [diveInformation.divePictures objectAtIndex:i];
            AsyncUIImageView *imageView = [[AsyncUIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
            [imageView setContentMode:(UIViewContentModeScaleAspectFill)];
            [imageView setClipsToBounds:YES];
            [imageView setImageURL:[NSURL URLWithString:picture.mediumURL] placeholder:Nil];
            [imageView setBackgroundColor:[UIColor blackColor]];
            [imageView setIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
            [imageView setTag:(kPhotoImageViewTag + i)];
            [imageView setUserInteractionEnabled:YES];
            
            [photosContent addSubview:imageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            [imageView addGestureRecognizer:tapGesture];
        }

    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((viewContent.frame.size.width - 100) / 2, 50, 100, 25)];
        [label setText:@"No photos"];
        [label setTextColor:[UIColor blackColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:kDefaultFontName size:14.0f]];
        [photosContent addSubview:label];
    }
    [viewContent addSubview:photosContent];
    [photosContent setHidden:YES];
    [self photosViewRelayout];
}

- (void) imageTapAction:(UITapGestureRecognizer *)sender
{
    int index = sender.view.tag - kPhotoImageViewTag;
    DivePicturesViewController *viewController = [[DivePicturesViewController alloc] initWithPicturesData:diveInformation.divePictures];
//    viewController.startIndex = index;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:^{
        [viewController showPictureWithIndex:index];
    }];
}

- (void) photosViewRelayout {
    int    unit;
    if (isPortrateScreen) {
        unit = 2;
    } else {
        unit = 3;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        unit++;
    }
    float dx = viewContent.frame.size.width / unit;
    int index = 0;
    for (UIView *view in photosContent.subviews) {
        if ([view isKindOfClass:[AsyncUIImageView class]]) {
            CGRect rect = CGRectMake((index % unit) * dx, (int)(index / unit) * dx, dx, dx);
            [view setFrame:rect];
            index ++;
            [photosContent setFrame:CGRectMake(0, 0, viewContent.frame.size.width, CGRectGetMaxY(view.frame))];
        }
    }
    if (index == 0) {
        [photosContent setFrame:viewContent.bounds];

    }
    [viewContent setContentSize:photosContent.frame.size];
}

- (void) setMapToView
{
    [self updateMapView];
    
    [viewContent addSubview:mapView];
    [mapView setHidden:YES];
    [self mapViewRelayout];
    
}

- (void) updateMapView
{
#define METERS_PER_MILE 1609.344
    // 1
    CLLocationCoordinate2D zoomLocation;
    if (diveInformation.spotInfo.lat.length > 0) {
        zoomLocation.latitude = [diveInformation.spotInfo.lat floatValue];
    } else {
        zoomLocation.latitude = 0;
    }
    if (diveInformation.spotInfo.lng.length > 0) {
        zoomLocation.longitude = [diveInformation.spotInfo.lng floatValue];
    } else {
        zoomLocation.longitude = 0;
    }
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    
    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:zoomLocation];
    [mapView addAnnotation:annotation];

}

- (void) mapViewRelayout
{
    
    [mapView setFrame:viewContent.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapButtonAction:(id)sender {
    [self clickButtonWithName:(UIButton *)sender];
    
}

- (IBAction)closeAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(gotoPrevViewController:) userInfo:nil repeats:NO];
}

- (void) gotoPrevViewController:(NSTimer *)dt
{
    NSLog(@"--- prev ----");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)diveEditAction:(id)sender {
    DiveEditViewController *viewController = [[DiveEditViewController alloc] initWithDiveData:diveInformation];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [viewController setDelegate:self];
    
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)diveEditFinish:(DiveInformation *)diveInfo
{
    NSLog(@"%@", diveInfo);
    diveInformation = diveInfo;
    [self.diveView setDiveInformation:diveInformation];
    [self setDiveInformationToView];
    [self updateMapView];
    
    [viewDetail setHidden:NO];
}


- (IBAction)diveDeleteAction:(id)sender {
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

- (void) diveDeleteRequest
{
    
    [MMProgressHUD setPresentationStyle:(MMProgressHUDPresentationStyleShrink)];
    [MMProgressHUD showWithTitle:@"Dive Information" status:@"Updating..."];

    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/dive/%@", SERVER_URL, diveInformation.ID];
    NSDictionary *params = @{@"auth_token": appManager.loginResult.token,
                             @"apikey"    : API_KEY,
                             };
    
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        NSDictionary *dic = @{kRequestKey: requestURLString,
                              kRequestParamKey : params
                              };
        [[DiveOfflineModeManager sharedManager] diveEdit:dic];
        
        [[DiveOfflineModeManager sharedManager] deleteDiveID:diveInformation.ID];
        
        [self deleteDiveSuccess];
        
    }
    else {
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager DELETE:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"delete operation : %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"success"] boolValue]) {
    //                [self.diveListViewController diveViewsUpdate];
                    
                    [self deleteDiveSuccess];
                    
                } else {
                    [MMProgressHUD dismissWithSuccess:@"Error" title:@"Delete"];

                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                message:[NSString stringWithFormat:@"%@", responseObject]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles: nil]
                     show];
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MMProgressHUD dismissWithSuccess:@"Error" title:@"Delete"];

            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"%@", error]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil]
             show];
        }];
    }
}

- (void) deleteDiveSuccess
{
    for (id diveID in appManager.loginResult.user.allDiveIDs) {
        NSString *diveIDStr = [NSString stringWithFormat:@"%@", diveID];
        if ([diveInformation.ID isEqualToString:diveIDStr]) {
            [appManager.loginResult.user.allDiveIDs removeObject:diveID];
            [self.diveListViewController diveViewsUpdate];
            break;
        }
    }
    
    [MMProgressHUD dismissWithSuccess:@"Deleted Dive" title:@"Success!"];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) clickButtonWithName:(UIButton *)button
{
    [viewContent setContentOffset:CGPointMake(0, 0)];
    if (button == btnDetails) {
        viewDetailBox.backgroundColor = [UIColor whiteColor];
        [imgviewDetailBtn setImage:[UIImage imageNamed:@"ic_details_grey"]];
        lblDetailBtn.textColor = [UIColor blackColor];
        [viewContent setBackgroundColor:[UIColor whiteColor]];
        [viewContent setContentSize:viewDetail.frame.size];
        [viewDetail setHidden:NO];
    } else {
        viewDetailBox.backgroundColor = [UIColor clearColor];
        [imgviewDetailBtn setImage:[UIImage imageNamed:@"ic_details_white"]];
        lblDetailBtn.textColor = [UIColor whiteColor];
        [viewDetail setHidden:YES];
    }
    
    if (button == btnPhotos) {
        viewPhotosBox.backgroundColor = [UIColor whiteColor];
        [imgviewPhotosBtn setImage:[UIImage imageNamed:@"ic_photos_grey"]];
        lblPhotosBtn.textColor = [UIColor blackColor];
        if (diveInformation.divePictures.count > 0) {
            [viewContent setBackgroundColor:[UIColor blackColor]];
        } else {
            [viewContent setBackgroundColor:[UIColor whiteColor]];
        }
        
        
        [viewContent setContentSize:photosContent.frame.size];
        [photosContent setHidden:NO];
    } else {
        viewPhotosBox.backgroundColor = [UIColor clearColor];
        [imgviewPhotosBtn setImage:[UIImage imageNamed:@"ic_photos_white"]];
        lblPhotosBtn.textColor = [UIColor whiteColor];
        [photosContent setHidden:YES];
    }
    
    if (button == btnMap) {
        viewMapBox.backgroundColor = [UIColor whiteColor];
        [imgviewMapBtn setImage:[UIImage imageNamed:@"ic_map_grey"]];
        lblMapBtn.textColor = [UIColor blackColor];
        [viewContent setBackgroundColor:[UIColor whiteColor]];
        [viewContent setContentSize:viewContent.frame.size];
        [mapView setHidden:NO];

    } else {
        viewMapBox.backgroundColor = [UIColor clearColor];
        [imgviewMapBtn setImage:[UIImage imageNamed:@"ic_map_white"]];
        lblMapBtn.textColor = [UIColor whiteColor];
        [mapView setHidden:YES];
    }
}

@end
