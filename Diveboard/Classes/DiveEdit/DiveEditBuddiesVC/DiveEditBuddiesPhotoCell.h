//
//  DiveEditBuddiesPhotoCell.h
//  Diveboard
//
//  Created by XingYing on 9/29/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUIImageView.h"
#import "DiveInformation.h"
@interface DiveEditBuddiesPhotoCell : UICollectionViewCell

{
    IBOutlet UIImageView* m_imgBuddyPhoto;
    IBOutlet UILabel*        m_lblBuddyName;
}

- (void)setBuddyData:(Buddy*)buddy;



@end
