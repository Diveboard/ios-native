//
//  DiveEditViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MMProgressHUD.h"


@interface DiveEditViewController ()
{
    AppManager *appManager;
    int         diveLengthUnit;
    
    DiveInformation *diveInformation;
    NSMutableArray *spotSearchResultArray;
    SpotSearchResult *selectedSpot;
    
    
}
@end

@implementation DiveEditViewController

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
        nibFilename = @"DiveEditViewController";
    } else {
        nibFilename = @"DiveEditViewController-ipad";
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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    diveLengthUnit = [[ud objectForKey:kDiveboardUnit] intValue];
    
    [self initMethod];
    [self keyboardShowHideAnimationSetting];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setRelayout];
    [self tapButtonTouchAction:(btnDetails)];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    [self setRelayout];
    for (UIView *view in scrviewMain.subviews) {
        if (!view.isHidden) {
            CGSize size = view.frame.size;
            [scrviewMain setContentSize:size];
            break;
        }
    }
}

- (void) setRelayout
{
    [viewContent setFrame:CGRectMake(0, 0, scrviewMain.frame.size.width, viewContent.frame.size.height)];
    [viewNotes setFrame:scrviewMain.bounds];
    [viewSpots setFrame:scrviewMain.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMethod
{
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapAction:)];
    [lblDate addGestureRecognizer:dateTap];
    
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeLabelTapAction:)];
    [lblTime addGestureRecognizer:timeTap];

    UITapGestureRecognizer *visibilityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visibilityLabelTapAction:)];
    [lblVisibility addGestureRecognizer:visibilityTap];

    UITapGestureRecognizer *currentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentLabelTapAction:)];
    [lblCurrent addGestureRecognizer:currentTap];

    UITapGestureRecognizer *waterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waterLabelTapAction:)];
    [lblWater addGestureRecognizer:waterTap];
    
//    btnDetails.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnDetails.layer.borderWidth = 1.0f;
//    btnNotes.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnNotes.layer.borderWidth = 1.0f;
//    btnSpots.layer.borderColor = [UIColor whiteColor].CGColor;
//    btnSpots.layer.borderWidth = 1.0f;
    
    if (diveLengthUnit == 0) {
        [lblMaxdepthUnit setText:@"FEET"];
        [lblWeightUnit   setText:@"lbs"];
        [lblSurfaceUnit  setText:@"°F"];
        [lblBottomUnit   setText:@"°F"];
//        [lblAltitudeUnit setText:@"ft"];
    }
    
    [scrviewMain addSubview:viewSpots];
    [scrviewMain addSubview:viewNotes];
    [scrviewMain addSubview:viewContent];
    
    if (diveInformation) {
        [self diveDataShow];
    } else {
        [self newDiveShow];
    }
}

- (void) diveDataShow
{
    [lblDate        setText:diveInformation.date];
    [lblTime        setText:diveInformation.time];
    // dive max depth
    [txtDepth setText:[DiveInformation unitOfLengthWithValue:diveInformation.maxDepth
                                                 defaultUnit:diveInformation.maxDepthUnit
                                                    showUnit:NO]];

    [txtDuration    setText:diveInformation.duration];
    [txtWeight      setText:[DiveInformation unitOfWeightWithValue:diveInformation.weight.weight
                                                       defaultUnit:diveInformation.weight.unit
                                                          showUnit:NO]];
    [txtDiveNumber  setText:diveInformation.number];
    [txtTripName    setText:diveInformation.tripName];
    [lblVisibility  setText:[diveInformation.visibility capitalizedString]];
    [lblCurrent     setText:[diveInformation.current capitalizedString]];
    
    [txtSurface     setText:[DiveInformation unitOfTempWithValue:diveInformation.temp.surface
                                                     defaultUnit:diveInformation.temp.surfaceUnit
                                                        showUnit:NO]];
    [txtBottom      setText:[DiveInformation unitOfTempWithValue:diveInformation.temp.bottom
                                                     defaultUnit:diveInformation.temp.bottomUnit
                                                        showUnit:NO]];
    [txtAltitude    setText:diveInformation.altitude];
    [lblWater       setText:[diveInformation.water capitalizedString]];
    if ([diveInformation.privacy isEqualToString:@"0"]) {
        [schPublic setOn:YES];
    } else {
        [schPublic setOn:NO];
    }
    
    [txtviewNotes setText:diveInformation.note];
    
    //    btnSpotDelete.layer.cornerRadius = btnSpotDelete.frame.size.width / 2;
    [lblCurrentSpot setText:diveInformation.spotInfo.name];

}

