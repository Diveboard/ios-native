//
//  DiveEditViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "DiveInformation.h"
#import "TKDatePickerView.h"
#import "TKListPickerView.h"


@protocol DiveEditViewControllerDelegate <NSObject>

- (void) diveEditFinish:(DiveInformation *)diveInfo;

@end

@interface DiveEditViewController : UIViewController <UITextFieldDelegate, TKDatePickerViewDelegate, TKListPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIScrollView *scrviewMain;
    
    // detail view
    IBOutlet UIView *viewContent;
    IBOutlet UILabel        *lblDate;
    IBOutlet UILabel        *lblTime;
    IBOutlet UITextField    *txtDepth;
    IBOutlet UILabel *lblMaxdepthUnit;
    IBOutlet UITextField    *txtDuration;
    IBOutlet UITextField    *txtWeight;
    IBOutlet UILabel        *lblWeightUnit;
    IBOutlet UITextField    *txtDiveNumber;
    IBOutlet UITextField    *txtTripName;
    IBOutlet UILabel        *lblVisibility;
    IBOutlet UILabel        *lblCurrent;
    IBOutlet UITextField    *txtSurface;
    IBOutlet UITextField    *txtBottom;
    IBOutlet UILabel        *lblSurfaceUnit;
    IBOutlet UILabel        *lblBottomUnit;
    IBOutlet UITextField    *txtAltitude;
    IBOutlet UILabel        *lblAltitudeUnit;
    IBOutlet UILabel        *lblWater;
    IBOutlet UISwitch       *schPublic;
    IBOutlet UIButton *btnDiveEditCloseKeyboard;
    
    // note view
    IBOutlet UIView *viewNotes;
    IBOutlet UITextView *txtviewNotes;
    IBOutlet UIButton *btnNoteDone;
    
    // spots view
    IBOutlet UIView *viewSpots;
    IBOutlet UILabel *lblCurrentSpot;
    IBOutlet UIButton *btnSpotDelete;
    IBOutlet UITextField *txtSearchSpot;
    IBOutlet UITableView *tblSpotList;
    IBOutlet UILabel *lblNoResult;
    
    
    
    IBOutlet UIView *viewButtonBox;
    IBOutlet UIButton *btnDetails;
    IBOutlet UIButton *btnNotes;
    IBOutlet UIButton *btnSpots;
}
- (IBAction)backAction:(id)sender;
- (IBAction)saveAction:(id)sender;

- (IBAction)tapButtonAction:(id)sender;

- (IBAction)noteDoneAction:(id)sender;
- (IBAction)diveEditDoneAction:(id)sender;

- (IBAction)spotDeleteAction:(id)sender;

@property (nonatomic, strong) id<DiveEditViewControllerDelegate> delegate;

- (id)initWithDiveData:(DiveInformation *)diveInfo;

@end