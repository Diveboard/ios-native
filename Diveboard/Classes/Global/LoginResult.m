//
//  UserData.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "LoginResult.h"

#import "DiveInformation.h"

@implementation UserData

@end

#pragma mark - DanData

@implementation DanData

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            id address = [data objectForKey:@"address"];
            if (address != [NSNull null] && address) {
                self.address            = address;
            } else {
                self.address = nil;
            }
            
            self.alias              = getStringValue([data objectForKey:@"alias"]);
            self.birthday           = getStringValue([data objectForKey:@"birthday"]);
            self.birthPlace         = ([data objectForKey:@"birthplace"]);
            self.certificationLevel = getStringValue([data objectForKey:@"certif_level"]);
            self.cigarette          = getStringValue([data objectForKey:@"cigarette"]);
            self.citizenShip        = getStringValue([data objectForKey:@"citizenship"]);
            self.conditions         = getStringValue([data objectForKey:@"conditions"]);
            self.danID              = getStringValue([data objectForKey:@"dan_id"]);
            self.danPdeID           = getStringValue([data objectForKey:@"dan_pde_id"]);
            self.dives12m           = getStringValue([data objectForKey:@"dives_12m"]);
            self.dives5y            = getStringValue([data objectForKey:@"dives_5y"]);
            self.email              = getStringValue([data objectForKey:@"email"]);
            self.firstCertif        = getStringValue([data objectForKey:@"first_certif"]);
            self.heights            = ([data objectForKey:@"height"]);
            self.language           = getStringValue([data objectForKey:@"language"]);
            self.licenses           = ([data objectForKey:@"license"]);
            self.medications        = getStringValue([data objectForKey:@"medications"]);
            self.mother             = getStringValue([data objectForKey:@"mother"]);
            self.names              = ([data objectForKey:@"name"]);
            self.phoneHomes         = ([data objectForKey:@"phone_home"]);
            self.phoneWorks         = ([data objectForKey:@"phone_work"]);
            self.sex                = getStringValue([data objectForKey:@"sex"]);
            self.weight             = ([data objectForKey:@"weight"]);
            
        } else {
            self.address            = [[NSArray alloc] init];
            self.alias              = @"";
            self.birthday           = @"";
            self.birthPlace         = [[NSArray alloc] init];
            self.certificationLevel = @"";
            self.cigarette          = @"";
            self.citizenShip        = @"";
            self.conditions         = @"";
            self.danID              = @"";
            self.danPdeID           = @"";
            self.dives12m           = @"";
            self.dives5y            = @"";
            self.email              = @"";
            self.firstCertif        = @"";
            self.heights            = [[NSArray alloc] init];
            self.language           = @"";
            self.licenses           = [[NSArray alloc] init];
            self.medications        = @"";
            self.mother             = @"";
            self.names              = [[NSArray alloc] init];
            self.phoneHomes         = [[NSArray alloc] init];
            self.phoneWorks         = [[NSArray alloc] init];
            self.sex                = @"";
            self.weight             = [[NSArray alloc] init];

        }
    }
    return self;
}
@end


#pragma mark - QualificationElemet

@implementation QualificationElemet

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.date = getStringValue([data objectForKey:@"date"]);
            self.org  = getStringValue([data objectForKey:@"org"]);
            self.title = getStringValue([data objectForKey:@"title"]);
        } else {
            self.date = @"";
            self.org  = @"";
            self.title = @"";

        }
    }
    return self;
}

@end



#pragma mark - Qualifications

@implementation Qualifications

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.featured = [[NSMutableArray alloc] init];
            self.other    = [[NSMutableArray alloc] init];
            
            NSArray *featured = [data objectForKey:@"featured"];
            for (NSDictionary *featuredElem in featured) {
                [self.featured addObject:[[QualificationElemet alloc] initWithDictionary:featuredElem]];
            }
            
            NSArray *other = [data objectForKey:@"other"];
            for (NSDictionary *otherElem in other) {
                [self.featured addObject:[[QualificationElemet alloc] initWithDictionary:otherElem]];
            }
        } else {
            self.featured = [[NSMutableArray alloc] init];
            self.other    = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

@end



#pragma mark - StorageUsed

@implementation StorageUsed

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.allPictures = getStringValue([data objectForKey:@"all_pictures"]);
            self.divePictures = getStringValue([data objectForKey:@"dive_pictures"]);
            self.monthlyDivePictures = getStringValue([data objectForKey:@"monthly_dive_pictures"]);
            self.orphanPictures = getStringValue([data objectForKey:@"orphan_pictures"]);
        } else {
            self.allPictures = @"";
            self.divePictures = @"";
            self.monthlyDivePictures = @"";
            self.orphanPictures = @"";
        }
    }
    return self;
}