- (void) newDiveShow
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    //Optionally for time zone converstions
    NSString *dateString = [formatter1 stringFromDate:today];
    
    [lblDate setText:[dateString substringToIndex:10]];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm"];
    //Optionally for time zone converstions
    NSString *timeString = [formatter2 stringFromDate:today];
    
    [lblTime setText:timeString];

}

- (IBAction)backAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil
                                                    message:@"Exit without save?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert setTag:400];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 400) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:Nil];
        }
    }
}

- (IBAction)saveAction:(id)sender {
    if (diveInformation) {
        [self saveDiveDetailData];
    } else {
        [self createDiveData];
    }
}

- (void) saveDiveDetailData
{
    // date
    NSMutableDictionary *updateParams = [[NSMutableDictionary alloc] init];
    if (![diveInformation.date          isEqualToString:lblDate.text])
        [updateParams setObject:[NSString stringWithFormat:@"%@T%@Z", lblDate.text, lblTime.text] forKey:@"time_in"];
    
    // time
    if (![diveInformation.time          isEqualToString:lblTime.text])
        [updateParams setObject:[NSString stringWithFormat:@"%@T%@Z", lblDate.text, lblTime.text] forKey:@"time_in"];
    
    // max depth
    NSString *maxdepth = [DiveInformation unitOfLengthWithValue:diveInformation.maxDepth
                                                    defaultUnit:diveInformation.maxDepthUnit
                                                       showUnit:NO];

    if (![maxdepth      isEqualToString:txtDepth.text]) {
        [updateParams setObject:[DiveInformation unitOfLengthWithValue:txtDepth.text
                                                           defaultUnit:(diveLengthUnit == 0 ? @"ft" : @"m")
                                                              showUnit:NO]
                         forKey:@"maxdepth"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"ft" : @"m") forKey:@"maxdepth_unit"];
    }
    
    // duration
    if (![diveInformation.duration      isEqualToString:txtDuration.text])
        [updateParams setObject:txtDuration.text forKey:@"duration"];
    
    // weight
    NSString *actualWeight = [DiveInformation unitOfWeightWithValue:diveInformation.weight.weight
                                                        defaultUnit:diveInformation.weight.unit
                                                           showUnit:NO];
    if (![actualWeight isEqualToString:txtWeight.text]) {
        [updateParams setObject:[DiveInformation unitOfWeightWithValue:txtWeight.text
                                                           defaultUnit:(diveLengthUnit == 0 ? @"lbs" : @"kg")
                                                              showUnit:NO]
                         forKey:@"weights"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"lbs" : @"kg") forKey:@"weights_unit"];
    }
    
    // dive number
    if (![diveInformation.number        isEqualToString:txtDiveNumber.text])
        [updateParams setObject:txtDiveNumber.text forKey:@"number"];
    
    // dive trip name
    if (![diveInformation.tripName      isEqualToString:txtTripName.text])
        [updateParams setObject:txtTripName.text forKey:@"trip_name"];
    
    // visibility
    if (![diveInformation.visibility    isEqualToString:lblVisibility.text])
        [updateParams setObject:[lblVisibility.text lowercaseString] forKey:@"visibility"];
    
    // current
    if (![diveInformation.current       isEqualToString:lblCurrent.text])
        [updateParams setObject:[lblCurrent.text lowercaseString] forKey:@"current"];
    
    // surface temporature
    NSString *tempSurface = [DiveInformation unitOfTempWithValue:diveInformation.temp.surface
                                                     defaultUnit:diveInformation.temp.surfaceUnit
                                                        showUnit:NO];
    if (![tempSurface  isEqualToString:txtSurface.text]) {
        [updateParams setObject:[DiveInformation unitOfTempWithValue:txtSurface.text
                                                         defaultUnit:(diveLengthUnit == 0 ? @"F" : @"C")
                                                            showUnit:NO]
                         forKey:@"temp_surface"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"F" : @"C") forKey:@"temp_surface_unit"];
    }
    
    // bottom temporature
    NSString *tempBottom = [DiveInformation unitOfTempWithValue:diveInformation.temp.bottom
                                                     defaultUnit:diveInformation.temp.bottomUnit
                                                        showUnit:NO];
    if (![tempBottom  isEqualToString:txtBottom.text]) {
        [updateParams setObject:[DiveInformation unitOfTempWithValue:txtBottom.text
                                                         defaultUnit:(diveLengthUnit == 0 ? @"F" : @"C")
                                                            showUnit:NO]
                         forKey:@"temp_bottom"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"F" : @"C") forKey:@"temp_bottom_unit"];
    }
    
    // altitude
    if (![diveInformation.altitude      isEqualToString:txtAltitude.text])
        [updateParams setObject:txtAltitude.text forKey:@"altitude"];
    
    // water
    if (![diveInformation.water         isEqualToString:lblWater.text])
        [updateParams setObject:[lblWater.text lowercaseString] forKey:@"water"];
    
    // public
    if ( [diveInformation.privacy boolValue] != !schPublic.isOn)
        [updateParams setObject:(schPublic.isOn ? @"0" : @"1") forKey:@"privacy"];
    
    // dive note
    if (![diveInformation.note   isEqualToString:txtviewNotes.text])
        [updateParams setObject:txtviewNotes.text forKey:@"notes"];
    
    // dive spot information
    if (![diveInformation.spotInfo.name isEqualToString:lblCurrentSpot.text]) {
        if (selectedSpot) {
            [updateParams setObject:@{@"id": selectedSpot.ID} forKey:@"spot"];
        }
    }
    
    if (updateParams.count > 0) {
        [updateParams setObject:diveInformation.ID forKey:@"id"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateParams
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
            
        } else {
            
            [MMProgressHUD setPresentationStyle:(MMProgressHUDPresentationStyleShrink)];
            [MMProgressHUD showWithTitle:@"Dive Information" status:@"Updating..."];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSDictionary *params = @{@"auth_token": appManager.loginResult.token,
                                     @"apikey" : API_KEY,
                                     @"arg" : jsonString,
                                     };
            
            
            
            NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/V2/dive", SERVER_URL];
            
            if ([DiveOfflineModeManager sharedManager].isOffline) {
                NSDictionary *dic = @{kRequestKey: requestURLStr,
                                      kRequestParamKey : params
                                      };
                [[DiveOfflineModeManager sharedManager] diveEdit:dic];
                
                [self updateDiveSuccess];
                
            }
            else {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:requestURLStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@", responseObject);
                    
                    [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:responseObject overwrite:YES];
                    
                    [self updateDiveSuccess];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error : %@", error);
                    
                    [MMProgressHUD dismissWithSuccess:@"Failure" title:@"Update"];
                    
                }];

            }

        }
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }

}

