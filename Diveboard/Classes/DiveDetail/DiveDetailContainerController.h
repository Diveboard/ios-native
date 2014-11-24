//
//  Diveboard
//
//  Created by Vladimir Popov on 3/4/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <BugSense-iOS/BugSenseController.h>

#import "UIUnderlineButton.h"
#import "DiveInformation.h"
#import "OneDiveView.h"


@class DiveListViewController;

@interface DiveDetailContainerController : UIViewController

{
    IBOutlet UIView         *viewTopBox;
    IBOutlet UILabel        *lblTripName;
    IBOutlet UILabel        *lblCityCountry;
    IBOutlet UIButton       *btnClose;
    IBOutlet UIView         *viewTapBox;
    IBOutlet UIView         *viewDetailBox;
    IBOutlet UIView         *viewPhotosBox;
    IBOutlet UIView         *viewMapBox;
    IBOutlet UIButton       *btnDetails;
    IBOutlet UIImageView    *imgviewDetailBtn;
    IBOutlet UILabel        *lblDetailBtn;
    IBOutlet UIButton       *btnPhotos;
    IBOutlet UIImageView    *imgviewPhotosBtn;
    IBOutlet UILabel        *lblPhotosBtn;
    IBOutlet UIButton       *btnMap;
    IBOutlet UIImageView    *imgviewMapBtn;
    IBOutlet UILabel        *lblMapBtn;
    
    UIButton                *m_btnCurrentTab;
    
    IBOutlet UIView   *viewContent;
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView    *imgViewBackground;

- (IBAction)tapButtonAction:(id)sender;
- (IBAction)closeAction:(id)sender;

- (id)initWithDiveInformation:(DiveInformation *) diveInfo;

@end
