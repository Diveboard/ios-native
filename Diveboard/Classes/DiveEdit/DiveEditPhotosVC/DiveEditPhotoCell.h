//
//  DiveEditPhotoCell.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/23/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiveInformation.h"

@protocol DiveEditPhotoCellDelegate <NSObject>

@optional
- (void)didLongPressedPhoto:(UIGestureRecognizer*) gestureRecognizer :(NSIndexPath*)indexPath :(UIImage*)image;
- (void)didClickedAddPhotoButton:(NSIndexPath*)indexPath;
- (void)didClickedYoutubeButton:(NSIndexPath*)indexPath :(NSString *)youtubeVideoId;
@end


@interface DiveEditPhotoCell : UICollectionViewCell
{
    IBOutlet UIImageView* m_imgDivePicture;
    
    IBOutlet UIButton* m_btnAdd;
    IBOutlet UIButton* m_btnYoutube;
}
@property (nonatomic, strong) id<DiveEditPhotoCellDelegate> delegate;
@property (nonatomic, copy) NSString* youtubeVideoId;

- (void)setAddButton:(NSIndexPath*)indexPath;
- (void)setYoutubeButton:(NSIndexPath*)indexPath :(NSString *)youtubeVideoId;
- (void)setDivePicture:(NSIndexPath*)indexPath :(DivePicture*)divePicture;
- (IBAction)onAddButton:(id)sender;
- (IBAction)onYoutubeButton:(id)sender;

@end
