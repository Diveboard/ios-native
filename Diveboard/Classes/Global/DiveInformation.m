//
//  DiveInformation.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveInformation.h"

#pragma mark - DiveSpotInfo

@implementation DiveSpotInfo

-(id)initWithEmptySpot
{

    self = [super init];
    
    if (self) {
        
        self.class_             = @"Spot";
        self.countryID          = @"";
        self.countryCode        = @"BLANK";
        self.countryFlagBig     = @"http://stage.diveboard.com/img/flags/hd/blank.png";
        self.countryFlagSmall   = @"http://stage.diveboard.com/img/flags/blank.gif";
        self.countryName        = @"";
        self.flavour            = @"public";
        self.fullPermalink      = @"http://stage.diveboard.com/explore/spots/country/new-location-L3eegT/new-dive-S3eegT";
        self.ID                 = @"1";
        self.lat                = @"0";
        self.lng                = @"0";
        self.locationID         = @"";
        self.locationName       = @"New Location";
        self.name               = @"New Dive";
        self.permaLink          = @"/explore/spots/country/new-location-L3eegT/new-dive-S3eegT";
        self.regionID           = @"";
        self.regionName         = @"Region/Sea";
        self.shakenID           = @"";
        self.staticMap          = @"http://maps.google.com/maps/api/staticmap?center=0.0,0.0&zoom=0&size=128x128&maptype=hybrid&sensor=false&format=jpg";
        self.withinCountryBounds = @"0";
        
    }
    
    return self;
}
- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (data && ![data isEqual:[NSNull null]]) {
            self.class_             = getStringValue([data objectForKey:@"class"]);
            
            self.countryID        = getStringValue([data objectForKey:@"country_id"]);
            self.countryCode        = getStringValue([data objectForKey:@"country_code"]);
            self.countryFlagBig     = getStringValue([data objectForKey:@"country_flag_big"]);
            self.countryFlagSmall   = getStringValue([data objectForKey:@"country_flag_small"]);
            self.countryName        = getStringValue([data objectForKey:@"country_name"]);
            if ([self.countryName isEqualToString:@""]) {
                self.countryName        = getStringValue([data objectForKey:@"cname"]);
            }
            self.flavour            = getStringValue([data objectForKey:@"flavour"]);
            self.fullPermalink      = getStringValue([data objectForKey:@"fullpermalink"]);
            self.ID                 = getStringValue([data objectForKey:@"id"]);
            self.lat                = getStringValue([data objectForKey:@"lat"]);
            self.lng                = getStringValue([data objectForKey:@"lng"]);
            
            if ([self.lng isEqualToString:@""]) {
                self.lng        = getStringValue([data objectForKey:@"long"]);
            }
            

            self.locationName       = getStringValue([data objectForKey:@"location_name"]);
            
            if ([self.locationName isEqualToString:@""]) {
                self.locationName        = getStringValue([data objectForKey:@"location"]);
            }
            
            self.locationID = getStringValue([data objectForKey:@"location_id"]);
            
            
            
            self.name               = getStringValue([data objectForKey:@"name"]);
            self.permaLink          = getStringValue([data objectForKey:@"permalink"]);
            
            self.regionName         = getStringValue([data objectForKey:@"region_name"]);
            
            if ([self.regionName isEqualToString:@""]) {
                self.regionName        = getStringValue([data objectForKey:@"region"]);
            }
            
            self.regionID = getStringValue([data
                                            objectForKey:@"region_id"]);
            
            
            self.shakenID           = getStringValue([data objectForKey:@"shaken_id"]);
            self.staticMap          = getStringValue([data objectForKey:@"staticmap"]);
            self.withinCountryBounds = getStringValue([data objectForKey:@"within_country_bounds"]);
        } else {
            
            
            self.class_             = @"";
            self.countryID          = @"";
            self.countryCode        = @"";
            self.countryFlagBig     = @"";
            self.countryFlagSmall   = @"";
            self.countryName        = @"";
            self.flavour            = @"";
            self.fullPermalink      = @"";
            self.ID                 = @"";
            self.lat                = @"";
            self.lng                = @"";
            self.locationName       = @"";
            self.locationID         = @"";
            self.name               = @"";
            self.permaLink          = @"";
            self.regionName         = @"";
            self.regionID           = @"";
            self.shakenID           = @"";
            self.staticMap          = @"";
            self.withinCountryBounds = @"";
            

        }
        
    }
    return self;
}
-(NSDictionary *)getDataDictionary{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:self.class_ forKey:@"class"];
    [dic setObject:self.countryID forKey:@"country_id"];
    [dic setObject:self.countryCode forKey:@"country_code"];
    [dic setObject:self.countryFlagBig forKey:@"country_flag_big"];
    [dic setObject:self.countryFlagSmall forKey:@"country_flag_small"];
    [dic setObject:self.countryName forKey:@"country_name"];
    [dic setObject:self.flavour forKey:@"flavour"];
    [dic setObject:self.fullPermalink forKey:@"fullpermalink"];
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:self.ID forKey:@"id"];
    
    }
    
    [dic setObject:self.lat forKey:@"lat"];
    [dic setObject:self.lng forKey:@"lng"];
    
    [dic setObject:[NSString stringWithFormat:@"%@",self.locationID] forKey:@"location_id"];
    [dic setObject:self.locationName forKey:@"location_name"];
    [dic setObject:self.name forKey:@"name"];
    [dic setObject:self.permaLink forKey:@"permalink"];

    [dic setObject:self.regionID forKey:@"region_id"];
    [dic setObject:self.regionName forKey:@"region_name"];
    [dic setObject:self.shakenID forKey:@"shaken_id"];
    [dic setObject:self.staticMap forKey:@"staticmap"];
    [dic setObject:self.withinCountryBounds forKey:@"within_country_bounds"];
    
    return dic;
    
}
@end

