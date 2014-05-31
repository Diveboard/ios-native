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

<<<<<<< HEAD
// pending request count
@property (nonatomic, readonly)     int  pendingRequestCount;

=======
<<<<<<< HEAD
// pending request count
@property (nonatomic, readonly)     int  pendingRequestCount;

=======
>>>>>>> 685ccbd31b49cbe284c2f1c0074f39fcac1849d8
>>>>>>> f2f4947a1bb9f814a5b150efbed05c72f41c6d70
// if network is online
//@property (nonatomic)               BOOL isOnline;


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
