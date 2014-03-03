//
//  MyDiveData.h
//  Diveboard
//
//  Created by Vladimir Popov on 12/28/13.
//  Copyright (c) 2013 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiveHeaderInfo.h"
#import "Distance.h"
#import "Shop.h"
#import "Spot.h"
#import "Temperature.h"
#import "Picture.h"


@interface MyDiveData : NSObject<DiveHeaderInfo>{

    Distance *_altitude;
    
    //buddies
    NSString                    *_class;
	BOOL                        _complete;
	NSString                    *_current;
    NSString                    *_date;
	NSMutableArray              *_diveGears;        //Array of DiveGear class
    
    // dive shop
    NSMutableArray              *_divetype;     //NSString
//    NSInteger                   _duration;
    BOOL                        _favorite;
	// flavour
    NSString                    *_fullpermalink;
	// gears
    NSString                    *_guide;
//	int                         _id;
    double                      _lat;
	// legacy_buddies_hash
	double                      _lng;
//	Distance                    *_maxdepth;
	//notes
    NSString                    *_permalink;
    NSInteger                   _privacy;
	// public_notes
    NSString                    *_safetystops;
	NSString                    *_shakenId;
    Shop                        *_shop;
	NSInteger                   _shopId;
	Temperature                 *_tempBottom;
	Temperature                 *_tempSurface;
	Picture                     *_thumbnailImageUrl;
	Picture                     *_thumbnailProfileUrl;
	Picture                     *_profile;
	Picture                     *_profileV3;
    NSString                    *_time;
    NSString                    *_timeIn;
    NSString                    *_tripName;
    NSMutableArray              *_userGears;    //Array of UserGear
	int                         _userId;
    NSString                    *_visibility;
    NSString                    *_water;
	double                      _weights;       //Weight Class Definition needed
	NSString                    *_notes;
    NSString                    *_publicNotes;
	NSInteger                   _number;
	NSMutableArray              *_tanks;        //Array of Tank Class
	NSMutableArray              *_species;      //Array of Species class
	Picture                     *_featuredPicture;
//	NSMutableArray              *_pictures;     //Array of Picture class
	NSMutableDictionary         *_editList;     //<String : String> Dictionary
    NSString                    *_shopName;
	Picture                     *_shopPicture;
    
}

// some properties for our dives
@property (nonatomic, strong) NSString                  *trip_name;
@property (nonatomic, strong) UIImage                   *image;
@property (nonatomic, )       NSInteger                 _id;
@property (nonatomic, strong) NSString                  *_date;
@property (nonatomic, strong) NSString                  *_maxdepth;
@property (nonatomic, strong) NSString                  *_duration;
@property (nonatomic)         bool                      isImageOnly;
@property (nonatomic, )       NSInteger                 _spotId;
@property (nonatomic, strong) Spot                      *_spot;
@property (nonatomic, strong) NSMutableArray            *_pictures;     //Array of Picture class
@property (nonatomic, strong) NSMutableArray            *_pictureImages;
@property (nonatomic, )       double                    _lat;
@property (nonatomic, )       double                    _lng;
@property (nonatomic, )       BOOL                      isSettedSmallImages;

// an example of using UINavigationController as the owner of the page.
@property (nonatomic, retain) UINavigationController *navController;


@end