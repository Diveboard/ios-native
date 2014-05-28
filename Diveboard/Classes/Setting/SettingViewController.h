//
//  SettingViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BugSense-iOS/BugSenseController.h>

#import "DiveListViewController.h"


@interface SettingViewController : UIViewController
{
    IBOutlet UIScrollView *scrview;
    IBOutlet UIButton *btnUnit;
    IBOutlet UILabel  *lblVersionNumber;
    IBOutlet UILabel  *lblPendingRequest;
    IBOutlet UIButton *btnPendingRequest;
    IBOutlet UIButton *btnAccessSudo;
    
}

@property (nonatomic, strong) DiveListViewController *parent;
- (IBAction)backActions:(id)sender;

@end
