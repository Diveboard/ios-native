//
//  DiveEditViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DrawerMenuViewController.h"
#import "DiveEditDetailViewController.h"
#import "DiveEditSpotViewController.h"
#import "DiveEditShopViewController.h"
#import "DiveEditBuddiesViewController.h"
#import "DiveEditPhotosViewController.h"
#import "DiveEditNotesViewController.h"
#import "DivePicturesViewController.h"
#import "DiveListViewController.h"
@interface DiveEditViewController ()<DiveEditPhotosViewDelegate>
{
    
    DiveInformation *diveInformation;
    DiveInformation* oldDiveInfo;
    NSArray* m_viewTitleArr;
    BOOL m_isEdit;
    
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
        if (diveInfo) {
            m_isEdit = YES;
            diveInformation = diveInfo;
            oldDiveInfo = [[DiveInformation alloc] initWithDictionary:[diveInfo getDataDictionary]];
        }else{
            m_isEdit = NO;
            diveInformation = [[DiveInformation alloc] initWithDictionary:[NSDictionary dictionary]];
            diveInformation.spotInfo = [[DiveSpotInfo alloc] initWithEmptySpot];
            diveInformation.isLocal = YES;
            diveInformation.localID = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    m_viewTitleArr = @[@"DIVE DETAILS",@"SPOT",@"SHOP",@"BUDDIES",@"PHOTOS",@"NOTE"];
    
    //// Dive Detail ///
    DiveEditDetailViewController *detailController = [[DiveEditDetailViewController alloc] initWithDiveData:diveInformation];
    [detailController setTitle:m_viewTitleArr[0]];
    
    
    /// Spots //
    DiveEditSpotViewController* spotsController = [[DiveEditSpotViewController alloc] initWithDiveData:diveInformation];
    [spotsController setTitle:m_viewTitleArr[1]];
    
    // Shop ////
    DiveEditShopViewController* shopController = [[DiveEditShopViewController alloc] initWithDiveData:diveInformation];
    [shopController setTitle:m_viewTitleArr[2]];

    //  Buddies //
    DiveEditBuddiesViewController* buddiesController = [[DiveEditBuddiesViewController alloc] initWithDiveData:diveInformation];
    [buddiesController setTitle:m_viewTitleArr[3]];
    
    // Photos
    DiveEditPhotosViewController* photosController = [[DiveEditPhotosViewController alloc] initWithDiveData:diveInformation];
    photosController.delegate = self;
    [photosController setTitle:m_viewTitleArr[4]];
    
    // Note ////
    DiveEditNotesViewController* noteController = [[DiveEditNotesViewController alloc] initWithDiveData:diveInformation];
    [noteController setTitle:m_viewTitleArr[5]];
    
    [self setControllers:@[detailController,spotsController,shopController,buddiesController,photosController,noteController]];
    
    self.delegate = self;
    
    if (m_isEdit) {
        [m_btnBack setHidden:NO];
        [m_btnDrawer setHidden:YES];
    }else{
        [m_btnBack setHidden:YES];
        [m_btnDrawer setHidden:NO];
        
    }
    
    // Do any additional setup after loading the view from its nib.


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onDrawer:(id)sender{
    
    [[DrawerMenuViewController sharedMenu] toggleDrawerMenu];
    
}

-(void)onBack:(id)sender{
    
    
    if ([DrawerMenuViewController sharedMenu].isEditedDive) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"EXIT" message:@"Exit without save?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert setTag:100];
        [alert show];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}
-(void)onSave:(id)sender{
    
    if (m_isEdit) {
        
        [self saveDiveData];
        
    }else{
        
        [self saveDiveData];

        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            
            if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(diveEditFinish:)]) {
                
                [self.editDelegate diveEditFinish:oldDiveInfo];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [DrawerMenuViewController sharedMenu].isEditedDive = NO;
        }
        
    }
    
}