- (void) updateDiveInformation
{
    diveInformation.date = lblDate.text;
    diveInformation.time = lblTime.text;
    
    diveInformation.maxDepth = [DiveInformation unitOfLengthWithValue:txtDepth.text
                                                          defaultUnit:(diveLengthUnit == 0 ? @"ft" : @"m")
                                                             showUnit:NO];
    
    diveInformation.duration        = txtDuration.text;
    diveInformation.weight.weight   = txtWeight.text;
    diveInformation.weight.unit     = (diveLengthUnit == 0 ? @"lbs" : @"kg");
    diveInformation.number          = txtDiveNumber.text;
    diveInformation.tripName        = txtTripName.text;
    diveInformation.visibility      = lblVisibility.text;
    diveInformation.current         = lblCurrent.text;
    diveInformation.temp.surface    = txtSurface.text;
    diveInformation.temp.surfaceUnit = (diveLengthUnit == 0 ? @"F" : @"C");
    diveInformation.temp.bottom     = txtBottom.text;
    diveInformation.temp.bottomUnit = (diveLengthUnit == 0 ? @"F" : @"C");
    diveInformation.altitude        = txtAltitude.text;
    diveInformation.water           = lblWater.text;
    diveInformation.privacy         = (schPublic.isOn ? @"0" : @"1");
    diveInformation.note            = txtviewNotes.text;
    if (selectedSpot) {
        diveInformation.spotInfo = selectedSpot.spotInfo;
    }
}

