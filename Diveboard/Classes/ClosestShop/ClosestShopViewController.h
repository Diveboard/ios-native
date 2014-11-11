//
//  ClosestShopViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 10/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ClosestShopViewController : UIViewController
{
    IBOutlet MKMapView* m_mapViewShop;
    IBOutlet UIView* m_viewZoomCtrl;
    IBOutlet UIButton* m_btnGPS;
    IBOutlet UIButton* m_btnMapType;

}



-(IBAction)onDrawer:(id)sender;
- (IBAction)onZoomIn:(id)sender;
- (IBAction)onZoomOut:(id)sender;
- (IBAction)onSetCurrentLocation:(id)sender;
- (IBAction)onChangeMapType:(id)sender;

@end
