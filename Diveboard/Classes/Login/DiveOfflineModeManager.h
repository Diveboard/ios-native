//
//  DiveOfflineModeManager.h
//  Diveboard
//
//  Created by Vladimir Popov on 4/9/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRequestKey   @"requestURL"
#define kRequestParamKey @"params"


typedef enum _diveUpdateType
{
    diveUpdateTypeUnknown = 0,
    diveUpdateTypeModify = 1,
    diveUpdateTypeNew    = 2,
} diveUpdateType;


@interface DiveOfflineModeManager : NSObject
{
    
}

+ (instancetype) sharedManager;

// if available offline mode "isAvalilable" is true, else false
@property (nonatomic)               BOOL isAvailable;

// if dive information is updated when offline mode, "isUpdated" is true, else false
@property (nonatomic)               BOOL isUpdated;

// if network is offline
@property (nonatomic)               BOOL isOffline;


// write login result to file
- (void) writeLoginResultData:(NSDictionary *)data;

// load login information when offline mode
- (NSDictionary *) getLoginResultData;

// write one dive information to file
- (void) writeOneDiveInformation:(NSDictionary *)data overwrite:(BOOL)flag;

// load one dive information from file when offline mode
- (NSDictionary *) getOneDiveInformation:(NSString *)diveID;

// write image to file
- (void) writeImage:(UIImage *)image url:(NSString *)urlString;

// load image from file when offline mode
- (UIImage *) getImageWithUrl:(NSString *)urlString;

//
- (void) diveEdit:(NSDictionary *)data;

//
- (void) createNewDive:(NSDictionary *)data;

//
- (void) deleteDiveID:(NSString *)diveID;

//
- (void) cleanOldInformation;

//
- (void) updateLocalDiveToServer:(void (^)())finish;

@end