- (void) updateDiveSuccess
{
    [self updateDiveInformation];
    [MMProgressHUD dismissWithSuccess:@"Saved!" title:@"Success"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(diveEditFinish:)]) {
        [self.delegate diveEditFinish:diveInformation];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void) createDiveData
{
    NSMutableDictionary *updateParams = [[NSMutableDictionary alloc] init];
    
    [updateParams setObject:[NSString stringWithFormat:@"%@T%@Z", lblDate.text, lblTime.text] forKey:@"time_in"];
    
        
    // max depth
    if (txtDepth.text.length > 0) {
        [updateParams setObject:[DiveInformation unitOfLengthWithValue:txtDepth.text
                                                           defaultUnit:(diveLengthUnit == 0 ? @"ft" : @"m")
                                                              showUnit:NO]
                         forKey:@"maxdepth"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"ft" : @"m") forKey:@"maxdepth_unit"];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Max Depth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    // duration
    if (txtDuration.text.length > 0)
        [updateParams setObject:txtDuration.text forKey:@"duration"];
    else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Duration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    // weight
    if (txtWeight.text.length > 0)
    {
        [updateParams setObject:[DiveInformation unitOfWeightWithValue:txtWeight.text
                                                           defaultUnit:(diveLengthUnit == 0 ? @"lbs" : @"kg")
                                                              showUnit:NO]
                         forKey:@"weights"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"lbs" : @"kg") forKey:@"weights_unit"];
    }
    
    // dive number
    if (txtDiveNumber.text.length > 0)
        [updateParams setObject:txtDiveNumber.text forKey:@"number"];
    
    // dive trip name
    if (txtTripName.text.length > 0)
        [updateParams setObject:txtTripName.text forKey:@"trip_name"];
    
    // visibility
    if (lblVisibility.text.length > 0)
        [updateParams setObject:[lblVisibility.text lowercaseString] forKey:@"visibility"];
    
    // current
    if (lblCurrent.text.length > 0)
        [updateParams setObject:[lblCurrent.text    lowercaseString] forKey:@"current"];

    
    // surface temporature
    if (txtSurface.text.length > 0) {
        [updateParams setObject:[DiveInformation unitOfTempWithValue:txtSurface.text
                                                         defaultUnit:(diveLengthUnit == 0 ? @"F" : @"C")
                                                            showUnit:NO]
                         forKey:@"temp_surface"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"F" : @"C") forKey:@"temp_surface_unit"];
    }
    
    // bottom temporature
    if (txtBottom.text.length > 0) {
        [updateParams setObject:[DiveInformation unitOfTempWithValue:txtBottom.text
                                                         defaultUnit:(diveLengthUnit == 0 ? @"F" : @"C")
                                                            showUnit:NO]
                         forKey:@"temp_bottom"];
        [updateParams setObject:(diveLengthUnit == 0 ? @"F" : @"C") forKey:@"temp_bottom_unit"];
    }
    
    // altitude
    if (txtAltitude.text.length > 0)
        [updateParams setObject:txtAltitude.text forKey:@"altitude"];
    
    // water
    if (lblWater.text.length > 0)
        [updateParams setObject:[lblWater.text lowercaseString] forKey:@"water"];
    
    // public
    [updateParams setObject:(schPublic.isOn ? @"1" : @"0") forKey:@"privacy"];
    
    // dive note
    if (txtviewNotes.text.length > 0)
        [updateParams setObject:txtviewNotes.text forKey:@"notes"];
    
    // dive spot information
    if (selectedSpot) {
        [updateParams setObject:@{@"id": selectedSpot.ID} forKey:@"spot"];
    }

    
    if (updateParams.count > 0) {
        [updateParams setObject:appManager.loginResult.user.ID forKey:@"user_id"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateParams
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
            
        } else {
            
            [MMProgressHUD setPresentationStyle:(MMProgressHUDPresentationStyleShrink)];
            [MMProgressHUD showWithTitle:@"New Dive" status:@"Saving..."];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSDictionary *params = @{@"auth_token": appManager.loginResult.token,
                                     @"apikey" : API_KEY,
                                     @"arg" : jsonString,
                                     };
            
            
            
            NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/V2/dive", SERVER_URL];
            
            if ([DiveOfflineModeManager sharedManager].isOffline) {
                NSDictionary *dic = @{kRequestKey: requestURLStr,
                                      kRequestParamKey : params
                                      };
                [[DiveOfflineModeManager sharedManager] diveEdit:dic];
                
                NSDictionary *responseObject = [self createVirtualServerResult];
//                DiveInformation *diveInfo = [[DiveInformation alloc] initWithDictionary:[responseObject objectForKey:@"result"]];
                
                [[DiveOfflineModeManager sharedManager] createNewDive:responseObject];
                
                
                [self createDiveSuccess:responseObject];
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];


//                DiveInformation *diveInfo = [[DiveInformation alloc] init];
//                diveInfo.ID   = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
//                diveInfo.date = lblDate.text;
//                diveInfo.time = lblTime.text;
//                diveInfo.maxDepth = txtDepth.text;
//                diveInfo.duration = txtDuration.text;
//                diveInfo.weight.weight = txtWeight.text;
//                diveInfo.number        = txtDiveNumber.text;
//                diveInfo.tripName      = txtTripName.text;
//                diveInfo.visibility    = lblVisibility.text;
//                diveInfo.current       = lblCurrent.text;
//                diveInfo.temp.surface  = txtSurface.text;
//                diveInfo.temp.bottom   = txtBottom.text;
//                diveInfo.altitude      = txtAltitude.text;
//                diveInfo.note          = txtviewNotes.text;
//                diveInfo.water         = lblWater.text;
//                diveInfo.privacy       = (schPublic.isOn ? @"1" : @"0");
//                
                
            }
            else {
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                [manager POST:requestURLStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@", responseObject);
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject objectForKey:@"success"] boolValue]) {
                            
                            [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:responseObject overwrite:YES];

                            [self createDiveSuccess:responseObject];
                            
                        }
                    } else {
                        [MMProgressHUD dismissWithSuccess:@"Failure" title:@"Create New Dive"];
                    }
                    
    //                [self updateDiveInformation];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error : %@", error);
                    
                    [DiveOfflineModeManager sharedManager].isOffline = YES;
                    
                    NSDictionary *dic = @{kRequestKey: requestURLStr,
                                          kRequestParamKey : params
                                          };
                    [[DiveOfflineModeManager sharedManager] diveEdit:dic];
                    
                    NSDictionary *responseObject = [self createVirtualServerResult];
                    [[DiveOfflineModeManager sharedManager] createNewDive:responseObject];
                    
                    [self createDiveSuccess:responseObject];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];

                    
