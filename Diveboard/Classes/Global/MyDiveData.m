//
//  MyDiveData.m
//  Diveboard
//
//  Created by Vladimir Popov on 12/28/13.
//  Copyright (c) 2013 Vladimir Popov. All rights reserved.
//

#import "MyDiveData.h"

@implementation MyDiveData

@synthesize image, trip_name, _date, navController, _maxdepth, _duration, _id,
            _spotId, _spot, _pictures, _pictureImages, _lat, _lng;
@synthesize isSettedSmallImages;

#pragma mark - DiveScrollerHeaderInfo

- (NSString*) diveTrip_name
{
    return self.trip_name;
}

- (NSString*) diveDate{
    return self._date;
}

#pragma mark - NSObject

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ 0x%@: %@", [self class], self, self.trip_name];
}

@end