-(void)saveDiveData
{
 

    if (![self checkIsValid]) {
        return;
    }
    
    NSMutableDictionary* updateParams = [NSMutableDictionary dictionaryWithDictionary:[diveInformation getDataDictionary]];
    
    if (![diveInformation.spotInfo.ID isEqualToString:@""]) {
        
        [updateParams setObject:@{@"id":diveInformation.spotInfo.ID} forKey:@"spot"];
        
    }else if (![diveInformation.spotInfo.name isEqualToString:@""]){
        
        NSMutableDictionary* spot = [updateParams objectForKey:@"spot"];
        [spot setObject:@{@"id":diveInformation.spotInfo.regionID} forKey:@"region"];
        [spot setObject:@{@"id":diveInformation.spotInfo.locationID} forKey:@"location"];
        [updateParams setObject:spot forKey:@"spot"];
        
    }
        
    
    if(![diveInformation.diveShop.ID isEqualToString:@""])
    {
        
        [updateParams setObject:@{@"id":diveInformation.diveShop.ID} forKey:@"shop"];
        
    }
    NSLog(@"%@",updateParams);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateParams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
        
        if (! jsonData) {
            
        } else {
            
            NSString* pStrStatus = @"Creating...";
            
            if (m_isEdit) {
                pStrStatus = @"Updating...";
            }
            [SVProgressHUD showWithStatus:pStrStatus maskType:SVProgressHUDMaskTypeClear];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSDictionary *params = @{@"auth_token": [AppManager sharedManager].loginResult.token,
                                     @"apikey" : API_KEY,
                                     @"flavour"   : FLAVOUR,
                                     @"arg" : jsonString,
                                     };
            
            
            
            NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/V2/dive", SERVER_URL];
            
            if ([DiveOfflineModeManager sharedManager].isOffline) {
                NSDictionary *dic = @{kRequestKey: requestURLStr,
                                      kRequestParamKey : params
                                      
                                      };
                [[DiveOfflineModeManager sharedManager] diveEdit:dic :diveInformation.isLocal :diveInformation.ID];

                if (m_isEdit) {
                    
                    NSDictionary *responseObject = [self createVirtualServerResult];
                    [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:responseObject overwrite:YES];
                    [[AppManager sharedManager].loadedDives setObject:responseObject forKey:[NSNumber numberWithLong:[diveInformation.ID integerValue]]];
                    [self saveDiveSuccess];
                    
                    
                }else{
                    NSDictionary *responseObject = [self createVirtualServerResult];
                    
                    [self createDiveSuccess:responseObject];
                    
                }
                
            }
            else {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

                [manager POST:requestURLStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"%@",responseObject);
                    
                    BOOL success = [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:responseObject overwrite:YES];
                    if (success) {
                        
                        if (m_isEdit) {
                            
                            [[AppManager sharedManager].loadedDives setObject:responseObject forKey:[NSNumber numberWithLong:[diveInformation.ID integerValue]]];
                            [self saveDiveSuccess];
                            
                        }else{
                            
                            [self createDiveSuccess:responseObject];
                            
                        }
                        
                    } else {
                        
                        
                        [[DiveOfflineModeManager sharedManager] deleteDiveID:diveInformation.ID];
                        
                        for (id diveID in [AppManager sharedManager].loginResult.user.allDiveIDs) {
                            NSString *diveIDStr = [NSString stringWithFormat:@"%@", diveID];
                            if ([diveInformation.ID isEqualToString:diveIDStr]) {
                                [[AppManager sharedManager].loginResult.user.allDiveIDs removeObject:diveID];
                                
                                break;
                            }
                        }
                        
                        [SVProgressHUD dismiss];

                        [DrawerMenuViewController sharedMenu].isEditedDive = NO;
                        [[AppManager sharedManager].diveListVC diveViewsUpdate];
                        [self.navigationController setViewControllers:@[[AppManager sharedManager].diveListVC]];

                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [[DiveOfflineModeManager sharedManager] setIsOffline:YES];
                    [self saveDiveData];

                    
                }];
                
            }
            
        }
    
}


