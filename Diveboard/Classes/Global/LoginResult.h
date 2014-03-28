//
//  UserData.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class DanData;
//@class QualificationElemet;
//@class Qualifications;
//@class StorageUsed;
//@class UserGear;
//@class UserInfomation;
//@class UnitOfDive;
//@class LoginResult;

@interface UserData : NSObject

@end



#pragma mark - DanData

@interface DanData : NSObject

@property (nonatomic, strong) NSArray  *address;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSArray  *birthPlace;
@property (nonatomic, strong) NSString *certificationLevel;
@property (nonatomic, strong) NSString *cigarette;
@property (nonatomic, strong) NSString *citizenShip;
@property (nonatomic, strong) NSString *conditions;
@property (nonatomic, strong) NSString *danID;
@property (nonatomic, strong) NSString *danPdeID;
@property (nonatomic, strong) NSString *dives12m;
@property (nonatomic, strong) NSString *dives5y;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstCertif;
@property (nonatomic, strong) NSArray  *heights;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSArray  *licenses;
@property (nonatomic, strong) NSString *medications;
@property (nonatomic, strong) NSString *mother;
@property (nonatomic, strong) NSArray  *names;
@property (nonatomic, strong) NSArray  *phoneHomes;
@property (nonatomic, strong) NSArray  *phoneWorks;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSArray  *weight;

- (id)initWithDictionary:(NSDictionary *)data;

@end


#pragma mark - Qualifications

@interface QualificationElemet : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *org;
@property (nonatomic, strong) NSString *title;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - Qualifications

@interface Qualifications : NSObject

@property (nonatomic, strong) NSMutableArray *featured;
@property (nonatomic, strong) NSMutableArray *other;

- (id)initWithDictionary:(NSDictionary *)data;

@end


#pragma mark - StorageUsed

@interface StorageUsed : NSObject

@property (nonatomic, strong) NSString *allPictures;
@property (nonatomic, strong) NSString *divePictures;
@property (nonatomic, strong) NSString *monthlyDivePictures;
@property (nonatomic, strong) NSString *orphanPictures;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - UserGear

@interface UserGear : NSObject

@property (nonatomic, strong) NSString *acquisition;
@property (nonatomic, strong) NSString *autoFeature;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *class_;
@property (nonatomic, strong) NSString *featured;
@property (nonatomic, strong) NSString *flavour;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lastRevision;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *reference;

- (id)initWithDictionary:(NSDictionary *)data;

@end


#pragma mark - UserInformation

@interface UserInfomation : NSObject

@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *adAlbumID;
@property (nonatomic, strong) NSArray  *advertisements;
@property (nonatomic, strong) NSMutableArray  *allDiveIDs;
@property (nonatomic, strong) NSString *autoPublic;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *class_;
@property (nonatomic, strong) DanData  *danData;
@property (nonatomic, strong) NSArray  *dbBuddyIDs;
@property (nonatomic, strong) NSArray  *extBuddyIDs;
@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) NSString *flavour;
@property (nonatomic, strong) NSString *fullPermaLink;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *permaLink;
@property (nonatomic, strong) NSString *pict;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *pictureLarge;
@property (nonatomic, strong) NSString *pictureSmall;
@property (nonatomic, strong) NSArray  *publicDiveIDs;
@property (nonatomic, strong) NSString *publicNbDives;
@property (nonatomic, strong) Qualifications *qualifications;
@property (nonatomic, strong) NSString *quotaLimit;
@property (nonatomic, strong) NSString *quotaType;
@property (nonatomic, strong) NSString *shakenID;
@property (nonatomic, strong) StorageUsed *storageUsed;
@property (nonatomic, strong) NSString *totalExtDives;
@property (nonatomic, strong) NSString *totalNbDives;
@property (nonatomic, strong) NSMutableArray  *userGears;
@property (nonatomic, strong) NSString *vanityURL;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - UnitOfDive

@interface UnitOfDive : NSObject

@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *pressure;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *weight;

- (id)initWithDictionary:(NSDictionary *)data;

@end

#pragma mark - LoginResult

@interface LoginResult : NSObject

@property (nonatomic, strong) NSString *expirations;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *anewAccount;
@property (nonatomic, strong) UnitOfDive *preferredUnits;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UnitOfDive *units;
@property (nonatomic, strong) UserInfomation *user;

- (id)initWithDictionary:(NSDictionary *)data;

@end
