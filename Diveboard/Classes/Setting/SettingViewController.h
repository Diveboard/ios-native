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
<<<<<<< HEAD
    IBOutlet UILabel  *lblPendingRequest;
    IBOutlet UIButton *btnPendingRequest;
    IBOutlet UIButton *btnAccessSudo;
    
=======
>>>>>>> 685ccbd31b49cbe284c2f1c0074f39fcac1849d8
}

@property (nonatomic, strong) DiveListViewController *parent;
- (IBAction)backActions:(id)sender;

@end
