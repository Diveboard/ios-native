//
//  DiveOfflineModeManager.m
//  Diveboard
//
//  Created by Vladimir Popov on 4/9/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//


#define kLoginResultFilename     @"loginResult.dat"
#define kOneDiveFilename(diveId) [NSString stringWithFormat:@"%@/diveInfo.dat", diveId]
#define kUpdatedDiveFilename     @"updateDive.dat"
#define kCheckingOnlineReqestTime   240 // seconds

#import "DiveOfflineModeManager.h"
#import "DiveInformation.h"
#import "AFNetworking.h"


@interface DiveOfflineModeManager()
{
    NSFileManager *fileManager;
    NSTimer *checkingTimer;
}

@end

@implementation DiveOfflineModeManager

static DiveOfflineModeManager *_sharedManager;

+ (instancetype)sharedManager
{
    if (!_sharedManager) {
        _sharedManager = [[DiveOfflineModeManager alloc] init];
    }
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isOffline      = NO;
        _isAvailable    = NO;
        _isUpdated      = NO;
        
        fileManager = [NSFileManager defaultManager];
        [self checkLocalDataExisting];
        [self checkUpdateDive];
        
        NSString *dirName = [self getFullpathFilename:@"images/"];
        [self createDirectory:dirName];
        
        [self startCheckingInternetConnection];
        
    }
    return self;
}

- (void)setIsOffline:(BOOL)isOffline
{
    
    if (isOffline) {
        _isOffline = isOffline;
        checkingTimer = [NSTimer scheduledTimerWithTimeInterval:kCheckingOnlineReqestTime
                                                         target:self
                                                       selector:@selector(checkingRequestSend:)
                                                       userInfo:nil
                                                        repeats:YES];
        
    }
    else {
        [checkingTimer invalidate];
        checkingTimer = nil;
        
        if ([self checkUpdateDive]) {
            [self updateLocalDiveToServer:^{
                _isOffline = isOffline;
                
            }];
        }
        else {
            _isOffline = isOffline;
        }
    }
}

- (void) checkingRequestSend:(NSTimer *)dt
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager         GET:SERVER_URL
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
        self.isOffline = NO;
                     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"checking online timer : offline yet --------");
        
    }];
    
}

- (void) startCheckingInternetConnection
{
    AFNetworkReachabilityManager *reachablilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachablilityManager startMonitoring];
    
    [reachablilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachability Status NotReachable");
//                reachable = NO;
                _isOffline = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachability Status Reachable Via WiFi");
                _isOffline = NO;
//                reachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachability Status Reachable Via WWAN");
                _isOffline = NO;
//                reachable = YES;
                break;
            default:
                NSLog(@"AFNetworkReachability   Unkown network status");
                _isOffline = YES;
//                reachable = NO;
                break;
        }
    }];
}

- (BOOL) checkLocalDataExisting
{
    NSString *loginResultFilepath = [self getFullpathFilename:kLoginResultFilename];
    self.isAvailable = [fileManager fileExistsAtPath:loginResultFilepath];
    return self.isAvailable;
}

- (BOOL) checkUpdateDive
{
    NSString *updatedFilename = [self getFullpathFilename:kUpdatedDiveFilename];
    if ([fileManager fileExistsAtPath:updatedFilename]) {
        NSData *updateData = [NSData dataWithContentsOfFile:updatedFilename];
        NSArray *updatedList = [NSKeyedUnarchiver unarchiveObjectWithData:updateData];
        if (updatedList.count) {
            self.isUpdated = YES;
            return self.isUpdated;
        }
        _pendingRequestCount = updatedList.count;
    }
    else {
//        NSString *sourceFilename = [[NSBundle mainBundle] pathForResource:@"loginResult" ofType:@"plist"];
//        [fileManager copyItemAtPath:sourceFilename toPath:updatedFilename error:nil];
    }
    self.isUpdated = NO;
    return self.isUpdated;
}

- (NSString *) getFullpathFilename:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return path;
}

- (void) createDirectory:(NSString *)dirName
{
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:dirName isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [fileManager createDirectoryAtPath:dirName
               withIntermediateDirectories:YES
                                attributes:attr
                                     error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }

}

