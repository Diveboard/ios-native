//
//  User.h
//  Diveboard
//
//  Created by Vladimir Popov on 1/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"

@interface User : NSObject{
    
}

@property (nonatomic, strong) NSString                  *trip_name;
@property (nonatomic, strong) UIImage                   *image;
@property (nonatomic, )       NSInteger                 _id;
@property (nonatomic, strong) NSString                  *_date;


@property (nonatomic, strong) NSString                  *_shaken_id;
@property (nonatomic, strong) NSString					*_vanity_url;
@property (nonatomic, strong) NSMutableArray            *_qualifications;   // = new HashMap<String, ArrayList<Qualification>>();
@property (nonatomic, strong) UIImage                   *_picture;
@property (nonatomic, strong) UIImage					*_picture_small;
@property (nonatomic, strong) UIImage					*_picture_large;
@property (nonatomic, strong) NSString                  *_fullpermalink;
@property (nonatomic, )       int                       _total_nb_dives;
@property (nonatomic, )       int                       _public_nb_dives;
@property (nonatomic, strong) NSString					*_location;
@property (nonatomic, strong) NSString					*_nickname;
@property (nonatomic, strong) NSMutableArray			*_userGears;        //UserGear Class
@property (nonatomic,)        NSInteger					_totalExtDives;
@property (nonatomic, strong) NSMutableArray			*_dives;            //= new ArrayList<Dive>();
@property (nonatomic, strong) NSString					*_countryName;
@property (nonatomic, strong) NSString                  *_unitPreferences;  //Unit

@end
