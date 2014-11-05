//
//  DiveEditViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiveInformation.h"
#import "JPTabViewController.h"
@protocol DiveEditViewControllerDelegate <NSObject>

- (void) diveEditFinish:(DiveInformation *)diveInfo;

@end

@interface DiveEditViewController : JPTabViewController <UIAlertViewDelegate,JPTabViewControllerDelegate>
{
    IBOutlet UILabel *lblTitle;
    // detail view
    IBOutlet UIButton* m_btnBack;
    IBOutlet UIButton* m_btnDrawer;
}
- (IBAction)onDrawer:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onBack:(id)sender;

@property (nonatomic, strong) id<DiveEditViewControllerDelegate> editDelegate;

- (id)initWithDiveData:(DiveInformation *)diveInfo;

@end