#pragma mark - Login Result

- (void) writeLoginResultData:(NSDictionary *)data
{
    NSData *loginResultData = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    NSString *filename = [self getFullpathFilename:kLoginResultFilename];
    
    [loginResultData writeToFile:filename atomically:YES];
}

- (NSDictionary *) getLoginResultData
{
    NSString *filename = [self getFullpathFilename:kLoginResultFilename];
    NSData   *loginResultData = [NSData dataWithContentsOfFile:filename];
    if (loginResultData) {
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:loginResultData];
        return data;
    }
    else {
        return nil;
    }
    
}

#pragma mark - One Dive information

- (BOOL) writeOneDiveInformation:(NSDictionary *)data overwrite:(BOOL)flag
{
    id result = [data objectForKey:@"result"];
    if (result && result != [NSNull null]) {
        NSString *diveID = getStringValue([result objectForKey:@"id"]);
        NSData *oneDiveData = [NSKeyedArchiver archivedDataWithRootObject:data];
        
        NSString *dirName = [self getFullpathFilename:diveID];
        
        [self createDirectory:dirName];
        
        NSString *fileName = [dirName stringByAppendingString:@"/diveInfo.dat"];
        
        if (flag) {
            [oneDiveData writeToFile:fileName atomically:YES];
        } else {
            if (![fileManager fileExistsAtPath:fileName]) {
                [oneDiveData writeToFile:fileName atomically:YES];
            }
        }
        NSLog(@"One Dive filename : %@", fileName);
        return YES;
    } else {
        return NO;
    }

}

- (NSDictionary *) getOneDiveInformation:(NSString *)diveID
{
    NSString *filename = [self getFullpathFilename:kOneDiveFilename(diveID)];
    NSData   *oneDiveData = [NSData dataWithContentsOfFile:filename];
    NSDictionary *data    = [NSKeyedUnarchiver unarchiveObjectWithData:oneDiveData];
    return data;
}

#pragma mark - image management

- (void) writeImage:(UIImage *)image url:(NSString *)urlString
{
    if (!image || !urlString || urlString.length == 0) {
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *imageDir = [[self getFullpathFilename:@"images"] stringByAppendingString:@"/"];
    NSString *filename = [[NSURL URLWithString:urlString] lastPathComponent];
    NSString *filepath = [imageDir stringByAppendingString:filename];
    if (![fileManager fileExistsAtPath:filepath]) {
        [imageData writeToFile:filepath atomically:YES];
    }
    
}

- (UIImage *) getImageWithUrl:(NSString *)urlString
{
    if (urlString) {
        NSString *imageDir = [[self getFullpathFilename:@"images/"] stringByAppendingString:@"/"];
        NSString *filename = [[NSURL URLWithString:urlString] lastPathComponent];
        NSString *filepath = [imageDir stringByAppendingString:filename];
        UIImage *image = nil;
        if ([fileManager fileExistsAtPath:filepath]) {
            NSData *imageData = [NSData dataWithContentsOfFile:filepath];
            image = [UIImage imageWithData:imageData];
        }
        return image;

    }
    else {
        return nil;
    }
}

#pragma makr - Dive update register

- (void) diveEdit:(NSDictionary *)data
{
    NSMutableArray *updateList = [[NSMutableArray alloc] init];
    
    NSString *fileName = [self getFullpathFilename:kUpdatedDiveFilename];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *updateData = [NSData dataWithContentsOfFile:fileName];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:updateData];
        if (array && array.count) {
            updateList = [NSMutableArray arrayWithArray:array];
        }
    }
    [updateList addObject:data];
    
    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
    [updateData writeToFile:fileName atomically:YES];
    
    NSLog(@"update write filename : %@", fileName);
}

