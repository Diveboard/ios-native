//
//  DiveEditPhotosViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditPhotosViewController.h"
#import "DiveInformation.h"
#import "DiveEditPhotoCell.h"
#import "DivePicturesViewController.h"
#import "KLCPopup.h"
#import "DiveEditViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIView+FindUIViewController.h"
#import "DrawerMenuViewController.h"
@interface DiveEditPhotosViewController ()<DiveEditPhotoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DiveInformation* m_DiveInformation;
    CGPoint m_longPressLocation;
    CALayer *actionLayer;
    KLCPopup* m_KLCPopup;

}
@end

@implementation DiveEditPhotosViewController
@synthesize delegate;
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
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        nibFilename = @"DiveEditPhotosViewController";
//    } else {
//        nibFilename = @"DiveEditPhotosViewController-ipad";
//    }
    nibFilename = @"DiveEditPhotosViewController";

    self = [self initWithNibName:nibFilename bundle:nil];

    if (self) {
        m_DiveInformation = diveInfo;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [m_collectionViewPhoto registerNib:[UINib nibWithNibName:@"DiveEditPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
//    m_collectionViewPhoto.backgroundView = view;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(DiveEditPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiveEditPhotoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    if (indexPath.row == m_DiveInformation.divePictures.count) {
        
        [cell setAddButton:indexPath];
        
    }else{
        
        DivePicture* divePicture = [m_DiveInformation.divePictures objectAtIndex:indexPath.row];
        [cell setDivePicture:indexPath:divePicture];
        
    }
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPhotoCell:)]) {
        
        [self.delegate didSelectedPhotoCell:(int)indexPath.row];
        
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return m_DiveInformation.divePictures.count+1;
}
-(void)didLongPressedPhoto:(UIGestureRecognizer *)gestureRecognizer :(NSIndexPath *)indexPath :(UIImage *)image
{
 
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        m_longPressLocation = [gestureRecognizer locationInView:self.view];

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
        
        CGRect rect1 = CGRectIntersection(m_btnSetMain.frame, actionlayerFrame);

        
        if (!CGRectIsNull(rect1)) {
            
            [m_btnSetMain.titleLabel setTextColor:kMainDefaultColor];
            [m_imgSetMain setImage:[UIImage imageNamed:@"btn_action_picture_sel.png"]];
        }else{
            
            [m_btnSetMain.titleLabel setTextColor:[UIColor whiteColor]];
            [m_imgSetMain setImage:[UIImage imageNamed:@"btn_action_picture.png"]];
            
        }
        
        
        
    }
    
    if( gestureRecognizer.state == UIGestureRecognizerStateEnded ) {
     
        
        CGRect actionlayerFrame = actionLayer.frame;
        actionlayerFrame.origin.x +=20;
        actionlayerFrame.origin.y +=20;
        actionlayerFrame.size.width -=40;
        actionlayerFrame.size.height -=40;
        
        CGRect rect = CGRectIntersection(m_btnRemove.frame, actionlayerFrame);
        CGRect rect1 = CGRectIntersection(m_btnSetMain.frame, actionlayerFrame);
        if (!CGRectIsNull(rect)) {
            
            [self removePhoto:(int)indexPath.row];
            
        }else if (!CGRectIsNull(rect1)) {
            
            [self setMainPhoto:(int)indexPath.row];
            
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

        [m_btnSetMain.titleLabel setTextColor:[UIColor whiteColor]];
        [m_imgSetMain setImage:[UIImage imageNamed:@"btn_action_picture.png"]];

        
    }
    
}

- (void) removePhoto:(int)index
{
    
    [m_DiveInformation.divePictures removeObjectAtIndex:index];
    [m_collectionViewPhoto reloadData];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;

}

- (void) setMainPhoto:(int)index{
    
    DivePicture* firstPicture = [m_DiveInformation.divePictures firstObject];
    [m_DiveInformation.divePictures replaceObjectAtIndex:0 withObject:[m_DiveInformation.divePictures objectAtIndex:index]];
    [m_DiveInformation.divePictures replaceObjectAtIndex:index withObject:firstPicture];
    
    [m_collectionViewPhoto reloadData];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    
    
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
    
    DiveEditViewController *editViewController =(DiveEditViewController*)[self.view.superview firstAvailableUIViewController];
    
    [editViewController.navigationController presentViewController:imagepickerController animated:YES completion:nil];
    
    
    
}

- (void)onTakePicture:(id)sender{
    
    [m_KLCPopup dismiss:YES];

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagepickerController = [[UIImagePickerController alloc] init];
        
        
        [imagepickerController setDelegate:self];
        [imagepickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        
        DiveEditViewController *editViewController =(DiveEditViewController*)[self.view.superview firstAvailableUIViewController];
        
        [editViewController.navigationController presentViewController:imagepickerController animated:YES completion:nil];
        
    }

    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self uploadPhoto:image];

    
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
    
//    NSDictionary* resultData = [[DiveOfflineModeManager sharedManager] writeLocalDivePicture:image];
//    [self uploadSuccess:resultData];
//    return;
    
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
                    
                    [resultData setObject:[picData objectForKey:@"id"] forKey:@"id"];
                    
                    [[DiveOfflineModeManager sharedManager] writeImage:image url:getStringValue([resultData objectForKey:@"large"])];
                    [[DiveOfflineModeManager sharedManager] writeImage:image url:getStringValue([resultData objectForKey:@"medium"])];
                    [[DiveOfflineModeManager sharedManager] writeImage:image url:getStringValue([resultData objectForKey:@"small"])];
                    [[DiveOfflineModeManager sharedManager] writeImage:image url:getStringValue([resultData objectForKey:@"thumbnail"])];

                    [self uploadSuccess:resultData];
                    
                }else{
                    
                    NSDictionary* resultData = [[DiveOfflineModeManager sharedManager] writeLocalDivePicture:image];
                    [self uploadSuccess:resultData];

                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
           NSDictionary* resultData = [[DiveOfflineModeManager sharedManager] writeLocalDivePicture:image];
            
            [self uploadSuccess:resultData];
            
        }];


}

-(void)uploadSuccess:(NSDictionary*) resultData
{
    
    DivePicture* picture = [[DivePicture alloc] initWithDictionary:resultData];
    [m_DiveInformation.divePictures addObject:picture];
    [m_collectionViewPhoto reloadData];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
    
    
}
@end
