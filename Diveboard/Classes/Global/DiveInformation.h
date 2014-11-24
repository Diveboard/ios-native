//
//  DiveInformation.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <BugSense-iOS/BugSenseController.h>



#pragma mark - DiveSpotInfo

@interface DiveSpotInfo : NSObject

@property (nonatomic, strong) NSString *class_;
@property (nonatomic, strong) NSString *countryID;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *countryFlagBig;
@property (nonatomic, strong) NSString *countryFlagSmall;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *flavour;
@property (nonatomic, strong) NSString *fullPermalink;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;

@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSString *locationName;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *permaLink;

@property (nonatomic, strong) NSString *regionID;
@property (nonatomic, strong) NSString *regionName;

@property (nonatomic, strong) NSString *shakenID;
@property (nonatomic, strong) NSString *staticMap;
@property (nonatomic, strong) NSString *withinCountryBounds;


- (id)initWithDictionary:(NSDictionary *)data;
- (NSDictionary *)getDataDictionary;
- (id) initWithEmptySpot;


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

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic) BOOL isLocal;

- (id)initWithDictionary:(NSDictionary *)data;
- (NSDictionary*)getDataDictionary;
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
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;

- (id)initWithDictionary:(NSDictionary *)data;
- (NSDictionary*)getDataDictionary;

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
- (NSString*) surfaceValueWithUnit;
- (NSString*) bottomValueWithUnit;


@end



#pragma mark - DiveWeight

@interface DiveWeight : NSObject

@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *value;

- (id)initWithDictionary:(NSDictionary *)data;
- (NSString*)valueWithUnit;

@end

#pragma mark - SpotSearchResult

@interface SpotSearchResult : NSObject

@property (nonatomic, strong) DiveSpotInfo *spotInfo;
@property (nonatomic, strong) NSString     *ID;
@property (nonatomic, strong) NSString     *name;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - DiveReview

@interface DiveReview : NSObject

@property (nonatomic) int  overall;
@property (nonatomic) int  difficulty;
@property (nonatomic) int  marine;
@property (nonatomic) int  bigfish;
@property (nonatomic) int  wreck;

- (id)initWithDictionary:(NSDictionary *)data;
- (NSDictionary*)getDataDictionary;
- (BOOL)isInculdeReview;


@end

#pragma mark - SafetyStop

@interface SafetyStop : NSObject

@property (nonatomic, strong) NSString      *depth;
@property (nonatomic, strong) NSString      *depthUnit;
@property (nonatomic, strong) NSString      *duration;

@end

#pragma mark - DiveTank

@interface DiveTank : NSObject

@property (nonatomic)         NSInteger diveID;
@property (nonatomic, strong) NSString *gas;
@property (nonatomic, strong) NSString *gasType;
@property (nonatomic)         NSInteger he;
@property (nonatomic)         NSInteger ID;
@property (nonatomic, strong) NSString *material;
@property (nonatomic)         NSInteger multitank;
@property (nonatomic)         NSInteger n2;
@property (nonatomic)         NSInteger o2;
@property (nonatomic)         NSInteger order;
@property (nonatomic)         double    pEnd;
@property (nonatomic, strong) NSString *pEndUnit;
@property (nonatomic)         double    pEndValue;
@property (nonatomic)         double    pStart;
@property (nonatomic, strong) NSString *pStartUnit;
@property (nonatomic)         double    pStartValue;
@property (nonatomic)         NSInteger timeStart;
@property (nonatomic)         double    volume;
@property (nonatomic, strong) NSString *volumeUnit;
@property (nonatomic)         double    volumeValue;

- (id) initWithDictionary:(NSDictionary *)data;
- (NSDictionary*)getDataDictionary;

@end
#pragma mark - Buddy

@interface Buddy : NSObject

@property (nonatomic)         NSInteger ID;
@property (nonatomic, strong) NSString *class_;
@property (nonatomic, strong) NSString *fullPermaLink;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *permaLink;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *pictureLarge;
@property (nonatomic, strong) NSString *pictureSmall;
@property (nonatomic, strong) NSString *shakenID;
@property (nonatomic, strong) NSString *vanityURL;
@property (nonatomic, strong) NSString *email;
@property (nonatomic)         BOOL      notify;
@property (nonatomic, strong) NSString *fbID;

@property (nonatomic, strong) NSString *pictureURLString;

- (id) initWithDictionary:(NSDictionary *)data;

- (NSDictionary *) getDataDictionary;

@end

#pragma mark - DiveInformation

@interface DiveInformation : NSObject

@property (nonatomic, strong) NSString      *ID;
@property (nonatomic, strong) NSString      *shakenID;
@property (nonatomic, strong) NSString      *maxDepth;
@property (nonatomic, strong) NSString      *maxDepthUnit;
@property (nonatomic, strong) NSString      *date;
@property (nonatomic, strong) NSString      *time;
@property (nonatomic, strong) NSString      *imageURL;
@property (nonatomic, strong) NSString      *guideName;
@property (nonatomic, strong) NSString      *tripName;
@property (nonatomic, strong) NSString      *duration;
@property (nonatomic, strong) DiveSpotInfo  *spotInfo;
@property (nonatomic, strong) NSMutableArray *divePictures;
@property (nonatomic, strong) DiveShop      *diveShop;
@property (nonatomic, strong) NSString      *visibility;
@property (nonatomic, strong) NSString      *water;
@property (nonatomic, strong) Temp          *temp;
@property (nonatomic, strong) NSArray       *diveType;
@property (nonatomic, strong) NSString      *note;
@property (nonatomic, strong) DiveWeight    *weight;
@property (nonatomic, strong) NSString      *number;
@property (nonatomic, strong) NSString      *current;
@property (nonatomic, strong) NSString      *altitude;
@property (nonatomic, strong) NSString      *privacy;
@property (nonatomic, strong) DiveReview      *review;
@property (nonatomic, strong) NSArray      *SafetyStops;
@property (nonatomic, strong) NSMutableArray    *tanksUsed;
@property (nonatomic, strong) NSMutableArray    *buddies;
@property (nonatomic)         BOOL              isLocal;
@property (nonatomic, strong) NSString      *localID;

- (id)initWithDictionary:(NSDictionary *)data;
- (NSDictionary*)getDataDictionary;
- (NSString*) maxDepthValueWithUnit;

+ (NSString *) unitOfWeightWithValue:(NSString *)value defaultUnit:(NSString *)unit;

+ (NSString *) unitOfLengthWithValue:(NSString *)value defaultUnit:(NSString *)unit;



+ (NSString *) unitOfTempWithValue  :(NSString *)value defaultUnit:(NSString *)unit;
+ (NSString *) unitOfWeightWithValue:(NSString *)value defaultUnit:(NSString *)unit showUnit:(BOOL)flag;
+ (NSString *) unitOfLengthWithValue:(NSString *)value defaultUnit:(NSString *)unit showUnit:(BOOL)flag;
+ (NSString *) unitOfTempWithValue  :(NSString *)value defaultUnit:(NSString *)unit showUnit:(BOOL)flag;
+ (NSString*)convertInternationalFormatValue:(NSString*)string;




@end



