//
//  DiveEditShopViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class DiveInformation;

enum {
    DiveEditShopStateAssign = 1,
    DiveEditShopStateSearch,
};
typedef NSUInteger DiveEditShopState;


@interface DiveEditShopViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet MKMapView* m_mapViewShop;
    IBOutlet UIButton* m_btnMapType;
    IBOutlet UIView* m_viewZoomCtrl;
    IBOutlet UIButton* m_btnGPS;
    IBOutlet UITableView* m_tableView;
    IBOutlet UISearchBar* m_txtSearch;
    IBOutlet UILabel* m_lblNoResult;
    
    IBOutlet UIView* m_viewCurrentShop;
    IBOutlet UIView* m_viewShopSearch;

    IBOutlet UILabel* m_lblCurrentName;
    IBOutlet UILabel* m_lblCurrentGPS;

    IBOutlet UIScrollView* m_scrollView;
    IBOutlet UIView*       m_viewContainer;

}



- (id)initWithDiveData:(DiveInformation *)diveInfo;
- (IBAction)onZoomIn:(id)sender;
- (IBAction)onZoomOut:(id)sender;
- (IBAction)onSetCurrentLocation:(id)sender;
- (IBAction)onChangeMapType:(id)sender;

- (IBAction)setSearchState;

- (void)setDiveInformation:(DiveInformation *)diveInfo;


@end
