//
//  DiveDetailViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/4/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UIUnderlineButton.h"
#import "DiveInformation.h"
#import "AsyncUIImageView.h"
#import "OneDiveView.h"


@class DiveListViewController;

@interface DiveDetailViewController : UIViewController
{
    IBOutlet UIView *viewTopBox;
    IBOutlet UILabel *lblTripName;
    IBOutlet UILabel *lblCityCountry;
    IBOutlet UIButton *btnClose;
    
    IBOutlet UIView *viewTapBox;
    IBOutlet UIView *viewDetailBox;
    IBOutlet UIView *viewPhotosBox;
    IBOutlet UIView *viewMapBox;
    IBOutlet UIButton *btnDetails;
    IBOutlet UIImageView *imgviewDetailBtn;
    IBOutlet UILabel *lblDetailBtn;
    IBOutlet UIButton *btnPhotos;
    IBOutlet UIImageView *imgviewPhotosBtn;
    IBOutlet UILabel *lblPhotosBtn;
    IBOutlet UIButton *btnMap;
    IBOutlet UIImageView *imgviewMapBtn;
    IBOutlet UILabel *lblMapBtn;
    
    IBOutlet UIScrollView *viewContent;
    
    // detail view
    
    IBOutlet UIView *viewDetail;
    IBOutlet UIView *vdTopBox;
    IBOutlet UIView *vdGraphBox;
    IBOutlet UIView *vdDateBox;
    IBOutlet UIView *vdNoteBox;
    IBOutlet AsyncUIImageView *vdimgUserAvator;
    IBOutlet UILabel *vdlblNickname;
    IBOutlet UILabel *vdlblCountry;
    IBOutlet UIButton *vdbtnEdit;
    IBOutlet UIButton *vdbtnDelete;
    IBOutlet UIView *vdviewShop;
    IBOutlet UILabel *vdlblDiveShop;
    IBOutlet UILabel *vdlblShopContent;
    IBOutlet AsyncUIImageView *imgviewShop;
    IBOutlet UIView *vdviewGraph;
    IBOutlet UILabel *vdlblGraphTitle;
    IBOutlet AsyncUIImageView *vdimgviewGraph;
    IBOutlet UILabel *vdlblDepthTitle;
    IBOutlet UILabel *vdlblDepth;
    IBOutlet UILabel *vdlblDateTitle;
    IBOutlet UILabel *vdlblDateContent;
    IBOutlet UILabel *vdlblDurationTitle;
    IBOutlet UILabel *vdlblDurationContent;
    IBOutlet UILabel *vdlblVisibiltyTitle;
    IBOutlet UILabel *vdlblVisibiltyContent;
    IBOutlet UILabel *vdlblTempTitle;
    IBOutlet UILabel *vdlblTempContent;
    IBOutlet UILabel *vdlblWaterTitle;
    IBOutlet UILabel *vdlblWaterContent;
    IBOutlet UILabel *vdlblDivetypeTitle;
    IBOutlet UILabel *vdlblDivetypeContent;
    IBOutlet UILabel *vdlblNoteContent;
    UIUnderlineButton *btnViewDiveBrowser;
    
    
    // photos view
    IBOutlet UIView *photosContent;
    
    // map view
    IBOutlet MKMapView *mapView;
    
}
- (IBAction)tapButtonAction:(id)sender;
- (IBAction)closeAction:(id)sender;
- (IBAction)diveEditAction:(id)sender;
- (IBAction)diveDeleteAction:(id)sender;

- (id)initWithDiveInformation:(DiveInformation *) diveInfo;

@property (nonatomic, retain) OneDiveView *diveView;
@property (nonatomic, retain) DiveListViewController *diveListViewController;

@end
