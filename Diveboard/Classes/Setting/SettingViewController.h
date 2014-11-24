//
//  SettingViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <BugSense-iOS/BugSenseController.h>

#import "DiveListViewController.h"


@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView* m_tableView;
    
}


-(IBAction)onDrawer:(id)sender;

@end