- (void) saveDiveSuccess
{
    
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
    
    
    if (![AppManager sharedManager].diveListVC) {
     
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
        } else {
            [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
        }
    }
    
    [[AppManager sharedManager].diveListVC currentDiveViewUpdate];
    [DrawerMenuViewController sharedMenu].isEditedDive = NO;
    [self.navigationController setViewControllers:@[[AppManager sharedManager].diveListVC]];
    
}
- (void) createDiveSuccess :(NSDictionary *)responseObject
{
    
    NSLog(@"%@",responseObject);
    NSDictionary *diveData = [responseObject objectForKey:@"result"];
    
    
    if (![diveData isEqual:[NSNull null]]) {
        
        [[DiveOfflineModeManager sharedManager] createNewDive:responseObject];
        
        NSString *diveID = getStringValue([diveData objectForKey:@"id"]);
        [[AppManager sharedManager].loadedDives setObject:responseObject forKey:[NSNumber numberWithLong:[diveID integerValue]]];
        
        
        [[AppManager sharedManager].loginResult.user.allDiveIDs addObject:[NSNumber numberWithLong:[diveID integerValue]]];
        
        [SVProgressHUD showSuccessWithStatus:@"Success!"];
        
        if (![AppManager sharedManager].diveListVC) {

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController" bundle:Nil];
            } else {
                [AppManager sharedManager].diveListVC = [[DiveListViewController alloc] initWithNibName:@"DiveListViewController-ipad" bundle:Nil];
            }
        
        }
        [[AppManager sharedManager].diveListVC diveViewsUpdate];
        [DrawerMenuViewController sharedMenu].isEditedDive = NO;
        [[DrawerMenuViewController sharedMenu] setMenuIndex:0];
        [self.navigationController setViewControllers:@[[AppManager sharedManager].diveListVC]];
    }
}

- (NSDictionary *) createVirtualServerResult
{

    if (!m_isEdit) {
        
        diveInformation.ID = diveInformation.localID;
        diveInformation.shakenID = [AppManager sharedManager].loginResult.user.shakenID;
    }
    if (diveInformation.divePictures.count > 0 ) {
        
        DivePicture* firstPic = [diveInformation.divePictures firstObject];
        diveInformation.imageURL = firstPic.thumbnail;
        
    }
    
    NSDictionary *result = @{@"error"  : [NSArray array],
                             @"result" : [diveInformation getDataDictionary],
                             @"success" : @"1",
                             @"user_authentified" : @"1",
                             };
    
    NSLog(@"%@",result);
    
    return result;
}



-(void)didSelectedPhotoCell:(int)index{
    
    DivePicturesViewController *viewController = [[DivePicturesViewController alloc] initWithPicturesData:diveInformation.divePictures];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:^{
        [viewController showPictureWithIndex:index];
    }];
    
}


- (BOOL) checkIsValid
{
    
    // MaxDepth
    if (!([diveInformation.maxDepth doubleValue] > 0)) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Max Depth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
        
    }
    // Duration
    if ([diveInformation.duration doubleValue] < 1)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Duration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    
    // Safety Stops
    
   float max_depth = [[DiveInformation unitOfLengthWithValue:diveInformation.maxDepth defaultUnit:diveInformation.maxDepthUnit showUnit:NO] floatValue];
    BOOL flag = NO;
    double totalDuration = 0;
    for (SafetyStop* safetyStop in diveInformation.SafetyStops) {
        
        float depth = [[DiveInformation unitOfLengthWithValue:safetyStop.depth defaultUnit:safetyStop.depthUnit showUnit:NO] floatValue];
        
        if (max_depth < depth) {
            
            flag = YES;
        }
        
        totalDuration +=[safetyStop.duration doubleValue];
        
        
    }
    
    if (flag || totalDuration > [diveInformation.duration doubleValue]) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter correct values of Safety Stops." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    
    }
    
    return YES;
    
}

@end

