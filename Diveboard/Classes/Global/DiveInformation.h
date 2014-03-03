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

@interface DiveInformation : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *maxDepth;
@property (nonatomic, strong) NSString *maxDepthUnit;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) DiveSpotInfo *spotInfo;
@property (nonatomic, strong) NSMutableArray *divePictures;

- (id)initWithDictionary:(NSDictionary *)data;

@end