@implementation DivePicture

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.class_             = getStringValue([data objectForKey:@"class"]);
            self.createdAt          = getStringValue([data objectForKey:@"created_at"]);
            self.fullRedirectLink   = getStringValue([data objectForKey:@"full_redirect_link"]);
            self.flavour            = getStringValue([data objectForKey:@"flavour"]);
            self.fullPermaLink      = getStringValue([data objectForKey:@"fullpermalink"]);
            self.ID                 = getStringValue([data objectForKey:@"id"]);
            self.largeURL           = getStringValue([data objectForKey:@"large"]);
            self.mediumURL          = getStringValue([data objectForKey:@"medium"]);
            self.smallURL           = getStringValue([data objectForKey:@"small"]);
            self.media              = getStringValue([data objectForKey:@"media"]);
            self.permaLink          = getStringValue([data objectForKey:@"permalink"]);
            self.notes              = getStringValue([data objectForKey:@"notes"]);
            self.player             = getStringValue([data objectForKey:@"player"]);
            self.thumbnail          = getStringValue([data objectForKey:@"thumbnail"]);
            
            self.isLocal            = [[data objectForKey:@"is_local"] boolValue];
            
            if (![[DiveOfflineModeManager sharedManager] isExistImageWithURL:self.largeURL]) {
                
                
                if (![[AppManager sharedManager].remainingPictures containsObject:self.largeURL]) {
                    
                    [[AppManager sharedManager].remainingPictures addObject:self.largeURL];
                    
                }
                
            }
            if (![[DiveOfflineModeManager sharedManager] isExistImageWithURL:self.mediumURL]) {
                
                if (![[AppManager sharedManager].remainingPictures containsObject:self.mediumURL]) {
                
                    [[AppManager sharedManager].remainingPictures addObject:self.mediumURL];
                }
                
            }
            
            if (![[DiveOfflineModeManager sharedManager] isExistImageWithURL:self.smallURL]) {
                
                if (![[AppManager sharedManager].remainingPictures containsObject:self.smallURL]) {
                    
                    [[AppManager sharedManager].remainingPictures addObject:self.smallURL];
                    
                }
                
            }
            
            
            
        } else {
            self.class_             = @""; // getStringValue([data objectForKey:@"class"]);
            self.createdAt          = @""; //getStringValue([data objectForKey:@"country_code"]);
            self.fullRedirectLink   = @""; //getStringValue([data objectForKey:@"country_flag_big"]);
            self.flavour            = @""; //getStringValue([data objectForKey:@"country_flag_small"]);
            self.fullPermaLink      = @""; //getStringValue([data objectForKey:@"country_name"]);
            self.ID                 = @""; //getStringValue([data objectForKey:@"flavure"]);
            self.largeURL           = @""; //getStringValue([data objectForKey:@"fullpermalink"]);
            self.mediumURL          = @""; //getStringValue([data objectForKey:@"id"]);
            self.smallURL           = @""; //getStringValue([data objectForKey:@"lat"]);
            self.media              = @""; //getStringValue([data objectForKey:@"lng"]);
            self.permaLink          = @""; //getStringValue([data objectForKey:@"location_name"]);
            self.notes              = @""; //getStringValue([data objectForKey:@"name"]);
            self.player             = @""; //getStringValue([data objectForKey:@"permalink"]);
            self.thumbnail          = @""; //getStringValue([data objectForKey:@"region_name"]);
            self.isLocal            = NO;
        }
     
    }
    return self;
}

-(NSDictionary *)getDataDictionary{

    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:self.class_ forKey:@"class"];
    [dic setObject:self.createdAt forKey:@"created_at"];
    [dic setObject:self.fullRedirectLink forKey:@"full_redirect_link"];
    [dic setObject:self.flavour forKey:@"flavour"];
    [dic setObject:self.fullPermaLink forKey:@"fullpermalink"];
    [dic setObject:self.ID forKey:@"id"];
    [dic setObject:self.largeURL forKey:@"large"];
    [dic setObject:self.mediumURL forKey:@"medium"];
    [dic setObject:self.smallURL forKey:@"small"];
    [dic setObject:self.media forKey:@"media"];
    [dic setObject:self.permaLink forKey:@"permalink"];
    [dic setObject:self.notes forKey:@"notes"];
    [dic setObject:self.player forKey:@"player"];
    [dic setObject:self.thumbnail forKey:@"thumbnail"];
    [dic setObject:[NSNumber numberWithBool:self.isLocal] forKey:@"is_local"];

    return dic;
    
    
}
-(NSString *)urlString{
    
    if ([AppManager sharedManager].userSettings.pictureQuality == UserSettingPictureQualityTypeHigh) {
        
        return self.largeURL;
    }else{
        
        return self.mediumURL;
    }
}

@end



