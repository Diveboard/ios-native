//
//  DiveListViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/26/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <BugSense-iOS/BugSenseController.h>

#import "DiveCountlineView.h"
#import "OneDiveView.h"

@interface DiveListViewController : UIViewController <DiveCountlineDelegate, OneDiveViewDelegate,  UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrviewMain;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCoordinate;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewBackground;



- (IBAction)menuAction:(id)sender;

- (void)setCoordinateValue:(DiveInformation *)diveInfoOfSelf;

- (void) diveViewsUpdate;
- (void) updateUnit;

@end
