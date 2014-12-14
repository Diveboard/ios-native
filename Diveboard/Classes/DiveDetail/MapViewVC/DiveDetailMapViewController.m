//
//  DiveDetailMapViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "Global.h"

@interface DiveDetailMapViewController ()
{
    DiveInformation* m_DiveInformation;
}
@end

@implementation DiveDetailMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDiveInformation:(DiveInformation *)diveInfo
{
    NSString *nibFilename;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        nibFilename = @"DiveDetailMapViewController";
//    } else {
//        nibFilename = @"DiveDetailMapViewController-ipad";
//    }
    nibFilename = @"DiveDetailMapViewController";
    self = [self initWithNibName:nibFilename bundle:nil];
    if (self) {
        m_DiveInformation = diveInfo;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [m_viewZoomCtrl.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_viewZoomCtrl.layer setBorderWidth:1.0];
    
    [self updateMapview];
    // Do any additional setup after loading the view from its nib.
}
-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    m_DiveInformation = diveInfo;
}

- (void) updateMapview
{
    CLLocationCoordinate2D zoomLocation;
    if ([m_DiveInformation.spotInfo.ID integerValue] != 1) {
        [m_btnMapType setHidden:NO];
        [m_viewZoomCtrl setHidden:NO];
        [m_mapViewSpot setHidden:NO];
        
        if (m_DiveInformation.spotInfo.lat.length > 0) {
            zoomLocation.latitude = [m_DiveInformation.spotInfo.lat floatValue];
        } else {
            zoomLocation.latitude = 0;
        }
        if (m_DiveInformation.spotInfo.lng.length > 0) {
            zoomLocation.longitude = [m_DiveInformation.spotInfo.lng floatValue];
        } else {
            zoomLocation.longitude = 0;
        }
        
        
        
        [m_mapViewSpot setCenterCoordinate:zoomLocation zoomLevel:10 animated:YES];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:zoomLocation];
        [m_mapViewSpot addAnnotation:annotation];
        
        
    }else{
        
        [m_btnMapType setHidden:YES];
        [m_viewZoomCtrl setHidden:YES];
        [m_mapViewSpot setHidden:YES];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(MKAnnotationView *)mapView:(MKMapView *)p_mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* SpotMapAnnotationIdentifier = @"SpotAnnotationIdentifier";
    
    MKAnnotationView* pinView =
    (MKAnnotationView *)[p_mapView dequeueReusableAnnotationViewWithIdentifier:SpotMapAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:SpotMapAnnotationIdentifier];
        
        [pinView setImage:[UIImage imageNamed:@"marker.png"]];
        
        pinView.canShowCallout = YES;
    }
    return pinView;
    
}
-(void)onChangeMapType:(id)sender{
    
    if (m_mapViewSpot.mapType == MKMapTypeStandard) {
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_map_view.png"] forState:UIControlStateNormal];
        [m_mapViewSpot setMapType:MKMapTypeSatellite];
        
    }else{
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_earth_view.png"] forState:UIControlStateNormal];
        [m_mapViewSpot setMapType:MKMapTypeStandard];
        
    }
    
}
-(void)onZoomIn:(id)sender{
    
    float  zoomLevel = m_mapViewSpot.zoomLevel+1;
    [m_mapViewSpot setCenterCoordinate:m_mapViewSpot.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
}
-(void)onZoomOut:(id)sender{
    
    float  zoomLevel = m_mapViewSpot.zoomLevel-1;
    [m_mapViewSpot setCenterCoordinate:m_mapViewSpot.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
