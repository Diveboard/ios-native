//
//  DiveEditPhotoCell.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/23/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiveInformation.h"
#import "AsyncUIImageView.h"

@protocol DiveEditPhotoCellDelegate <NSObject>

@optional
- (void)didLongPressedPhoto:(UIGestureRecognizer*) gestureRecognizer :(NSIndexPath*)indexPath :(UIImage*)image;
- (void)didClickedAddPhotoButton:(NSIndexPath*)indexPath;
@end


@interface DiveEditPhotoCell : UICollectionViewCell
{
    IBOutlet AsyncUIImageView* m_imgDivePicture;
    IBOutlet UIButton* m_btnAdd;
}
@property (nonatomic, strong) id<DiveEditPhotoCellDelegate> delegate;

- (void)setAddButton:(NSIndexPath*)indexPath;
- (void)setDivePicture:(NSIndexPath*)indexPath :(DivePicture*)divePicture;
- (IBAction)onAddButton:(id)sender;

@end
