//
//  DiveDetailPhotosViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiveDetailPhotosViewDelegate <NSObject>

@optional

-(void) didSelectedPhotoCell:(int)index;

@end

@interface DiveDetailPhotosViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *m_collectionViewPhoto;
    IBOutlet UILabel*       m_lblNoPictures;
}

@property (nonatomic, strong) id<DiveDetailPhotosViewDelegate> delegate;

- (id)initWithDiveInformation:(DiveInformation *) diveInfo;
- (void)setDiveInformation:(DiveInformation *)diveInfo;


@end