@implementation DiveShop

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (![data isEqual:[NSNull null]]) {
            self.ID             = getStringValue([data objectForKey:@"id"]);
            self.name           = getStringValue([data objectForKey:@"name"]);
            self.address        = getStringValue([data objectForKey:@"address"]);
            self.city           = getStringValue([data objectForKey:@"city"]);
            self.email          = getStringValue([data objectForKey:@"email"]);
            self.fullPermalink  = getStringValue([data objectForKey:@"fullpermalink"]);
            self.logoUrl        = getStringValue([data objectForKey:@"logo_url"]);
            self.web            = getStringValue([data objectForKey:@"web"]);
            self.shakenID       = getStringValue([data objectForKey:@"shaken_id"]);
            self.lat            = getStringValue([data objectForKey:@"lat"]);
            self.lng             = getStringValue([data objectForKey:@"lng"]);
            
        } else {
            self.ID             = @""; //getStringValue([data objectForKey:@"id"]);
            self.name           = @""; //getStringValue([data objectForKey:@"name"]);
            self.address        = @""; //= getStringValue([data objectForKey:@"address"]);
            self.city           = @""; //= getStringValue([data objectForKey:@"city"]);
            self.email          = @""; //= getStringValue([data objectForKey:@"email"]);
            self.fullPermalink  = @""; //= getStringValue([data objectForKey:@"fullpermalink"]);
            self.logoUrl        = @""; //= getStringValue([data objectForKey:@"logo_url"]);
            self.web            = @""; // = getStringValue([data objectForKey:@"web"]);
            self.shakenID       = @""; // = getStringValue([data objectForKey:@"shaken_id"]);
            self.lat            = @"";
            self.lng            = @"";

        }
        
    }
    return self;

}

-(NSDictionary *)getDataDictionary{

    NSMutableDictionary*  dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:self.ID forKey:@"id"];
    [dataDic setObject:self.name forKey:@"name"];
    [dataDic setObject:self.address forKey:@"address"];
    [dataDic setObject:self.city forKey:@"city"];
    [dataDic setObject:self.email forKey:@"email"];
    [dataDic setObject:self.fullPermalink forKey:@"fullpermalink"];
    [dataDic setObject:self.logoUrl forKey:@"logo_url"];
    [dataDic setObject:self.web forKey:@"web"];
    [dataDic setObject:self.shakenID forKey:@"shaken_id"];
    [dataDic setObject:self.lat forKey:@"lat"];
    [dataDic setObject:self.lng forKey:@"lng"];
    
    return dataDic;
    
}

@end



@implementation Temp

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.bottom         = getStringValue([data objectForKey:@"temp_bottom"]);
        self.bottomUnit     = getStringValue([data objectForKey:@"temp_bottom_unit"]);
        self.bottomValue    = getStringValue([data objectForKey:@"temp_bottom_value"]);
        self.surface        = getStringValue([data objectForKey:@"temp_surface"]);
        self.surfaceUnit    = getStringValue([data objectForKey:@"temp_surface_unit"]);
        self.surfaceValue   = getStringValue([data objectForKey:@"temp_surface_value"]);
    }
    return self;

}
-(NSString*) bottomValueWithUnit{
    
    NSString* result = @"";
    if (![self.bottomValue isEqualToString:@""]) {
        
        if ([[self.bottomUnit lowercaseString] isEqualToString:@"c"]) {
            
            result = [NSString stringWithFormat:@"%.2f °C", [self.bottomValue floatValue]];
            
        }else{
            result = [NSString stringWithFormat:@"%.2f °F", [self.bottomValue floatValue]];
            
        }
        
    }
    return result;
    
}
-(NSString*) surfaceValueWithUnit{
    
    NSString* result = @"";
    if (![self.surfaceValue isEqualToString:@""]) {
        
        if ([[self.surfaceUnit lowercaseString] isEqualToString:@"c"]) {
            
            result = [NSString stringWithFormat:@"%.2f °C", [self.surfaceValue floatValue]];
            
        }else{
            result = [NSString stringWithFormat:@"%.2f °F", [self.surfaceValue floatValue]];
            
        }
        
    }
    return result;
    
}
@end

@implementation DiveWeight

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.weight         = getStringValue([data objectForKey:@"weights"]);
        self.unit           = getStringValue([data objectForKey:@"weights_unit"]);
        self.value          = getStringValue([data objectForKey:@"weights_value"]);
    }
    return self;

    
}

-(NSString *)valueWithUnit{
    
    NSString* result = @"";
    
    if ([self.unit isEqualToString:@"kg"]) {
        
        result = [NSString stringWithFormat:@"%.1f kg", [self.value floatValue]];
        
    }else{
        
        result = [NSString stringWithFormat:@"%.1f lbs", [self.value floatValue]];
        
    }
    
    return result;
    
}
@end


@implementation SpotSearchResult

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.spotInfo = [[DiveSpotInfo alloc] initWithDictionary:[data objectForKey:@"data"]];
        self.ID       = getStringValue([data objectForKey:@"id"]);
        self.name     = getStringValue([data objectForKey:@"name"]);
    }
    return self;

}

@end

@implementation DiveReview