//                    	[MMProgressHUD dismissWithSuccess:@"Failure" title:@"Create New Dive"];
                    
                }];
            }
        }
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }

}

- (void) createDiveSuccess :(NSDictionary *)responseObject
{

    NSDictionary *diveData = [responseObject objectForKey:@"result"];
    NSString *diveID = getStringValue([diveData objectForKey:@"id"]);
    [appManager.loadedDives setObject:responseObject forKey:diveID];
    
    DiveInformation *diveInfo = [[DiveInformation alloc] initWithDictionary:[responseObject objectForKey:@"result"]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(diveEditFinish:)]) {
        [self.delegate diveEditFinish:diveInfo];
    }
    [MMProgressHUD dismissWithSuccess:@"Saved!" title:@"Success"];

}

- (NSDictionary *) createVirtualServerResult
{
    NSDictionary *result = @{@"error"  : [NSArray array],
                             @"result" : @{@"altitude"      : txtAltitude.text,
                                           @"current"       : lblCurrent.text,
                                           @"date"          : lblDate.text,
                                           @"diveshop"      : [NSNull null],
                                           @"divetype"      : [NSArray array],
                                           @"duration"      : txtDuration.text,
                                           @"id"            : [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]],
                                           @"lat"           : @"0",
                                           @"lng"           : @"0",
                                           @"maxdepth"      : txtDepth.text,
                                           @"maxdepth_unit" : (diveLengthUnit == 0 ? @"ft" : @"m"),
                                           @"maxdepth_value" : txtDepth.text,
                                           @"notes"         : txtviewNotes.text,
                                           @"privacy"       : (schPublic.isOn ? @"1" : @"0"),
                                           @"shaken_id"     : appManager.loginResult.user.shakenID,
                                           @"shop"          : [NSNull null],
                                           @"shop_id"       : [NSNull null],
                                           @"spot_id"       : @"1",
                                           @"temp_bottom"   : txtBottom.text,
                                           @"temp_bottom_unit" : (diveLengthUnit == 0 ? @"F" : @"C"),
                                           @"temp_bottom_value"     : txtBottom.text,
                                           @"temp_surface"  : txtSurface.text,
                                           @"temp_surface_value"    : txtSurface.text,
                                           @"temp_surface_unit"     : (diveLengthUnit == 0 ? @"F" : @"C"),
                                           @"thumbnail_image_url"   : @"http://stage.diveboard.com/map_images/map_1.jpg?v=1394539383",
                                           @"thumbnail_profile_url" : [NSNull null],
                                           @"time"          : lblTime.text,
                                           @"trip_name"     : txtTripName.text,
                                           @"user_id"       : appManager.loginResult.user.ID,
                                           @"visibility"    : lblVisibility.text,
                                           @"water"         : lblWater.text,
                                           @"weights"       : txtWeight.text,
                                           @"weights_unit"  : (diveLengthUnit == 0 ? @"lbs" : @"kg"),
                                           @"weights_value" : txtWeight.text,
                                           },
                             @"success" : @"1",
                             @"user_authentified" : @"1",
                             };
    return result;
}

