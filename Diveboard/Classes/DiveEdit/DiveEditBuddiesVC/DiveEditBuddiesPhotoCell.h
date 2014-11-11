//
//  DiveEditBuddiesPhotoCell.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/29/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
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
