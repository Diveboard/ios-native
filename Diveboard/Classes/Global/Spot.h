//
//  Spot.h
//  Diveboard
//
//  Created by Vladimir Popov on 1/6/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Picture.h"

@interface Spot : NSObject{
//    NSInteger               _id;
//	NSString				*_shakenId;
//	NSString				*_name;
//	double                  _lat;
//	double                  _lng;
//	NSInteger               _zoom;
//    NSInteger               _locationId;
//    NSString                *_locationName;
//    NSInteger				_regionId;
//    NSInteger				_countryId;
//    NSInteger				_privateUserId;
//    NSString				*_countryCode;
//    NSString				*_countryName;
//    Picture                 *_countryFlagBig;
//    Picture                 *_countryFlagSmall;
//    NSString                *_cname;
//    NSString				*_location;
}
// properties for spot

@property (nonatomic,)        NSInteger                 _id;
@property (nonatomic, strong) NSString                  *_shakenId;
@property (nonatomic, strong) NSString                  *_name;
@property (nonatomic,)        double                    _lat;
@property (nonatomic,)        double                    _lng;
@property (nonatomic,)        NSInteger                 _zoom;
@property (nonatomic,)        NSInteger                 _locationId;
@property (nonatomic, strong) NSString                  *_locationName;
@property (nonatomic,)        NSInteger                 _regionId;
@property (nonatomic,)        NSInteger                 _countryId;
@property (nonatomic,)        NSInteger                 _privateUserId;
@property (nonatomic, strong) NSString                  *_countryCode;
@property (nonatomic, strong) NSString                  *_countryName;
@property (nonatomic, strong) Picture                   *_countryFlagBig;
@property (nonatomic, strong) Picture                   *_countryFlagSmall;
@property (nonatomic, strong) NSString                  *_cname;
@property (nonatomic, strong) NSString                  *_location;

@end