- (IBAction)tapButtonAction:(id)sender {
    [self tapButtonTouchAction:sender];
}

- (IBAction)noteDoneAction:(id)sender {
    [txtviewNotes resignFirstResponder];
}

- (IBAction)diveEditDoneAction:(id)sender {
    [self keyboardHide];
}

- (IBAction)spotDeleteAction:(id)sender {
    [lblCurrentSpot setText:@""];
}

- (void) dateLabelTapAction:(UITapGestureRecognizer*)sender
{
    CGRect rect = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 200);
    TKDatePickerView *dateView = [[TKDatePickerView alloc] initWithFrame:rect pickerMode:(UIDatePickerModeDate)];
    [dateView setDelegate:self];
    [self.view addSubview:dateView];
    [dateView show];
}

- (void) timeLabelTapAction:(UITapGestureRecognizer*)sender
{
    CGRect rect = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 200);
    TKDatePickerView *dateView = [[TKDatePickerView alloc] initWithFrame:rect pickerMode:(UIDatePickerModeTime)];
    [dateView setDelegate:self];
    [self.view addSubview:dateView];
    [dateView show];

}

- (void) visibilityLabelTapAction:(UITapGestureRecognizer*)sender
{
    TKListPickerView *listView = [[TKListPickerView alloc] initWithTarget:self.view
                                                                    title:@"Visibility"
                                                                     list:@[@"None",
                                                                            @"Bad (under 5m / 15ft)",
                                                                            @"Average (5-10m / 15-30ft)",
                                                                            @"Good (10-25m / 40-75ft)",
                                                                            @"Excellent (over 25m / 75ft)"]
                                                                   sender:lblVisibility];
    [listView setDelegate:self];
    [listView show];
    [self keyboardHide];
}

- (void) currentLabelTapAction:(UITapGestureRecognizer*)sender
{
    TKListPickerView *listView = [[TKListPickerView alloc] initWithTarget:self.view
                                                                    title:@"Current"
                                                                     list:@[@"None",
                                                                            @"Light (up to 1 knot)",
                                                                            @"Medium (up to 2 knots)",
                                                                            @"Strong (up to 3 knots)",
                                                                            @"Extreme (over 3 knots)"]
                                                                   sender:lblCurrent];
    [listView setDelegate:self];
    [listView show];
    [self keyboardHide];
}

- (void) waterLabelTapAction:(UITapGestureRecognizer*)sender
{
    TKListPickerView *listView = [[TKListPickerView alloc] initWithTarget:self.view
                                                                    title:@"Water"
                                                                     list:@[@"Salt",
                                                                            @"Fresh",
                                                                            ]
                                                                   sender:lblWater];
    [listView setDelegate:self];
    [listView show];
    [self keyboardHide];
}

- (void) keyboardHide
{
    [txtAltitude     resignFirstResponder];
    [txtBottom       resignFirstResponder];
    [txtDepth        resignFirstResponder];
    [txtDiveNumber   resignFirstResponder];
    [txtDuration     resignFirstResponder];
    [txtSearchSpot   resignFirstResponder];
    [txtSurface      resignFirstResponder];
    [txtTripName     resignFirstResponder];
    [txtviewNotes    resignFirstResponder];
    [txtWeight       resignFirstResponder];
    TKDatePickerView *dateView = [[TKDatePickerView alloc] initWithFrame:CGRectZero pickerMode:(UIDatePickerModeTime)];
    [dateView hide];
}

