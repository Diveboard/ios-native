//
//  WalletViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 10/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "WalletViewController.h"
#import "DrawerMenuViewController.h"
#import "DiveEditPhotoCell.h"
#import "KLCPopup.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DivePicturesViewController.h"
@interface WalletViewController () <DiveEditPhotoCellDelegate>
{
    NSMutableArray* m_walletPictures;
    NSMutableArray* m_walletPictureIDs;
    KLCPopup* m_KLCPopup;
    CGPoint m_longPressLocation;
    CALayer *actionLayer;
    UIImage* m_selectedWallet;
}

@end

@implementation WalletViewController

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
    
    [m_collectionViewPhoto registerNib:[UINib nibWithNibName:@"DiveEditPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    
    m_walletPictures = [[NSMutableArray alloc] initWithArray:[AppManager sharedManager].loginResult.user.walletPictures];
    
    m_walletPictureIDs = [[NSMutableArray alloc] initWithArray:[AppManager sharedManager].loginResult.user.walletPictureIDs];

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

-(DiveEditPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiveEditPhotoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];

    cell.delegate = self;

    if (indexPath.row == m_walletPictures.count) {
        
        [cell setAddButton:indexPath];
        
    }else{
        
        DivePicture* divePicture =(DivePicture*)[m_walletPictures objectAtIndex:indexPath.row];
        [cell setDivePicture:indexPath:divePicture];
        
    }
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DivePicturesViewController *viewController = [[DivePicturesViewController alloc] initWithPicturesData:m_walletPictures];
    //    viewController.startIndex = index;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:^{
        [viewController showPictureWithIndex:indexPath.row];
    }];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return m_walletPictures.count+1;
    
}

-(void)didClickedAddPhotoButton:(NSIndexPath *)indexPath
{
    
    
    [self showPopupView:m_viewAddPhoto];
    
}

- (void)onSelectPictureFromGallery:(id)sender{
    
    [m_KLCPopup dismiss:YES];
    
    UIImagePickerController *imagepickerController = [[UIImagePickerController alloc] init];
    
    [imagepickerController setDelegate:self];
    [imagepickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    
    [self presentViewController:imagepickerController animated:YES completion:nil];
    
    
    
}

- (void)onTakePicture:(id)sender{
    
    [m_KLCPopup dismiss:YES];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagepickerController = [[UIImagePickerController alloc] init];
        
        
        [imagepickerController setDelegate:self];
        [imagepickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [self presentViewController:imagepickerController animated:YES completion:nil];
    }
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadPhoto:image];
    }];
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) showPopupView:(UIView*)view{
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    
    m_KLCPopup = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [m_KLCPopup showWithLayout:layout];
    
}
-(void)uploadPhoto:(UIImage*)image{
    
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    
    NSDictionary *params = @{@"auth_token": [AppManager sharedManager].loginResult.token,
                             @"apikey" : API_KEY,
                             };
    
    
    
    NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/picture/upload", SERVER_URL];
    
    [SVProgressHUD showWithStatus:@"Uploading..." maskType:SVProgressHUDMaskTypeBlack];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:requestURLStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFormData:[[AppManager sharedManager].loginResult.token dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"auth_token"];
        [formData appendPartWithFormData:[API_KEY dataUsingEncoding:NSUTF8StringEncoding]  name:@"apikey"];
        
        [formData appendPartWithFileData:imageData name:@"qqfile" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            
            
            if ([[data objectForKey:@"success"] boolValue]) {
                
                NSDictionary *picData = [data objectForKey:@"picture"];
                
                NSMutableDictionary* resultData = [NSMutableDictionary dictionaryWithDictionary: [data objectForKey:@"result"]];
                
                DivePicture* picture = [[DivePicture alloc] initWithDictionary:resultData];
                [m_walletPictures addObject:picture];
                [m_walletPictureIDs addObject:[picData objectForKey:@"id"]];
                [m_collectionViewPhoto reloadData];
                [DrawerMenuViewController sharedMenu].isEditedDive = YES;
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
                
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"Failure!"];
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [SVProgressHUD showErrorWithStatus:@"Failure!"];
        
    }];
    
    
}

