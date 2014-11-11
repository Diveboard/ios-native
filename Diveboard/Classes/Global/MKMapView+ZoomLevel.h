//
//  MKMapView+ZoomLevel.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/23/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)


@property (assign, nonatomic) float zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(float)zoomLevel
                   animated:(BOOL)animated;

@end