-(id)initWithDictionary:(NSDictionary *)data{
    
    self = [super init];
    
    if (self) {
    
        self.overall = [data objectForKey:@"overall"] ? [[data objectForKey:@"overall"] intValue] : 0;
        self.difficulty = [data objectForKey:@"difficulty"] ? [[data objectForKey:@"difficulty"] intValue] : 0;
        self.marine = [data objectForKey:@"marine"] ? [[data objectForKey:@"marine"] intValue] : 0;
        self.bigfish = [data objectForKey:@"bigfish"] ? [[data objectForKey:@"bigfish"] intValue] : 0;
        self.wreck = [data objectForKey:@"wreck"] ? [[data objectForKey:@"wreck"] intValue] : 0;
        
    }
    
    return self;

}
-(NSDictionary *)getDataDictionary{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (self.overall > 0) {
        [dic setObject:[NSNumber numberWithInt:self.overall] forKey:@"overall"];
        
    }
    if (self.difficulty > 0) {
        
        [dic setObject:[NSNumber numberWithInt:self.difficulty] forKey:@"difficulty"];
    }
    
    if (self.marine > 0 ) {
        [dic setObject:[NSNumber numberWithInt:self.marine] forKey:@"marine"];
        
    }
    
    if (self.bigfish) {

        [dic setObject:[NSNumber numberWithInt:self.bigfish] forKey:@"bigfish"];
        
    }
    if (self.wreck) {
        
        [dic setObject:[NSNumber numberWithInt:self.wreck] forKey:@"wreck"];
        
    }
    
    return dic;
}
- (BOOL)isInculdeReview{
    
    int val = self.overall + self.difficulty+self.marine+self.bigfish+self.wreck;
    
    if (val > 0) {
        return YES;
    }else{
        return NO;
    }
}

@end

@implementation SafetyStop



@end

@implementation DiveTank

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.diveID      = getIntegerValue([data objectForKey:@"dive_id"]);
        self.gas         = getStringValue([data objectForKey:@"gas"]);
        self.gasType     = getStringValue([data objectForKey:@"gas_type"]);
        self.he          = getIntegerValue([data objectForKey:@"he"]);
        self.ID          = getIntegerValue([data objectForKey:@"id"]);
        self.material    = getStringValue([data objectForKey:@"material"]);
        self.multitank   = getIntegerValue([data objectForKey:@"multitank"]);
        self.n2          = getIntegerValue([data objectForKey:@"n2"]);
        self.o2          = getIntegerValue([data objectForKey:@"o2"]);
        self.order       = getIntegerValue([data objectForKey:@"order"]);
        self.pEnd        = getDoubleValue([data objectForKey:@"p_end"]);
        self.pEndUnit    = getStringValue([data objectForKey:@"p_end_unit"]);
        self.pEndValue   = getDoubleValue([data objectForKey:@"p_end_value"]);
        self.pStart      = getDoubleValue([data objectForKey:@"p_start"]);
        self.pStartUnit  = getStringValue([data objectForKey:@"p_start_unit"]);
        self.pStartValue = getDoubleValue([data objectForKey:@"p_start_value"]);
        self.timeStart   = getIntegerValue([data objectForKey:@"time_start"]);
        self.volume      = getDoubleValue([data objectForKey:@"volume"]);
        self.volumeUnit  = getStringValue([data objectForKey:@"volume_unit"]);
        self.volumeValue = getDoubleValue([data objectForKey:@"volume_value"]);
        
    }
    return self;
}
-(id)init{
    self = [super init];
    
    if (self) {
        
        self.diveID      = 0;
        self.gas         = @"";
        self.gasType     = @"";
        self.he          = 0;
        self.ID          = 0;
        self.material    = @"";
        self.multitank   = 1;
        self.n2          = 0;
        self.o2          = 0;
        self.order       = 0;
        self.pEnd        = 0;
        self.pEndUnit    = @"";
        self.pEndValue   = 0;
        self.pStart      = 0;
        self.pStartUnit  = @"";
        self.pStartValue = 0;
        self.timeStart   = 0;
        self.volume      = 0;
        self.volumeUnit  = @"";
        self.volumeValue = 0;
        
    }
    return  self;
}
- (NSDictionary *)getDataDictionary{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];

//    self.diveID      = getIntegerValue([data objectForKey:@"dive_id"]);
    [dic setObject:self.gas forKey:@"gas"];
    [dic setObject:self.gasType forKey:@"gas_type"];
    [dic setObject:[NSNumber numberWithInteger:self.he] forKey:@"he"];
//    self.ID          = getIntegerValue([data objectForKey:@"id"]);
    [dic setObject:self.material forKey:@"material"];
    [dic setObject:[NSNumber numberWithInteger:self.multitank] forKey:@"multitank"];
    [dic setObject:[NSNumber numberWithInteger:self.n2] forKey:@"n2"];
    [dic setObject:[NSNumber numberWithInteger:self.o2] forKey:@"o2"];
    [dic setObject:[NSNumber numberWithInteger:self.order] forKey:@"order"];
    [dic setObject:[NSNumber numberWithDouble:self.pEnd] forKey:@"p_end"];
    [dic setObject:self.pEndUnit forKey:@"p_end_unit"];
    [dic setObject:[NSNumber numberWithDouble:self.pEndValue] forKey:@"p_end_value"];
    [dic setObject:[NSNumber numberWithDouble:self.pStart] forKey:@"p_start"];
    [dic setObject:self.pStartUnit forKey:@"p_start_unit"];
    [dic setObject:[NSNumber numberWithDouble:self.pStartValue] forKey:@"p_start_value"];
    [dic setObject:[NSNumber numberWithInteger:self.timeStart] forKey:@"time_start"];
    [dic setObject:[NSNumber numberWithDouble:self.volume] forKey:@"volume"];
    [dic setObject:self.volumeUnit forKey:@"volume_unit"];
    [dic setObject:[NSNumber numberWithDouble:self.volumeValue] forKey:@"volume_value"];
    
    return dic;
}

