//
//  DiveEditBuddiesViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiveInformation;

@interface DiveEditBuddiesViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

{
    
    IBOutlet UICollectionView* m_CollectionViewBuddies;
}

- (id)initWithDiveData:(DiveInformation *)diveInfo;

- (void)setDiveInformation:(DiveInformation *)diveInfo;

@end