- (void) createNewDive:(NSDictionary *)data
{
    if ([self getLoginResultData]) {
        
        NSString *diveID = getStringValue([[data objectForKey:@"result"] objectForKey:@"id"]);
        
        NSMutableDictionary *loginResult = [NSMutableDictionary dictionaryWithDictionary:[self getLoginResultData]];
        NSMutableArray *diveIDs = [NSMutableArray arrayWithArray:[[loginResult objectForKey:@"user"] objectForKey:@"all_dive_ids"]];
        [diveIDs insertObject:diveID atIndex:0];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[loginResult objectForKey:@"user"]];
        [userInfo setObject:diveIDs forKey:@"all_dive_ids"];
        [loginResult setObject:userInfo forKey:@"user"];
        [self writeLoginResultData:loginResult];
        
        [self writeOneDiveInformation:data overwrite:YES];
    }
}

- (void) deleteDiveID:(NSString *)diveID
{
    if ([self getLoginResultData]) {
        NSMutableDictionary *loginResult = [NSMutableDictionary dictionaryWithDictionary:[self getLoginResultData]];
        NSMutableArray *diveIDs = [NSMutableArray arrayWithArray:[[loginResult objectForKey:@"user"] objectForKey:@"all_dive_ids"]];
        for (NSNumber *oneId in diveIDs) {
            if ([[oneId stringValue] isEqualToString:diveID]) {
                [diveIDs removeObject:oneId];
                break;
            }
        }
//        [diveIDs removeObject:diveID];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[loginResult objectForKey:@"user"]];
        [userInfo setObject:diveIDs forKey:@"all_dive_ids"];
        [loginResult setObject:userInfo forKey:@"user"];
        [self writeLoginResultData:loginResult];
    }
}

//- (void) diveUpdate
//{
//    NSMutableArray *updateList = [[NSMutableArray alloc] init];
//    
//    NSString *fileName = [self getFullpathFilename:kUpdatedDiveFilename];
//    if ([fileManager fileExistsAtPath:fileName]) {
//        NSData *updateData = [NSData dataWithContentsOfFile:fileName];
//        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:updateData];
//        if (array && array.count) {
//            updateList = [NSMutableArray arrayWithArray:array];
//        }
//    }
////    [updateList addObject:data];
//    
//    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
//    [updateData writeToFile:fileName atomically:YES];
//    
//    NSLog(@"update write filename : %@", fileName);
//}

- (void) cleanOldInformation
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error = nil;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            
            BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
            
            if (!removeSuccess) {
                
                NSArray *contents = [fileManager contentsOfDirectoryAtPath:fullPath error:&error];
                
                for (NSString *file in contents) {
                    
                    NSString *filePath = [fullPath stringByAppendingPathComponent:file];
                    removeSuccess = [fileManager removeItemAtPath:filePath error:&error];
                    if (!removeSuccess) {

                        
                    }
                }

            }
        }
    } else {
        // Error handling

    }
}

- (void)updateLocalDiveToServer:(void (^)())finish
{
    
    NSString *fileName = [self getFullpathFilename:kUpdatedDiveFilename];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *updateData = [NSData dataWithContentsOfFile:fileName];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:updateData];
        if (array && array.count) {
            NSMutableArray *updateList = [NSMutableArray arrayWithArray:array];
            NSDictionary   *updateItem = [updateList lastObject];
            
            NSString     *urlString = [updateItem objectForKey:kRequestKey];
            NSDictionary *params    = [updateItem objectForKey:kRequestParamKey];
            if (params.count > 2) {  // new or update
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [updateList removeObject:updateItem];
                    
                    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
                    [updateData writeToFile:fileName atomically:YES];
                    
                    _pendingRequestCount = updateList.count;
                    
                    [self updateLocalDiveToServer:finish];

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error : %@", error);
                    
                    if (finish) {
                        finish();
                    }
                    
                }];

                
            } else {  // delete dive
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager DELETE:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"delete operation : %@", responseObject);
                    
                    [updateList removeObject:updateItem];
                    
                    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
                    [updateData writeToFile:fileName atomically:YES];

                    _pendingRequestCount = updateList.count;
                    
                    [self updateLocalDiveToServer:finish];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (finish) {
                        finish();
                    }
                }];
            }
            
        } else {
            [fileManager removeItemAtPath:fileName error:nil];
            if (finish) {
                finish();
            }
        }
    } else {
        if (finish) {
            finish();
        }
    }

}

@end