@end

@implementation Buddy

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.class_         = getStringValue([data objectForKey:@"class"]);
        self.fullPermaLink  = getStringValue([data objectForKey:@"fullpermalink"]);
        self.ID             = getIntegerValue([data objectForKey:@"id"]);
        self.location       = getStringValue([data objectForKey:@"location"]);
        self.nickName       = getStringValue([data objectForKey:@"nickname"]);
        self.permaLink      = getStringValue([data objectForKey:@"permalink"]);
        self.picture        = getStringValue([data objectForKey:@"picture"]);
        self.pictureLarge   = getStringValue([data objectForKey:@"picture_large"]);
        self.pictureSmall   = getStringValue([data objectForKey:@"picture_small"]);
        self.shakenID       = getStringValue([data objectForKey:@"shaken_id"]);
        self.vanityURL      = getStringValue([data objectForKey:@"vanity_url"]);
        
//        self.notify         = [[data objectForKey:@"notify"] boolValue];;
        self.email          = getStringValue([data objectForKey:@"email"]);
        self.fbID           = getStringValue([data objectForKey:@"fb_id"]);
        
    }
    return self;
}

- (NSDictionary *)getDataDictionary
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    
    [data setObject:self.class_ forKey:@"class"];
    
    [data setObject:self.fullPermaLink forKey:@"fullpermalink"];
    
    if (self.ID > 0) {
        
        [data setObject:[NSNumber numberWithInteger:self.ID] forKey:@"id"];
        
    }
    
    [data setObject:self.location forKey:@"location"];
    
    [data setObject:self.nickName forKey:@"nickname"];
    
    [data setObject:self.permaLink forKey:@"permalink"];
    
    [data setObject:self.picture forKey:@"picture"];
    
    [data setObject:self.pictureLarge forKey:@"picture_large"];
    
    [data setObject:self.pictureSmall forKey:@"picture_small"];
    
    [data setObject:self.shakenID forKey:@"shaken_id"];
    
    [data setObject:self.vanityURL forKey:@"vanity_url"];
    
    if (self.notify) {
        
        [data setObject:@YES forKey:@"notify"];
    }
    
    [data setObject:self.email forKey:@"email"];
    
    [data setObject:self.fbID forKey:@"fb_id"];
    
    
    
    return data;
}

-(NSString *)pictureURLString{
    
    if ([AppManager sharedManager].userSettings.pictureQuality == UserSettingPictureQualityTypeHigh) {
        
        return self.pictureLarge;
    }else{
        
        return self.pictureSmall;
    }
    
    
}
@end

@implementation DiveInformation

