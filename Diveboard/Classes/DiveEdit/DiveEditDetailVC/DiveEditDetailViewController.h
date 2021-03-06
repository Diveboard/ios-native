//
//  DiveEditDetailViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiveInformation;

@interface DiveEditDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* m_tableView;
    float verticalContentOffset;
    
}

- (id)initWithDiveData:(DiveInformation *)diveInfo;
- (void)setDiveInformation:(DiveInformation *)diveInfo;

@end
