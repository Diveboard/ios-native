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
        if (![data isEqual:[NSNull null]]) {
            self.class_             = getStringValue([data objectForKey:@"class"]);
            self.countryCode        = getStringValue([data objectForKey:@"country_code"]);
            self.countryFlagBig     = getStringValue([data objectForKey:@"country_flag_big"]);
            self.countryFlagSmall   = getStringValue([data objectForKey:@"country_flag_small"]);
            self.counttyName        = getStringValue([data objectForKey:@"country_name"]);
            self.flavour            = getStringValue([data objectForKey:@"flavure"]);
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
            self.counttyName        = @""; //getStringValue([data objectForKey:@"country_name"]);
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
            self.flavour            = getStringValue([data objectForKey:@"flavure"]);
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


@implementation DiveInformation

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.ID       = getStringValue([data objectForKey:@"id"]);
        self.tripName = getStringValue([data objectForKey:@"trip_name"]);
        self.date     = getStringValue([data objectForKey:@"date"]);
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
    }
    return self;
}
@end