- (id)initWithDictionary:(NSDictionary *)data
{
    
    
    self = [super init];
    
    if (self) {
        
        self.isLocal            = [[data objectForKey:@"is_local"] boolValue];
        self.localID            = getStringValue([data objectForKey:@"local_id"]);
        self.userID    = getStringValue([data objectForKey:@"user_id"]);
        self.ID       = getStringValue([data objectForKey:@"id"]);
        self.shakenID = getStringValue([data objectForKey:@"shaken_id"]);
        self.guideName = getStringValue([data objectForKey:@"guide"]);
        self.tripName = getStringValue([data objectForKey:@"trip_name"]);
        self.date     = getStringValue([data objectForKey:@"date"]);
        self.time     = getStringValue([data objectForKey:@"time"]);
        self.duration = getStringValue([data objectForKey:@"duration"]);
        
        self.fullPermaLink = getStringValue([data objectForKey:@"fullpermalink"]);
        
        NSMutableArray* arrSafetyStops = [[NSMutableArray alloc] init];
        NSString* strSafetyStops = getStringValue([data objectForKey:@"safetystops_unit_value"]);
        if ([data objectForKey:@"safetystops_unit_value"]) {
            
            NSData* data= [strSafetyStops dataUsingEncoding:NSUTF8StringEncoding];

            
            NSArray *safetyStoplist = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            
            for (NSArray* safetyStop in safetyStoplist) {
                
                SafetyStop* item = [[SafetyStop alloc] init];
                
                item.depth = getStringValue(safetyStop[0]);
                item.duration = getStringValue(safetyStop[1]);
                item.depthUnit = getStringValue(safetyStop[2]);
                [arrSafetyStops addObject:item];
            }
            
        }
        
        self.SafetyStops = arrSafetyStops;
        
        self.maxDepth = getStringValue([data objectForKey:@"maxdepth_value"]);
        self.maxDepthUnit = getStringValue([data objectForKey:@"maxdepth_unit"]);
        self.imageURL = getStringValue([data objectForKey:@"thumbnail_image_url"]);
        
        if (![[DiveOfflineModeManager sharedManager] isExistImageWithURL:self.imageURL]) {
            
            if (![[AppManager sharedManager].remainingPictures containsObject:self.imageURL]) {
                
                [[AppManager sharedManager].remainingPictures addObject:self.imageURL];
                
            }
            
        }

        
        
        NSString *myNickName = [[AppManager sharedManager].loginResult.user.nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *diveShakenID   = self.shakenID;
        
        NSString *graphThumbUrlString = [NSString stringWithFormat:@"%@/%@/%@/profile.png?g=mobile_v002&u=m", SERVER_URL, myNickName, diveShakenID];
        
        NSString *graphLargeUrlString = [NSString stringWithFormat:@"%@/%@/%@/profile.png?g=mobile_v003&u=m", SERVER_URL, myNickName, diveShakenID];
        
        
        
        if (![[DiveOfflineModeManager sharedManager] isExistImageWithURL:graphThumbUrlString]) {
            
            
            if (![[AppManager sharedManager].remainingPictures containsObject:graphThumbUrlString]) {
                
                [[AppManager sharedManager].remainingPictures addObject:graphThumbUrlString];
                
            }
            
        }
        
        if (![[DiveOfflineModeManager sharedManager] isExistImageWithURL:graphLargeUrlString]) {
            
            
            if (![[AppManager sharedManager].remainingPictures containsObject:graphLargeUrlString]) {
                
                [[AppManager sharedManager].remainingPictures addObject:graphLargeUrlString];
                
            }
            
        }
        
        
        self.spotInfo = [[DiveSpotInfo alloc] initWithDictionary:[data objectForKey:@"spot"]];
        NSArray *pics = [data objectForKey:@"pictures"];
        self.divePictures = [[NSMutableArray alloc] init];
        for (NSDictionary *elem in pics) {
            [self.divePictures addObject:[[DivePicture alloc] initWithDictionary:elem]];
        }
        
        self.diveShop = [[DiveShop alloc] initWithDictionary:[data objectForKey:@"shop"]];
        self.diveShop.picture = getStringValue([data objectForKey:@"shop_picture"]);
        self.visibility = getStringValue([data objectForKey:@"visibility"]);
        self.water      = getStringValue([data objectForKey:@"water"]);
        self.temp       = [[Temp alloc] initWithDictionary:data];

        self.diveType   = [[NSArray alloc] init];
        if ([data objectForKey:@"divetype"]) {
            
            self.diveType   = [data objectForKey:@"divetype"];
        }
        self.note       = getStringValue([data objectForKey:@"notes"]);
        self.number     = getStringValue([data objectForKey:@"number"]);
        self.current    = getStringValue([data objectForKey:@"current"]);
        self.altitude    = getStringValue([data objectForKey:@"altitude"]);
        self.privacy    = getStringValue([data objectForKey:@"privacy"]);
        
        if ([self.privacy isEqualToString:@""]) {
            self.privacy = @"0";
        }
        self.weight     = [[DiveWeight alloc] initWithDictionary:data];
        self.review     = [[DiveReview alloc] initWithDictionary:[data objectForKey:@"dive_reviews"]];
        
        NSArray *buddiesJson = [data objectForKey:@"buddies"];
        self.buddies    = [[NSMutableArray alloc] init];
        for (NSDictionary *elem in buddiesJson) {
            [self.buddies addObject:[[Buddy alloc] initWithDictionary:elem]];
        }
        
        
        NSArray *tanksJson = [data objectForKey:@"tanks"];
        self.tanksUsed = [[NSMutableArray alloc] init];
        for (NSDictionary *elem in tanksJson) {
            [self.tanksUsed addObject:[[DiveTank alloc] initWithDictionary:elem]];
        }
        
    }
    return self;
}


- (NSDictionary*)getDataDictionary
{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithBool:self.isLocal] forKey:@"is_local"];

    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:self.ID forKey:@"id"];
        
    }else{
        
        [dic setObject:self.userID forKey:@"user_id"];
        
    }
    
    if (![self.localID isEqualToString:@""]) {
        
        [dic setObject:self.localID forKey:@"local_id"];
        
    }
    
    if (![self.shakenID isEqualToString:@""]) {
        
        [dic setObject:self.shakenID forKey:@"shaken_id"];
        
    }
    
    if (![self.guideName isEqualToString:@""]) {
        
        [dic setObject:self.guideName forKey:@"guide"];
        
    }
    
    if (![self.tripName isEqualToString:@""]) {
        
        [dic setObject:self.tripName forKey:@"trip_name"];
        
    }
    
    if (![self.date isEqualToString:@""]) {
        
        [dic setObject:self.date forKey:@"date"];
        
    }
    
    if (![self.time isEqualToString:@""]) {
        
        [dic setObject:self.time forKey:@"time"];
        
    }
    
    [dic setObject:[NSString stringWithFormat:@"%@T%@Z", self.date, self.time] forKey:@"time_in"];
    
    if (![self.duration isEqualToString:@""]) {
        
        [dic setObject:self.duration forKey:@"duration"];
        
    }
    

    NSMutableArray* arrSafetyStops = [[NSMutableArray alloc] init];
    
        for (SafetyStop* safetyStop in self.SafetyStops) {
            
            NSArray* arr = @[safetyStop.depth,safetyStop.duration,safetyStop.depthUnit];
            
            [arrSafetyStops addObject:arr];
        }

    
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrSafetyStops
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:jsonString forKey:@"safetystops"];
        [dic setObject:jsonString forKey:@"safetystops_unit_value"];
        
    }else{
        
        if (arrSafetyStops.count > 0) {
            
            [dic setObject:jsonString forKey:@"safetystops"];
            [dic setObject:jsonString forKey:@"safetystops_unit_value"];
        }

    }
    
    if (![self.maxDepth isEqualToString:@""]) {
        [dic setObject:self.maxDepth forKey:@"maxdepth_value"];
        [dic setObject:self.maxDepthUnit forKey:@"maxdepth_unit"];
        
    }
    
    if (![self.imageURL isEqualToString:@""]) {
        [dic setObject:self.imageURL forKey:@"thumbnail_image_url"];
    }
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:[self.spotInfo getDataDictionary] forKey:@"spot"];

    }else{
        
        if (![self.spotInfo.name isEqualToString:@""]) {
            [dic setObject:[self.spotInfo getDataDictionary] forKey:@"spot"];
        }
    }
    
    
    
        NSMutableArray *pics = [[NSMutableArray alloc] init];
    
        for (DivePicture* pic in self.divePictures) {
            
            [pics addObject:[pic getDataDictionary]];
            
        }
    
    if (![self.ID isEqualToString:@""]) {

        [dic setObject:pics forKey:@"pictures"];

    }else{
        if (pics.count > 0) {
            [dic setObject:pics forKey:@"pictures"];
        }
    }
    
    if (![self.diveShop.name isEqualToString:@""]) {
        
        [dic setObject:[self.diveShop getDataDictionary] forKey:@"shop"];
        
    }else{
        
        [dic setObject:[NSNull null] forKey:@"shop"];
        
    }
    
    if (![self.visibility isEqualToString:@""]) {
        
        if([self.visibility isEqualToString:@"-"])
        {
            
            [dic setObject:[NSNull null] forKey:@"visibility"];
            
        }else{
            
            [dic setObject:self.visibility forKey:@"visibility"];
            
        }
    }
    
    
    if (![self.water isEqualToString:@""]) {
        
        if ([self.water isEqualToString:@"-"]) {
            
            [dic setObject:[NSNull null] forKey:@"water"];
            
        }else{
            
            [dic setObject:self.water forKey:@"water"];
            
        }
    }
    
    
    if (![self.temp.bottom isEqualToString:@""]) {
        
        [dic setObject:self.temp.bottom forKey:@"temp_bottom"];
        [dic setObject:self.temp.bottomUnit forKey:@"temp_bottom_unit"];
        [dic setObject:self.temp.bottomValue forKey:@"temp_bottom_value"];
        
    }else{
        
        [dic setObject:[NSNull null] forKey:@"temp_bottom"];
        [dic setObject:[NSNull null] forKey:@"temp_bottom_unit"];
        [dic setObject:[NSNull null] forKey:@"temp_bottom_value"];
        
    }

    if (![self.temp.surface isEqualToString:@""]) {

        [dic setObject:self.temp.surface forKey:@"temp_surface"];
        [dic setObject:self.temp.surfaceUnit forKey:@"temp_surface_unit"];
        [dic setObject:self.temp.surfaceValue forKey:@"temp_surface_value"];
        
    }else{

        [dic setObject:[NSNull null] forKey:@"temp_surface"];
        [dic setObject:[NSNull null] forKey:@"temp_surface_unit"];
        [dic setObject:[NSNull null] forKey:@"temp_surface_value"];
        
        
    }
    
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:self.diveType forKey:@"divetype"];
        
    }else{
        if (self.diveType.count > 0) {
            
            [dic setObject:self.diveType forKey:@"divetype"];
        }
        
    }

    if (![self.number isEqualToString:@""]) {
        [dic setObject:self.number forKey:@"number"];
    }else{
        [dic setObject:[NSNull null] forKey:@"number"];
    }
    
    if (![self.current isEqualToString:@""]) {
        
        if([self.current isEqualToString:@"-"])
        {
            
            [dic setObject:[NSNull null] forKey:@"current"];
            
        }else{
            
            [dic setObject:self.current forKey:@"current"];
            
        }
    }
    
    if (![self.altitude isEqualToString:@""]) {
        [dic setObject:self.altitude forKey:@"altitude"];
    }
    
    [dic setObject:self.privacy forKey:@"privacy"];

    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:self.weight.weight forKey:@"weights"];
        [dic setObject:self.weight.unit forKey:@"weights_unit"];
        [dic setObject:self.weight.value forKey:@"weights_value"];
        
    }else{
        if (![self.weight.weight isEqualToString:@""]) {
            [dic setObject:self.weight.weight forKey:@"weights"];
            [dic setObject:self.weight.unit forKey:@"weights_unit"];
            [dic setObject:self.weight.value forKey:@"weights_value"];
        }
    }
    
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:[self.review getDataDictionary]  forKey:@"dive_reviews"];
        
    }else{
        
        if ([self.review isInculdeReview]) {
            
            [dic setObject:[self.review getDataDictionary]  forKey:@"dive_reviews"];
        }
        
    }
    
    
    
    
    NSMutableArray *buddiesJson = [[NSMutableArray alloc] init];
    
    for (Buddy *buddy in self.buddies) {
        
        [buddiesJson addObject:[buddy getDataDictionary]];
    }
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:buddiesJson forKey:@"buddies"];
        
    }else{
        
        if (buddiesJson.count > 0) {
            [dic setObject:buddiesJson forKey:@"buddies"];
        }
    }
    
    
    NSMutableArray* tanks = [[NSMutableArray alloc] init];
    for (DiveTank* tank in self.tanksUsed) {
        
        [tanks addObject:[tank getDataDictionary]];
        
    }
    
    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:tanks forKey:@"tanks"];
        
    }else{
        
        if (tanks.count > 0) {
            [dic setObject:tanks forKey:@"tanks"];
        }
        
    }

    

    if (![self.ID isEqualToString:@""]) {
        
        [dic setObject:self.note forKey:@"notes"];
        
    }else{
        
        if (![self.note isEqualToString:@""]) {
            [dic setObject:self.note forKey:@"notes"];
        }
        
    }
    
    
    return dic;
}


