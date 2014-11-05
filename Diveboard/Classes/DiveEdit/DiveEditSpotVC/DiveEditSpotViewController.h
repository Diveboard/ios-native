//
//  DiveEditSpotViewController.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class DiveInformation;
enum {
    DiveEditSpotStateAssign = 1,
    DiveEditSpotStateSearch,
    DiveEditSpotStateAdd
};
typedef NSUInteger DiveEditSpotState;

@interface DiveEditSpotViewController : UIViewController <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    IBOutlet MKMapView* m_mapViewSpot;
    IBOutlet UIButton* m_btnMapType;
    IBOutlet UIView* m_viewZoomCtrl;
    IBOutlet UIButton* m_btnGPS;
    IBOutlet UIButton* m_btnAdd;
    IBOutlet UITableView* m_tableView;
    IBOutlet UISearchBar* m_txtSearch;
    IBOutlet UILabel* m_lblNoResult;
    IBOutlet UIView* m_viewCurrentSpot;
    IBOutlet UIView* m_viewSpotSearch;
    IBOutlet UIView* m_viewSpotAdd;
    IBOutlet UILabel* m_lblCurrentName;
    IBOutlet UILabel* m_lblCurrentCountry;
    IBOutlet UILabel* m_lblCurrentGPS;
    
    IBOutlet UIButton* m_btnCountry;
    IBOutlet UIButton* m_btnRegion;
    IBOutlet UIButton* m_btnLocation;
    IBOutlet UITextField* m_txtSpotName;
    
    IBOutlet UIScrollView* m_scrollView;
    IBOutlet UIView* m_viewContainer;
}

- (id)initWithDiveData:(DiveInformation *)diveInfo;
- (IBAction)onSetCurrentLocation:(id)sender;
- (IBAction)onChangeMapType:(id)sender;
- (IBAction)onZoomIn:(id)sender;
- (IBAction)onZoomOut:(id)sender;
- (IBAction)onChangeSpot:(id)sender;
- (IBAction)onAddManualSpot:(id)sender;
- (IBAction)onDropDown:(id)sender;
- (IBAction)onAddConfirm:(id)sender;
@end
