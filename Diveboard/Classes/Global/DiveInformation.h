//
//  DiveInformation.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - DiveSpotInfo

@interface DiveSpotInfo : NSObject

@property (nonatomic, strong) NSString *class_;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *countryFlagBig;
@property (nonatomic, strong) NSString *countryFlagSmall;
@property (nonatomic, strong) NSString *counttyName;
@property (nonatomic, strong) NSString *flavour;
@property (nonatomic, strong) NSString *fullPermalink;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *permaLink;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *shakenID;
@property (nonatomic, strong) NSString *staticMap;
@property (nonatomic, strong) NSString *withinCountryBounds;


- (id)initWithDictionary:(NSDictionary *)data;

@end


#pragma mark - DivePicture

@interface DivePicture : NSObject

@property (nonatomic, strong) NSString *class_;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *flavour;
@property (nonatomic, strong) NSString *fullRedirectLink;
@property (nonatomic, strong) NSString *fullPermaLink;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *largeURL;
@property (nonatomic, strong) NSString *mediumURL;
@property (nonatomic, strong) NSString *smallURL;
@property (nonatomic, strong) NSString *media;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *permaLink;
@property (nonatomic, strong) NSString *player;
@property (nonatomic, strong) NSString *thumbnail;

- (id)initWithDictionary:(NSDictionary *)data;


@end

#pragma mark - DiveShop

@interface DiveShop : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fullPermalink;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *web;
@property (nonatomic, strong) NSString *shakenID;
@property (nonatomic, strong) NSString *picture;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - Temp

@interface Temp : NSObject

@property (nonatomic, strong) NSString *bottom;
@property (nonatomic, strong) NSString *bottomUnit;
@property (nonatomic, strong) NSString *bottomValue;
@property (nonatomic, strong) NSString *surface;
@property (nonatomic, strong) NSString *surfaceUnit;
@property (nonatomic, strong) NSString *surfaceValue;

- (id)initWithDictionary:(NSDictionary *)data;

@end



#pragma mark - DiveWeight

@interface DiveWegith : NSObject

@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *value;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - SpotSearchResult

@interface SpotSearchResult : NSObject

@property (nonatomic, strong) DiveSpotInfo *spotInfo;
@property (nonatomic, strong) NSString     *ID;
@property (nonatomic, strong) NSString     *name;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - DiveInformation

@interface DiveInformation : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *shakenID;
@property (nonatomic, strong) NSString *maxDepth;
@property (nonatomic, strong) NSString *maxDepthUnit;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) DiveSpotInfo *spotInfo;
@property (nonatomic, strong) NSMutableArray *divePictures;
@property (nonatomic, strong) DiveShop *diveShop;
@property (nonatomic, strong) NSString *visibility;
@property (nonatomic, strong) NSString *water;
@property (nonatomic, strong) Temp     *temp;
@property (nonatomic, strong) NSArray  *diveType;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) DiveWegith *weight;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *current;
@property (nonatomic, strong) NSString *altitude;
@property (nonatomic, strong) NSString *privacy;

- (id)initWithDictionary:(NSDictionary *)data;

@end



