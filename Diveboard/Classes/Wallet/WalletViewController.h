//
//  WalletViewController.h
//  Diveboard
//
//  Created by XingYing on 10/5/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    IBOutlet UICollectionView* m_collectionViewPhoto;
    IBOutlet UIView* m_viewAddPhoto;
    
    IBOutlet UIButton* m_btnShare;
    IBOutlet UIButton* m_btnRemove;
    IBOutlet UIImageView* m_imgShare;
    IBOutlet UIImageView* m_imgRemove;
    
}


- (IBAction)onDrawer:(id)sender;
- (IBAction)onTakePicture:(id)sender;
- (IBAction)onSelectPictureFromGallery:(id)sender;
- (IBAction)onSave:(id)sender;
@end