#pragma mark - TKDatePickerView delegate

- (void)datePickerViewDoneAction:(TKDatePickerView *)view date:(NSDate *)date
{
    
    if (view.dataMode == UIDatePickerModeDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //Optionally for time zone converstions
        NSString *dateString = [formatter stringFromDate:date];

        [lblDate setText:[dateString substringToIndex:10]];
    } else if (view.dataMode == UIDatePickerModeTime) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        //Optionally for time zone converstions
        NSString *timeString = [formatter stringFromDate:date];

        [lblTime setText:timeString];
    }

    //    NSString *dateString = [NSString stringWithFormat:@"%@", date];

}

- (void)datePickerViewHide:(TKDatePickerView *)view
{
    [view removeFromSuperview];
}

- (void)datePickerViewShow:(TKDatePickerView *)view
{
    [txtAltitude    resignFirstResponder];
    [txtBottom      resignFirstResponder];
    [txtDepth       resignFirstResponder];
    [txtDiveNumber  resignFirstResponder];
    [txtDuration    resignFirstResponder];
    [txtSurface     resignFirstResponder];
    [txtTripName    resignFirstResponder];
    [txtWeight      resignFirstResponder];

}

#pragma mark - TKListPickerView delegate

- (void)listPickerView:(TKListPickerView *)view selectedString:(NSString *)string index:(int)index targetLabel:(UILabel *)label
{
    if (index == 0) {
        [label setText:@""];
    } else {
        [label setText:string];
    }
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtSearchSpot) {
        if (textField.text.length > 2) {
            [textField resignFirstResponder];
            [self searchSpot];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter 2+ characters." delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles: nil] show];
        }
    } else {
        int tag = textField.tag + 1;
        id nextTextField = [viewContent viewWithTag:tag];
        if ([nextTextField isKindOfClass:[UITextField class]]) {
            [nextTextField becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

#pragma mark - Search Spot

- (void) searchSpot
{
    [self internetConnecting:YES];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/search/spot", SERVER_URL];
    NSDictionary *params = @{@"q": txtSearchSpot.text,
                             @"apikey" : API_KEY,
                             @"auth_token" : appManager.loginResult.token,
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        NSLog(@"%@", data);
        [self filterSearchResult:data];
        [self internetConnecting:NO];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self internetConnecting:NO];
    }];
}

- (void) filterSearchResult:(NSDictionary *)data
{
    if (!spotSearchResultArray) {
        spotSearchResultArray = [[NSMutableArray alloc] init];
    }
    [spotSearchResultArray removeAllObjects];
    
    if ([[data objectForKey:@"success"] boolValue]) {
        NSArray *results = [data objectForKey:@"data"];
        for (NSDictionary *elem in results) {
            SpotSearchResult *result = [[SpotSearchResult alloc] initWithDictionary:elem];
            [spotSearchResultArray addObject:result];
        }
    }
    if (spotSearchResultArray.count == 0) {
        [lblNoResult setHidden:NO];
    } else {
        [lblNoResult setHidden:YES];
    }
    [tblSpotList reloadData];
}

#pragma mark - UITableView Datasource & delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
        [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontNameBold size:13.0f]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
    }
    SpotSearchResult *result = [spotSearchResultArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:result.spotInfo.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@, %@", result.spotInfo.locationName, result.spotInfo.countryName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index");
    selectedSpot = [spotSearchResultArray objectAtIndex:indexPath.row];
    [lblCurrentSpot setText:selectedSpot.name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return spotSearchResultArray.count;
}




#pragma mark - TapButton Actions

