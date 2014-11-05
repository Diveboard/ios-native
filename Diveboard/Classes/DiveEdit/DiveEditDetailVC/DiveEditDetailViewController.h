//
//  DiveEditDetailViewController.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiveInformation;

@interface DiveEditDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* m_tableView;
    
}

- (id)initWithDiveData:(DiveInformation *)diveInfo;
@end
