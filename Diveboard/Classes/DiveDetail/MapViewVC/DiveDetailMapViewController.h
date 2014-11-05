//
//  DiveDetailMapViewController.h
//  Diveboard
//
//  Created by SergeyPetrov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DiveDetailMapViewController : UIViewController
{
    IBOutlet MKMapView *m_mapViewSpot;
    IBOutlet UIButton* m_btnMapType;
    IBOutlet UIView* m_viewZoomCtrl;
    
}

- (id)initWithDiveInformation:(DiveInformation *) diveInfo;
- (IBAction)onChangeMapType:(id)sender;
- (IBAction)onZoomIn:(id)sender;
- (IBAction)onZoomOut:(id)sender;
-(void)setDiveInformation:(DiveInformation *)diveInfo;


@end