+ (NSString *)unitOfLengthWithValue:(NSString *)value defaultUnit:(NSString *)unit
{
    NSString *result;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    if ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) {   // unit is imperial
        if ([[unit lowercaseString] isEqualToString:@"m"]) {
            
            NSNumber* numberValue = [NSNumber numberWithDouble:[value floatValue] * 3.2808f];
            
//            result = [NSString stringWithFormat:@"%.g FEET", [value floatValue] * 3.2808f];
            result = [NSString stringWithFormat:@"%@ FEET", [formatter stringFromNumber:numberValue]];
            
        } else {
            
            NSNumber* numberValue = [NSNumber numberWithDouble:[value floatValue]];
            
            result = [NSString stringWithFormat:@"%@ FEET", [formatter stringFromNumber:numberValue]];
            
        }
    } else {           // unit is metric
        if ([[unit lowercaseString] isEqualToString:@"m"]) {
            
            NSNumber* numberValue = [NSNumber numberWithDouble:[value floatValue]];
            
            result = [NSString stringWithFormat:@"%@ METERS", [formatter stringFromNumber:numberValue]];
            
        } else {
            
            NSNumber* numberValue = [NSNumber numberWithDouble:[value floatValue] * 0.3048f];
            result = [NSString stringWithFormat:@"%@ METERS", [formatter stringFromNumber:numberValue]];
            
        }
    }
    return result;
}