@end



#pragma mark - UserGear

@implementation UserGear

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.acquisition = getStringValue([data objectForKey:@"acquisition"]);
            self.autoFeature = getStringValue([data objectForKey:@"auto_feature"]);
            self.category    = getStringValue([data objectForKey:@"category"]);
            self.class_      = getStringValue([data objectForKey:@"class"]);
            self.featured    = getStringValue([data objectForKey:@"featured"]);
            self.flavour     = getStringValue([data objectForKey:@"flavour"]);
            self.ID          = getStringValue([data objectForKey:@"id"]);
            self.lastRevision = getStringValue([data objectForKey:@"last_revision"]);
            self.manufacturer = getStringValue([data objectForKey:@"manufacturer"]);
            self.model       = getStringValue([data objectForKey:@"model"]);
            self.reference   = getStringValue([data objectForKey:@"reference"]);
        } else {
            self.acquisition = @"";
            self.autoFeature = @"";
            self.category    = @"";
            self.class_      = @"";
            self.featured    = @"";
            self.flavour     = @"";
            self.ID          = @"";
            self.lastRevision = @"";
            self.manufacturer = @"";
            self.model       = @"";
            self.reference   = @"";

        }
    }
    return self;
}

@end


#pragma mark - UserInformation

@implementation UserInfomation

- (id)initWithDictionary:(NSDictionary *)data;
{
    self = [super init];
    NSLog(@"%@",data);
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.about          = getStringValue([data objectForKey:@"about"]);
            self.adAlbumID      = getStringValue([data objectForKey:@"ad_album_id"]);
            self.advertisements = ([data objectForKey:@"advertisements"]);
            
            if ([data objectForKey:@"all_dive_ids"]) {
                self.allDiveIDs     = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"all_dive_ids"]];
            }
            else {
                self.allDiveIDs = [[NSMutableArray alloc] init];
            }
            
            self.autoPublic     = getStringValue([data objectForKey:@"auto_public"]);
            self.city           = getStringValue([data objectForKey:@"city"]);
            self.countryCode    = getStringValue([data objectForKey:@"country_code"]);
            self.countryName    = getStringValue([data objectForKey:@"country_name"]);
            
            self.class_         = getStringValue([data objectForKey:@"class"]);
            self.danData        = [[DanData alloc] initWithDictionary:[data objectForKey:@"dan_data"]];
            self.dbBuddyIDs     = [data objectForKey:@"db_buddy_ids"];
            self.extBuddyIDs    = [data objectForKey:@"ext_buddy_ids"];
            self.fbID           = getStringValue([data objectForKey:@"fb_id"]);
            self.flavour        = getStringValue([data objectForKey:@"flavour"]);
            self.fullPermaLink  = getStringValue([data objectForKey:@"full_permalink"]);
            self.ID             = getStringValue([data objectForKey:@"id"]);
//            [BugSenseController setUserIdentifier:self.ID];
            self.lat            = getStringValue([data objectForKey:@"lat"]);
            self.lng            = getStringValue([data objectForKey:@"lng"]);
            self.location       = getStringValue([data objectForKey:@"location"]);
            self.nickName       = getStringValue([data objectForKey:@"nickname"]);
            self.permaLink      = getStringValue([data objectForKey:@"permalink"]);
            self.pict           = getStringValue([data objectForKey:@"pict"]);
            self.picture        = getStringValue([data objectForKey:@"picture"]);
            self.pictureLarge   = getStringValue([data objectForKey:@"picture_large"]);
            self.pictureSmall   = getStringValue([data objectForKey:@"picture_small"]);
            
            if ([data objectForKey:@"public_dive_ids"]) {
                self.publicDiveIDs     = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"public_dive_ids"]];
            }
            else {
                self.publicDiveIDs = [[NSMutableArray alloc] init];
            }

            self.publicNbDives  = [data objectForKey:@"public_nb_dives"];
            self.qualifications = [[Qualifications alloc] initWithDictionary:[data objectForKey:@"qualifications"]];
            self.quotaLimit     = getStringValue([data objectForKey:@"quota_limit"]);
            self.quotaType      = getStringValue([data objectForKey:@"quota_type"]);
            self.shakenID       = getStringValue([data objectForKey:@"shaken_id"]);
            self.storageUsed    = [[StorageUsed alloc] initWithDictionary:[data objectForKey:@"storage_used"]];
            self.totalExtDives  = [data objectForKey:@"total_ext_dives"];
            self.totalNbDives   = [data objectForKey:@"total_nb_dives"];
            self.userGears      = [[NSMutableArray alloc] init];
            self.vanityURL      = getStringValue([data objectForKey:@"vanity_url"]);
            self.adminRight     = getStringValue([data objectForKey:@"admin_rights"]);
            
            NSArray *userGears  = [data objectForKey:@"user_gears"];
            for (NSDictionary *elem in userGears) {
                [self.userGears addObject:[[UserGear alloc] initWithDictionary:elem]];
            }
            
            
            if ([data objectForKey:@"wallet_picture_ids"]) {
                
                self.walletPictureIDs     = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"wallet_picture_ids"]];
            }
            else {
                self.walletPictureIDs = [[NSMutableArray alloc] init];
            }
            
            self.walletPictures = [[NSMutableArray alloc] init];
            NSArray* arrWallet = [data objectForKey:@"wallet_pictures"];
            
            for (NSDictionary* elem in arrWallet) {

                [self.walletPictures addObject:[[DivePicture alloc] initWithDictionary:elem]];
            }
            
            
            
        }
        
    }
    return self;
}