- (void) tapButtonTouchAction:(UIButton *)sender
{
    if (sender == btnDetails) {
        [btnDetails setBackgroundColor:kMainDefaultColor];
        [scrviewMain setContentSize:viewContent.frame.size];
        [scrviewMain setContentOffset:CGPointMake(0, 0)];
        [viewContent setHidden:NO];
        [lblTitle setText:@"DIVE DETAILS"];
    } else {
        [btnDetails setBackgroundColor:[UIColor clearColor]];
        [viewContent setHidden:YES];
    }
    
    if (sender == btnNotes) {
        [btnNotes setBackgroundColor:kMainDefaultColor];
        [scrviewMain setContentSize:viewNotes.frame.size];
        [scrviewMain setContentOffset:CGPointMake(0, 0)];
        [viewNotes setHidden:NO];
        [lblTitle setText:@"DIVE NOTES"];
    } else {
        [btnNotes setBackgroundColor:[UIColor clearColor]];
        [viewNotes setHidden:YES];
    }

    if (sender == btnSpots) {
        [btnSpots setBackgroundColor:kMainDefaultColor];
        [scrviewMain setContentSize:viewSpots.frame.size];
        [scrviewMain setContentOffset:CGPointMake(0, 0)];
        [viewSpots setHidden:NO];
        [lblTitle setText:@"SPOTS"];
    } else {
        [btnSpots setBackgroundColor:[UIColor clearColor]];
        [viewSpots setHidden:YES];
    }

}

#pragma mark - 

- (void) internetConnecting:(BOOL)flag
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = flag;
    if (flag) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Searching...";
        hud.labelFont = [UIFont fontWithName:kDefaultFontName size:14.0f];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - Notification ;

- (void) keyboardShowHideAnimationSetting
{
    NSNotificationCenter*   notificationCenter  = [ NSNotificationCenter defaultCenter ] ;
    
    [ notificationCenter addObserver : self
                            selector : @selector( didShowKeyBoard: )
                                name : UIKeyboardDidShowNotification
                              object : nil ] ;
    
    [ notificationCenter addObserver : self
                            selector : @selector( willHideKeyBoard: )
                                name : UIKeyboardWillHideNotification
                              object : nil ] ;
    
}

- ( void ) didShowKeyBoard : ( NSNotification* ) _notification
{
    CGRect rectForKeyBoard  = [ [ _notification.userInfo valueForKey : UIKeyboardFrameEndUserInfoKey ] CGRectValue ] ;
    float dty;
    if (isPortrateScreen)
        dty = rectForKeyBoard.size.height - CGRectGetHeight(viewButtonBox.frame);
    else
        dty = rectForKeyBoard.size.width - CGRectGetHeight(viewButtonBox.frame);

    if (!viewContent.isHidden) {
        TKDatePickerView *dateView = [[TKDatePickerView alloc] initWithFrame:CGRectZero pickerMode:(UIDatePickerModeTime)];
        [dateView hide];
        CGRect rect = CGRectMake(0, scrviewMain.frame.origin.y, CGRectGetWidth(scrviewMain.frame), CGRectGetHeight(scrviewMain.frame) - dty);
        [scrviewMain setFrame:rect];
        CGRect btnRect = CGRectMake(self.view.frame.size.width - btnDiveEditCloseKeyboard.frame.size.width,
                                    CGRectGetMaxY(rect) - CGRectGetHeight(btnDiveEditCloseKeyboard.frame),
                                    CGRectGetWidth(btnDiveEditCloseKeyboard.frame),
                                    CGRectGetHeight(btnDiveEditCloseKeyboard.frame));
        [btnDiveEditCloseKeyboard setFrame:btnRect];
        [btnDiveEditCloseKeyboard setHidden:NO];

    } else if (!viewNotes.isHidden) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(scrviewMain.frame), CGRectGetHeight(scrviewMain.frame) - dty);// - CGRectGetHeight(btnNoteDone.frame));
        [viewNotes setFrame:rect];
        CGRect btnRect = btnNoteDone.frame;
        btnRect.origin = CGPointMake(CGRectGetWidth(viewNotes.frame) - CGRectGetWidth(btnNoteDone.frame), CGRectGetHeight(viewNotes.frame) - CGRectGetHeight(btnNoteDone.frame));
        [btnNoteDone setFrame:btnRect];
        [btnNoteDone setHidden:NO];
    }
}

- ( void ) willHideKeyBoard : ( NSNotification* ) _notification
{
    if (!viewContent.isHidden) {
        CGRect rect = CGRectMake(0, CGRectGetMinY(scrviewMain.frame), CGRectGetWidth(scrviewMain.frame), CGRectGetMinY(viewButtonBox.frame) - CGRectGetMinY(scrviewMain.frame));
        [scrviewMain setFrame:rect];
        [btnDiveEditCloseKeyboard setHidden:YES];
    } else if (!viewNotes.isHidden) {
        [viewNotes setFrame:scrviewMain.bounds];
        [btnNoteDone setHidden:YES];
        
    }

}


@end

