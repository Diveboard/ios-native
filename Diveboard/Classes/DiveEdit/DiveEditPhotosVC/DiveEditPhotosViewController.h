//
//  DiveEditPhotosViewController.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiveInformation;

@protocol DiveEditPhotosViewDelegate <NSObject>

@optional

-(void) didSelectedPhotoCell:(int)index;

@end

@interface DiveEditPhotosViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView* m_collectionViewPhoto;
    IBOutlet UIButton* m_btnSetMain;
    IBOutlet UIButton* m_btnRemove;
    IBOutlet UIImageView* m_imgSetMain;
    IBOutlet UIImageView* m_imgRemove;
    IBOutlet UIView* m_viewAddPhoto;
    
}

@property (nonatomic, strong) id<DiveEditPhotosViewDelegate> delegate;

- (id)initWithDiveData:(DiveInformation *)diveInfo;

- (IBAction)onTakePicture:(id)sender;
- (IBAction)onSelectPictureFromGallery:(id)sender;

@end
