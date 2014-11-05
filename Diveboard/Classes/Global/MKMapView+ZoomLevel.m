//
//  MKMapView+ZoomLevel.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/23/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "MKMapView+ZoomLevel.h"

@implementation MKMapView (ZoomLevel)

- (void)setZoomLevel:(float)zoomLevel {
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:zoomLevel animated:NO];
}

- (float)zoomLevel {
    return log2(360 * ((self.frame.size.width/256) / self.region.span.longitudeDelta));
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(float)zoomLevel animated:(BOOL)animated {
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*self.frame.size.width/256);
    
    @try {
        
        [self setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
        
    } @catch (NSException *exc) {
        
    }
    
    
    
}
@end