- (NSMutableArray *)allDiveIDs
{
    if ([AppManager sharedManager].currentSudoID > 0) {
        return _publicDiveIDs;
    }
    else {
        return _allDiveIDs;
    }
}

- (NSDictionary *)getDataDictionary{
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:self.ID forKey:@"id"];

    [dataDic setObject:self.walletPictureIDs forKey:@"wallet_picture_ids"];
    NSMutableArray* arrWallet = [[NSMutableArray alloc] init];
    
    for (DivePicture* divePicture in self.walletPictures) {
        
        
        [arrWallet addObject:[divePicture getDataDictionary]];
        
    }
    
    [dataDic setObject:arrWallet forKey:@"wallet_pictures"];

    
    return dataDic;
}

@end

#pragma mark - UnitOfDive

@implementation UnitOfDive

- (id)initWithDictionary:(NSDictionary *)data;
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.distance = getStringValue([data objectForKey:@"distance"]);
            self.pressure = getStringValue([data objectForKey:@"pressure"]);
            self.temperature = getStringValue([data objectForKey:@"temperature"]);
            self.weight   = getStringValue([data objectForKey:@"weight"]);
        }
    }
    return self;
}

-(NSDictionary *)getDataDictionary{
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    
    [dataDic setObject:self.distance forKey:@"distance"];
    [dataDic setObject:self.pressure forKey:@"pressure"];
    [dataDic setObject:self.temperature forKey:@"temperature"];
    [dataDic setObject:self.weight forKey:@"weight"];
    
    return dataDic;
}
@end


#pragma mark - LoginResult

@interface LoginResult()
{
    UserInfomation *masterUser;
    UserInfomation *sudoUser;
}

@end

@implementation LoginResult

- (id)initWithDictionary:(NSDictionary *)data;
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.expirations = getStringValue([data objectForKey:@"expiration"]);
            self.ID          = getStringValue([data objectForKey:@"id"]);
            self.anewAccount  = getStringValue([data objectForKey:@"new_account"]);
            self.preferredUnits = [[UnitOfDive alloc] initWithDictionary:[data objectForKey:@"preferred_units"]];
            self.token       = getStringValue([data objectForKey:@"token"]);
            self.units       = [[UnitOfDive alloc] initWithDictionary:[data objectForKey:@"units"]];
//            self.user        = [[UserInfomation alloc] initWithDictionary:[data objectForKey:@"user"]];
            masterUser       = [[UserInfomation alloc] initWithDictionary:[data objectForKey:@"user"]];
        }
    }
    return self;
}

-(NSDictionary *)getDataDictionary{
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];

//    [dataDic setObject:self.expirations forKey:@"expiration"];
//    
//    [dataDic setObject:self.ID forKey:@"id"];
//    
//    [dataDic setObject:self.anewAccount forKey:@"new_account"];
//    
//    [dataDic setObject:[self.preferredUnits getDataDictionary]  forKey:@"preferred_units"];
//    
//    [dataDic setObject:self.token forKey:@"token"];
//    
//    [dataDic setObject:[self.units getDataDictionary] forKey:@"units"];
//    
//    //            self.user        = [[UserInfomation alloc] initWithDictionary:[data objectForKey:@"user"]];
//    masterUser       = [[UserInfomation alloc] initWithDictionary:[data objectForKey:@"user"]];
//    [dataDic setObject:@"" forKey:@"user"];
    
    return dataDic;
}

- (UserInfomation *)user{
    if ([AppManager sharedManager].currentSudoID > 0) {
        return sudoUser;
    }
    else {
        return masterUser;
    }
}

- (void)setUser:(UserInfomation *)user
{
    if ([AppManager sharedManager].currentSudoID > 0) {
        sudoUser = user;
    }
}

@end

