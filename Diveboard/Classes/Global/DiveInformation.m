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

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (data && ![data isEqual:[NSNull null]]) {
            self.class_             = getStringValue([data objectForKey:@"class"]);
            self.countryCode        = getStringValue([data objectForKey:@"country_code"]);
            self.countryFlagBig     = getStringValue([data objectForKey:@"country_flag_big"]);
            self.countryFlagSmall   = getStringValue([data objectForKey:@"country_flag_small"]);
            self.countryName        = getStringValue([data objectForKey:@"country_name"]);
            self.flavour            = getStringValue([data objectForKey:@"flavour"]);
            self.fullPermalink      = getStringValue([data objectForKey:@"fullpermalink"]);
            self.ID                 = getStringValue([data objectForKey:@"id"]);
            self.lat                = getStringValue([data objectForKey:@"lat"]);
            self.lng                = getStringValue([data objectForKey:@"lng"]);
            self.locationName       = getStringValue([data objectForKey:@"location_name"]);
            self.name               = getStringValue([data objectForKey:@"name"]);
            self.permaLink          = getStringValue([data objectForKey:@"permalink"]);
            self.regionName         = getStringValue([data objectForKey:@"region_name"]);
            self.shakenID           = getStringValue([data objectForKey:@"shaken_id"]);
            self.staticMap          = getStringValue([data objectForKey:@"staticmap"]);
            self.withinCountryBounds = getStringValue([data objectForKey:@"within_country_bounds"]);
        } else {
            self.class_             = @""; // getStringValue([data objectForKey:@"class"]);
            self.countryCode        = @""; //getStringValue([data objectForKey:@"country_code"]);
            self.countryFlagBig     = @""; //getStringValue([data objectForKey:@"country_flag_big"]);
            self.countryFlagSmall   = @""; //getStringValue([data objectForKey:@"country_flag_small"]);
            self.countryName        = @""; //getStringValue([data objectForKey:@"country_name"]);
            self.flavour            = @""; //getStringValue([data objectForKey:@"flavure"]);
            self.fullPermalink      = @""; //getStringValue([data objectForKey:@"fullpermalink"]);
            self.ID                 = @""; //getStringValue([data objectForKey:@"id"]);
            self.lat                = @""; //getStringValue([data objectForKey:@"lat"]);
            self.lng                = @""; //getStringValue([data objectForKey:@"lng"]);
            self.locationName       = @""; //getStringValue([data objectForKey:@"location_name"]);
            self.name               = @""; //getStringValue([data objectForKey:@"name"]);
            self.permaLink          = @""; //getStringValue([data objectForKey:@"permalink"]);
            self.regionName         = @""; //getStringValue([data objectForKey:@"region_name"]);
            self.shakenID           = @""; //getStringValue([data objectForKey:@"shaken_id"]);
            self.staticMap          = @""; //getStringValue([data objectForKey:@"staticmap"]);
            self.withinCountryBounds = @""; //getStringValue([data objectForKey:@"within_country_bounds"]);

        }
        
    }
    return self;
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
            
        }
        
    }
    return self;
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
        }
        
    }
    return self;

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

@end

@implementation DiveWegith

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

@implementation DiveInformation

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.ID       = getStringValue([data objectForKey:@"id"]);
        self.shakenID = getStringValue([data objectForKey:@"shaken_id"]);
        self.tripName = getStringValue([data objectForKey:@"trip_name"]);
        self.date     = getStringValue([data objectForKey:@"date"]);
        self.time     = getStringValue([data objectForKey:@"time"]);
        self.duration = getStringValue([data objectForKey:@"duration"]);
        self.maxDepth = getStringValue([data objectForKey:@"maxdepth"]);
        self.maxDepthUnit = getStringValue([data objectForKey:@"maxdepth_unit"]);
        self.imageURL = getStringValue([data objectForKey:@"thumbnail_image_url"]);
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
        self.diveType   = [data objectForKey:@"divetype"];
        self.note       = getStringValue([data objectForKey:@"notes"]);
        self.number     = getStringValue([data objectForKey:@"number"]);
        self.current    = getStringValue([data objectForKey:@"current"]);
        self.altitude    = getStringValue([data objectForKey:@"altitude"]);
        self.privacy    = getStringValue([data objectForKey:@"privacy"]);
        self.weight     = [[DiveWegith alloc] initWithDictionary:data];
    }
    return self;
}

+ (NSString *)unitOfLengthWithValue:(NSString *)value defaultUnit:(NSString *)unit
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int type = [[ud objectForKey:kDiveboardUnit] intValue];
    NSString *result;
    if (type == 0) {   // unit is imperial
        if ([[unit lowercaseString] isEqualToString:@"m"]) {
            result = [NSString stringWithFormat:@"%.2f FEET", [value floatValue] * 3.2808f];
        } else {
            result = [NSString stringWithFormat:@"%.2f FEET", [value floatValue]];
        }
    } else {           // unit is metric
        if ([[unit lowercaseString] isEqualToString:@"m"]) {
            result = [NSString stringWithFormat:@"%.2f METERS", [value floatValue]];
        } else {
            result = [NSString stringWithFormat:@"%.2f METERS", [value floatValue] * 0.3048f];
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

+ (NSString *)unitOfTempWithValue:(NSString *)value defaultUnit:(NSString *)unit
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int type = [[ud objectForKey:kDiveboardUnit] intValue];
    NSString *result;
    if (type == 0) {   // unit is imperial
        if ([[unit lowercaseString] isEqualToString:@"c"]) {
            result = [NSString stringWithFormat:@"%.2f °F", [value floatValue] + 32];
        } else {
            result = [NSString stringWithFormat:@"%.2f °F", [value floatValue]];
        }
    } else {           // unit is metric
        if ([[unit lowercaseString] isEqualToString:@"c"]) {
            result = [NSString stringWithFormat:@"%.2f °C", [value floatValue]];
        } else {
            result = [NSString stringWithFormat:@"%.2f °C", [value floatValue] - 32];
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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int type = [[ud objectForKey:kDiveboardUnit] intValue];
    NSString *result;
    if (type == 0) {   // unit is imperial
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


@end