-(void)didLongPressedPhoto:(UIGestureRecognizer *)gestureRecognizer :(NSIndexPath *)indexPath :(UIImage *)image
{
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        m_longPressLocation = [gestureRecognizer locationInView:self.view];
        m_selectedWallet = image;

        actionLayer = [CALayer layer];
        
        actionLayer.contents = (id) image.CGImage;
        actionLayer.opacity = 0.75;
        actionLayer.bounds = CGRectMake(m_longPressLocation.x, m_longPressLocation.y, 106, 106);
        actionLayer.position = m_longPressLocation;
        
        [self.view.layer addSublayer:actionLayer];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        CGRect frame = m_collectionViewPhoto.frame;
        frame.origin.y +=90;
        [m_collectionViewPhoto setFrame:frame];
        
        [UIView commitAnimations];
        
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        
        CGPoint point = [gestureRecognizer locationInView:self.view];
        [CATransaction begin];
        [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
        [actionLayer setPosition:point];
        [CATransaction commit];
        
        CGRect actionlayerFrame = actionLayer.frame;
        actionlayerFrame.origin.x +=20;
        actionlayerFrame.origin.y +=20;
        actionlayerFrame.size.width -=40;
        actionlayerFrame.size.height -=40;
        CGRect rect = CGRectIntersection(m_btnRemove.frame, actionlayerFrame);
        if (!CGRectIsNull(rect)) {
            
            [m_btnRemove.titleLabel setTextColor:[UIColor redColor]];
            [m_imgRemove setImage:[UIImage imageNamed:@"btn_action_discard_sel.png"]];
            
        }else{
            
            [m_btnRemove.titleLabel setTextColor:[UIColor whiteColor]];
            [m_imgRemove setImage:[UIImage imageNamed:@"btn_action_discard.png"]];
            
        }
        
        CGRect rect1 = CGRectIntersection(m_btnShare.frame, actionlayerFrame);
        
        
        if (!CGRectIsNull(rect1)) {
            
            [m_btnShare.titleLabel setTextColor:kMainDefaultColor];
            [m_imgShare setImage:[UIImage imageNamed:@"btn_action_picture_sel.png"]];
        }else{
            
            [m_btnShare.titleLabel setTextColor:[UIColor whiteColor]];
            [m_imgShare setImage:[UIImage imageNamed:@"btn_action_picture.png"]];
            
        }
        
        
        
    }
    
    if( gestureRecognizer.state == UIGestureRecognizerStateEnded ) {
        
        
        CGRect actionlayerFrame = actionLayer.frame;
        actionlayerFrame.origin.x +=20;
        actionlayerFrame.origin.y +=20;
        actionlayerFrame.size.width -=40;
        actionlayerFrame.size.height -=40;
        
        CGRect rect = CGRectIntersection(m_btnRemove.frame, actionlayerFrame);
        CGRect rect1 = CGRectIntersection(m_btnShare.frame, actionlayerFrame);
        if (!CGRectIsNull(rect)) {
            
            [self removeWallet:indexPath.row];
            
        }else if (!CGRectIsNull(rect1)) {

            [self shareWallet:indexPath];
            
        }
        
        
        
        [actionLayer removeFromSuperlayer];
        actionLayer = nil;
        [self.view.layer addSublayer:actionLayer];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        CGRect frame = m_collectionViewPhoto.frame;
        frame.origin.y -=90;
        [m_collectionViewPhoto setFrame:frame];
        
        [UIView commitAnimations];
        [m_btnRemove.titleLabel setTextColor:[UIColor whiteColor]];
        [m_imgRemove setImage:[UIImage imageNamed:@"btn_action_discard.png"]];
        
        [m_btnShare.titleLabel setTextColor:[UIColor whiteColor]];
        [m_imgShare setImage:[UIImage imageNamed:@"btn_action_picture.png"]];
        
        
    }
    
}

-(void)removeWallet:(int)index{
    
    [m_walletPictureIDs removeObjectAtIndex:index];
    [m_walletPictures removeObjectAtIndex:index];
    [m_collectionViewPhoto reloadData];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    
    
}
- (void)shareWallet:(NSIndexPath*)indexPath{
    
    NSMutableArray* activityItems = [[NSMutableArray alloc] init];
        [activityItems addObject:m_selectedWallet];
    
    if([activityItems count]>0){
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
        
    }
    
}
-(void)onSave:(id)sender{
    

    [AppManager sharedManager].loginResult.user.walletPictures = m_walletPictures;
    [AppManager sharedManager].loginResult.user.walletPictureIDs = m_walletPictureIDs;
    NSDictionary* updateParams = [[AppManager sharedManager].loginResult.user getDataDictionary];
 
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateParams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (jsonData) {
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSDictionary *params = @{@"auth_token": [AppManager sharedManager].loginResult.token,
                                 @"apikey" : API_KEY,
                                 @"flavour"     : FLAVOUR,
                                 @"arg" : jsonString,
                                 };
        
        
        NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/V2/user", SERVER_URL];
        
        [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:requestURLStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@",responseObject);
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [DrawerMenuViewController sharedMenu].isEditedDive = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"Failure"];
            NSLog(@"%@",error);
            
        }];
        
    }
    
    
    
}

@end