+ (NSString *)unitOfLengthWithValue:(NSString *)value defaultUnit:(NSString *)unit showUnit:(BOOL)flag
{
    NSString *result = [DiveInformation unitOfLengthWithValue:value defaultUnit:unit];
    if (flag) {
        return result;
    } else {
        return [[result componentsSeparatedByString:@" "] objectAtIndex:0];
    }
}

- (NSString *)maxDepthValueWithUnit{
    
    NSString* result = @"";
    
    if ([self.maxDepthUnit isEqualToString:@"m"]) {
        
        result = [NSString stringWithFormat:@"%.2f METERS", [self.maxDepth floatValue]];
        
    }else{
        
        result = [NSString stringWithFormat:@"%.2f FEET", [self.maxDepth floatValue]];

    }
    
    return result;
}


+ (NSString *)unitOfTempWithValue:(NSString *)value defaultUnit:(NSString *)unit
{
    NSString *result;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    if ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) {   // unit is imperial
        
        if ([[unit lowercaseString] isEqualToString:@"c"]) {
            
            
            NSNumber *numberValue = [NSNumber numberWithDouble:[value floatValue]*9/5 + 32];
            result = [NSString stringWithFormat:@"%@ °F",[formatter stringFromNumber:numberValue]];
            
            
        } else {
            
            NSNumber *numberValue = [NSNumber numberWithDouble:[value floatValue]];
            result = [NSString stringWithFormat:@"%@ °F",[formatter stringFromNumber:numberValue]];
            
        }
        
    } else {
        // unit is metric
        if ([[unit lowercaseString] isEqualToString:@"c"]) {
            
            NSNumber *numberValue = [NSNumber numberWithDouble:[value floatValue]];

            result = [NSString stringWithFormat:@"%@ °C",[formatter stringFromNumber:numberValue]];
            
        } else {
            
            NSNumber *numberValue = [NSNumber numberWithDouble:([value floatValue] - 32)*5/9];

            result = [NSString stringWithFormat:@"%@ °C", [formatter stringFromNumber:numberValue]];
            
        }
        
    }
    return result;

}

+ (NSString *)unitOfTempWithValue:(NSString *)value defaultUnit:(NSString *)unit showUnit:(BOOL)flag
{
    NSString *result = [DiveInformation unitOfTempWithValue:value defaultUnit:unit];
    if (flag) {
        return result;
    } else {
        return [[result componentsSeparatedByString:@" "] objectAtIndex:0];
    }

}

+ (NSString *)unitOfWeightWithValue:(NSString *)value defaultUnit:(NSString *)unit
{
    NSString *result;
    
    if ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial)
    {   // unit is imperial
        if ([[unit lowercaseString] isEqualToString:@"kg"]) {
            result = [NSString stringWithFormat:@"%.4f lbs", [value floatValue] * 2.2046f];
        } else {
            result = [NSString stringWithFormat:@"%.4f lbs", [value floatValue]];
        }
    } else {           // unit is metric
        if ([[unit lowercaseString] isEqualToString:@"kg"]) {
            result = [NSString stringWithFormat:@"%.2f kg", [value floatValue]];
        } else {
            result = [NSString stringWithFormat:@"%.2f kg", [value floatValue] * 0.45359f];
        }
    }
    return result;

}

+ (NSString *)unitOfWeightWithValue:(NSString *)value defaultUnit:(NSString *)unit showUnit:(BOOL)flag
{
    NSString *result = [DiveInformation unitOfWeightWithValue:value defaultUnit:unit];
    if (flag) {
        return result;
    } else {
        return [[result componentsSeparatedByString:@" "] objectAtIndex:0];
    }
    
}

+(NSString*)convertInternationalFormatValue:(NSString*)string
{
    NSString* value = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    int commaIndex = (int)[value rangeOfString:@","].location;
    
    int periodIndex =(int)[value rangeOfString:@"."].location;
    
    if (commaIndex < periodIndex) {
        
        value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
        
    }else{
        value = [value stringByReplacingOccurrencesOfString:@"," withString:@"."];
        
    }
    
    return value;
}

@end



