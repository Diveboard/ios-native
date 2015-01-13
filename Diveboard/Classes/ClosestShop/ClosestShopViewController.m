//
//  ClosestShopViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 10/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "ClosestShopViewController.h"
#import "DrawerMenuViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "AFNetworking.h"
@interface ClosestShopViewController ()

@end

@implementation ClosestShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [m_btnGPS.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_btnGPS.layer setBorderWidth:1.0];
    
    
    [m_viewZoomCtrl.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_viewZoomCtrl.layer setBorderWidth:1.0];
    

    [self onSetCurrentLocation:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onDrawer:(id)sender{
    
    [[DrawerMenuViewController sharedMenu] toggleDrawerMenu];
    
}
-(void)onZoomIn:(id)sender{
    
    float zoomLevel = m_mapViewShop.zoomLevel+1;
    
    [m_mapViewShop setCenterCoordinate:m_mapViewShop.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
}
-(void)onZoomOut:(id)sender{
    
    float zoomLevel = m_mapViewShop.zoomLevel-1;
    
    [m_mapViewShop setCenterCoordinate:m_mapViewShop.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
}
-(void)onSetCurrentLocation:(id)sender{
    
    
    [m_mapViewShop setCenterCoordinate:[AppManager sharedManager].currentLocation.coordinate zoomLevel:10 animated:YES];
    
}

-(void)onChangeMapType:(id)sender{
    
    if (m_mapViewShop.mapType == MKMapTypeStandard) {
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_map_view.png"] forState:UIControlStateNormal];
        [m_mapViewShop setMapType:MKMapTypeSatellite];
        
    }else{
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_earth_view.png"] forState:UIControlStateNormal];
        [m_mapViewShop setMapType:MKMapTypeStandard];
        
    }
    
}

#pragma mark MKMapView Delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    
        [self searchShopByLocation];
        
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* ShopMapAnnotationIdentifier = @"ShopAnnotationIdentifier";
    
    MKAnnotationView* pinView =
    (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ShopMapAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:ShopMapAnnotationIdentifier];
        
        [pinView setImage:[UIImage imageNamed:@"marker.png"]];
        
        pinView.canShowCallout = YES;
    }
    return pinView;
    
}
-(void) searchShopByLocation{
    
    
    CLLocationCoordinate2D SWCoordinate = [m_mapViewShop convertPoint:CGPointMake(0, m_mapViewShop.frame.size.height) toCoordinateFromView:m_mapViewShop];
    
    CLLocationCoordinate2D NECoordinate = [m_mapViewShop convertPoint:CGPointMake(m_mapViewShop.frame.size.width, 0) toCoordinateFromView:m_mapViewShop];
    
    
    
    NSDictionary *params = @{@"lat": [NSNumber numberWithDouble:m_mapViewShop.centerCoordinate.latitude],
                             @"lng": [NSNumber numberWithDouble:m_mapViewShop.centerCoordinate.longitude],
                             @"latSW":[NSNumber numberWithDouble:SWCoordinate.latitude],
                             @"lngSW":[NSNumber numberWithDouble:SWCoordinate.longitude],
                             @"latNE":[NSNumber numberWithDouble:NECoordinate.latitude],
                             @"lngNE":[NSNumber numberWithDouble:NECoordinate.longitude],
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };
    
    
    [self searchShop:params];
    
}


- (void) searchShop:(NSDictionary*) params
{
    
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/search_shop_text", SERVER_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:REQUEST_TIME_OUT];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        if ([[data objectForKey:@"success"] boolValue]) {

            [m_mapViewShop removeAnnotations:m_mapViewShop.annotations];
            NSArray* arrShops = [data objectForKey:@"shops"];
            for (int i = 0 ; i < arrShops.count; i++) {
                
                
                NSDictionary* shop = arrShops[i];
                CLLocationCoordinate2D shopLocation;
                
                shopLocation = CLLocationCoordinate2DMake(getDoubleValue([shop objectForKey:@"lat"]), getDoubleValue([shop objectForKey:@"lng"]));
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setTitle:[NSString stringWithFormat:@"%@, %@",getStringValue([shop objectForKey:@"name"]),getStringValue([shop objectForKey:@"cname"])]];
                [annotation setCoordinate:shopLocation];
                
                [m_mapViewShop addAnnotation:annotation];
                
                
            }
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


@end
