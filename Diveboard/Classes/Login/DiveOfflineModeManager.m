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
#define kCheckingOnlineReqestTime   60 // seconds

#import "DiveOfflineModeManager.h"
#import "DiveInformation.h"
#import "AFNetworking.h"
#import "GZIP.h"
#import <sqlite3.h>
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
        [self updateSpotsDB];
        [self checkLocalDataExisting];
        [self checkUpdateDive];
        
        NSString *dirName = [self getCahchePathFileName:@"images/"];
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
        [self updateSpotsDB];
        if ([self checkUpdateDive] && !self.isRefresh) {
            
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
                     
        _isOffline = NO;
                     
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
//                NSLog(@"AFNetworkReachability Status NotReachable");
//                reachable = NO;
                _isOffline = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"AFNetworkReachability Status Reachable Via WiFi");
                _isOffline = NO;
//                reachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"AFNetworkReachability Status Reachable Via WWAN");
                _isOffline = NO;
//                reachable = YES;
                break;
            default:
//                NSLog(@"AFNetworkReachability   Unkown network status");
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
        _pendingRequestCount =(int)updatedList.count;
        if (updatedList.count) {
            self.isUpdated = YES;
            return self.isUpdated;
        }
    }
    else {
//        NSString *sourceFilename = [[NSBundle mainBundle] pathForResource:@"loginResult" ofType:@"plist"];
//        [fileManager copyItemAtPath:sourceFilename toPath:updatedFilename error:nil];
    }
    self.isUpdated = NO;
    return self.isUpdated;
}

- (NSString*) getCahchePathFileName:(NSString *)filename
{
    return  [self getFullpathFilename:[NSString stringWithFormat:@"cache/%@",filename]];
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

- (void) deleteLoginResultData
{
    
    NSString *filename = [self getFullpathFilename:kLoginResultFilename];
    
    [fileManager removeItemAtPath:filename error:nil];
    
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
        
        NSString *dirName = [self getCahchePathFileName:diveID];
        
        [self createDirectory:dirName];
        
        NSString *fileName = [dirName stringByAppendingString:@"/diveInfo.dat"];
        
        if (flag) {
            [oneDiveData writeToFile:fileName atomically:YES];
        } else {
            if (![fileManager fileExistsAtPath:fileName]) {
                [oneDiveData writeToFile:fileName atomically:YES];
            }
        }
        
        
        return YES;
    } else {
        return NO;
    }

}

- (NSDictionary *) getOneDiveInformation:(NSString *)diveID
{
    NSString *filename = [self getCahchePathFileName:kOneDiveFilename(diveID)];
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
    NSString *imageDir = [[self getCahchePathFileName:@"images"] stringByAppendingString:@"/"];
//    NSString *filename = [[NSURL URLWithString:urlString] lastPathComponent];
    NSString *filename = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    
    
    NSString *filepath = [imageDir stringByAppendingString:filename];
//    if (![fileManager fileExistsAtPath:filepath]) {
    
        [[AppManager sharedManager].remainingPictures removeObject:urlString];
        
        [imageData writeToFile:filepath atomically:YES];
//    }
    
}

- (UIImage *) getImageWithUrl:(NSString *)urlString
{
    if (urlString && ![urlString isEqualToString:@""]) {
        NSString *imageDir = [[self getCahchePathFileName:@"images/"] stringByAppendingString:@"/"];
//        NSString *filename = [[NSURL URLWithString:urlString] lastPathComponent];
        NSString *filename = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

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

- (BOOL)removeImageWithUrl:(NSString *)urlString
{
    if (urlString && ![urlString isEqualToString:@""]) {
        
        NSString *imageDir = [[self getCahchePathFileName:@"images/"] stringByAppendingString:@"/"];
//        NSString *filename = [[NSURL URLWithString:urlString] lastPathComponent];
        NSString *filename = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        NSString *filepath = [imageDir stringByAppendingString:filename];
        
        if ([fileManager fileExistsAtPath:filepath]) {
            
            [fileManager removeItemAtPath:filepath error:nil];
            return YES;
        }
        
    }
    
    return NO;
}

-(BOOL)isExistImageWithURL:(NSString*)URLString
{
    if (URLString) {
        
        NSString *imageDir = [[self getCahchePathFileName:@"images/"] stringByAppendingString:@"/"];
//        NSString *filename = [[NSURL URLWithString:URLString] lastPathComponent];
        NSString *filename = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        NSString *filepath = [imageDir stringByAppendingString:filename];

        if ([fileManager fileExistsAtPath:filepath]) {
            
            return YES;
        }
        
    }

    
    return NO;
}


-(NSDictionary*)writeLocalDivePicture:(UIImage *)picture

{
    
    
    if (!picture) {
        
        return nil;
        
    }
    
    NSData *imageData = UIImageJPEGRepresentation(picture, 1.0f);
    NSString *imageDir = [[self getFullpathFilename:@"localPictures"] stringByAppendingString:@"/"];
    [self createDirectory:imageDir];
    NSString *filename = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *filepath = [imageDir stringByAppendingString:filename];
    
    if (![fileManager fileExistsAtPath:filepath]) {
        
        [imageData writeToFile:filepath atomically:YES];
        
    }
    
    NSDictionary* result = @{
                             @"id"           : filename,
                             @"large"        : filepath,
                             @"medium"       : filepath,
                             @"small"        : filepath,
                             @"thumbnail"    : filepath,
                             @"is_local"     : @YES
                             };
    
    return result;
}

- (UIImage *) getLocalDivePicture:(NSString *)urlString
{
    if (urlString && ![urlString isEqualToString:@""]) {
        NSString *imageDir = [[self getFullpathFilename:@"localPictures"] stringByAppendingString:@"/"];
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

-(void)diveEdit:(NSDictionary *)data :(BOOL)isLocal :(NSString*)diveID

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

    
    if ([diveID isEqual:@""]) {
        /// Add
        [updateList addObject:data];
        
    }else{
        
        NSMutableDictionary* newParams =[NSMutableDictionary dictionaryWithDictionary:[data objectForKey:kRequestParamKey]];
        
        if (newParams.count > 2) {
        /// Update
            BOOL flag = YES;
            for (int i = 0 ; i < updateList.count; i++)
            {
                
                NSMutableDictionary  *updateItem = [NSMutableDictionary dictionaryWithDictionary:[updateList objectAtIndex:i]];
                NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithDictionary:[updateItem objectForKey:kRequestParamKey]];
                
                NSString *dive_jsonString = [params objectForKey:@"arg"];
                if (dive_jsonString)
                {
                    
                    NSData *dive_jsonData = [dive_jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary* diveDataDic = [NSJSONSerialization JSONObjectWithData:dive_jsonData options:0 error:nil];
                    
                    NSString* tempDiveId = isLocal ?  getStringValue([diveDataDic objectForKey:@"local_id"]) : getStringValue([diveDataDic objectForKey:@"id"]);
                    
                    
                    
                    if ([diveID isEqualToString:tempDiveId])
                    {
                        
                        flag = NO;
                        if (isLocal) {
                            
                            
                            dive_jsonString = [newParams objectForKey:@"arg"];
                            dive_jsonData = [dive_jsonString dataUsingEncoding:NSUTF8StringEncoding];
                            NSMutableDictionary* newDiveDic =[NSMutableDictionary dictionaryWithDictionary: [NSJSONSerialization JSONObjectWithData:dive_jsonData options:0 error:nil]];
                            
                            
                            [newDiveDic removeObjectForKey:@"id"];
                            [newDiveDic setObject:[diveDataDic objectForKey:@"user_id"] forKey:@"user_id"];
                            
                            NSData *newjsonData = [NSJSONSerialization dataWithJSONObject:newDiveDic
                                                                                  options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                                    error:nil];
                            NSString *newjsonString = [[NSString alloc] initWithData:newjsonData encoding:NSUTF8StringEncoding];
                            newjsonString = [newjsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            
                            [newParams setObject:newjsonString forKey:@"arg"];
                            
                            NSMutableDictionary* newData = [NSMutableDictionary dictionaryWithDictionary:data];
                            [newData setObject:newParams forKey:kRequestParamKey];
                            
                            [updateList replaceObjectAtIndex:i withObject:newData];
                            
                        }else{
                            
                            [updateList replaceObjectAtIndex:i withObject:data];
                            
                        }
                        
                        
                    }
                }
                
            }
            
            if (flag) {
                [updateList addObject:data];
            }
            
        }else{
            
            //// Delete //
            BOOL flag = YES;
            for (int i = 0 ; i < updateList.count; i++)
            {
                
                NSMutableDictionary  *updateItem = [NSMutableDictionary dictionaryWithDictionary:[updateList objectAtIndex:i]];
                NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithDictionary:[updateItem objectForKey:kRequestParamKey]];
                
                NSString *dive_jsonString = [params objectForKey:@"arg"];
                if (dive_jsonString)
                {
                    
                    NSData *dive_jsonData = [dive_jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary* diveDataDic = [NSJSONSerialization JSONObjectWithData:dive_jsonData options:0 error:nil];
                    
                    NSString* tempDiveId = isLocal ?  getStringValue([diveDataDic objectForKey:@"local_id"]) : getStringValue([diveDataDic objectForKey:@"id"]);
                    
                    
                 
                    if ([diveID isEqualToString:tempDiveId])
                    {
                        
                        flag = NO;
                        if (isLocal) {
                            
                            [updateList removeObjectAtIndex:i];
                            
                        }else{
                            
                            [updateList replaceObjectAtIndex:i withObject:data];
                            
                        }
                        
                        
                    }
                }
                
            }
            
            if (flag) {
                [updateList addObject:data];
            }
            
        }
        
        
    }
    
    
    
    
    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
    [updateData writeToFile:fileName atomically:YES];
    
    _pendingRequestCount = (int)updateList.count;
}

- (void) createNewDive:(NSDictionary *)data
{
    if ([self getLoginResultData]) {
        
        NSString *diveID = getStringValue([[data objectForKey:@"result"] objectForKey:@"id"]);
        
        NSMutableDictionary *loginResult = [NSMutableDictionary dictionaryWithDictionary:[self getLoginResultData]];
        
        NSMutableArray *diveIDs = [NSMutableArray arrayWithArray:[[loginResult objectForKey:@"user"] objectForKey:@"all_dive_ids"]];
        [diveIDs insertObject:[NSNumber numberWithLong:[diveID integerValue]] atIndex:0];
        
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
        
//        for (NSString *oneId in diveIDs) {
//            
//            NSLog(@"%@",oneId);
//            
//            if ([oneId isEqualToString:diveID]) {
//                [diveIDs removeObject:oneId];
//                break;
//            }
//        }
        
        [diveIDs removeObject:[NSNumber numberWithLong:[diveID integerValue]]];
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
            
            NSMutableDictionary  *updateItem = [NSMutableDictionary dictionaryWithDictionary:[updateList lastObject]];
            
            NSString     *urlString = [updateItem objectForKey:kRequestKey];
            NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithDictionary:[updateItem objectForKey:kRequestParamKey]];
            
            if (params.count > 2) {  // new or update

                
                // Local Picture Upload
                NSString *dive_jsonString = [params objectForKey:@"arg"];
                NSData *dive_jsonData = [dive_jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* diveDataDic = [NSJSONSerialization JSONObjectWithData:dive_jsonData options:0 error:nil];
                DiveInformation* tempDiveInfo = [[DiveInformation alloc] initWithDictionary:diveDataDic];
                
                for (int i = 0 ; i < tempDiveInfo.divePictures.count ; i++) {
                    
                    DivePicture* divePicture = [tempDiveInfo.divePictures objectAtIndex:i];
                    
                    if (divePicture.isLocal) {
                        
                        UIImage* uploadImage = [self getLocalDivePicture:divePicture.largeURL];
                        
                        NSDictionary* pictureDic = [self uploadLocalPicture:uploadImage params:params];
                        
                        if (pictureDic) {
                            
                            [tempDiveInfo.divePictures replaceObjectAtIndex:i withObject:[[DivePicture alloc] initWithDictionary:pictureDic]];
                            
                            NSError *error;
                            NSData *newjsonData = [NSJSONSerialization dataWithJSONObject:[tempDiveInfo getDataDictionary]
                                                                                  options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                                    error:&error];
                            
                            if (newjsonData) {
                                
                                NSString *newjsonString = [[NSString alloc] initWithData:newjsonData encoding:NSUTF8StringEncoding];
                                newjsonString = [newjsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                
                                [params setObject:newjsonString forKey:@"arg"];
                                
                                [updateItem setObject:params forKey:kRequestParamKey];
                                
                                [updateList replaceObjectAtIndex:updateList.count-1 withObject:updateItem];
                                
                                NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
                                [updateData writeToFile:fileName atomically:YES];
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                }
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [updateList removeObject:updateItem];
                    
                    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
                    [updateData writeToFile:fileName atomically:YES];
                    
                    _pendingRequestCount = (int) updateList.count;
                    [self updateLocalDiveToServer:finish];

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                    if (finish) {
                        finish();
                    }
                    
                }];

                
            } else {  // delete dive
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             [manager DELETE:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                    [updateList removeObject:updateItem];
                    
                    NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updateList];
                    [updateData writeToFile:fileName atomically:YES];

                    _pendingRequestCount = (int) updateList.count;
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

- (NSDictionary*)uploadLocalPicture:(UIImage*)image params:(NSDictionary*)params
{
    

    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *requestURLStr = [NSString stringWithFormat:@"%@/api/picture/upload", SERVER_URL];
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:requestURLStr]];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];

    
    //[urlRequest addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"auth_token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[params objectForKey:@"auth_token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"apikey"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[API_KEY dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    

    
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qqfile\"; filename=\"%@\"\r\n", @"file.jpg"]dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postData appendData:[NSData dataWithData:imageData]];
    
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];

    NSURLResponse* response;
    NSError* error;
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
//    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    
    
    NSMutableDictionary* resultData = nil;
    
    if ([[jsonData objectForKey:@"success"] boolValue]) {
        
        NSDictionary *picData = [jsonData objectForKey:@"picture"];
        
        resultData = [NSMutableDictionary dictionaryWithDictionary: [jsonData objectForKey:@"result"]];
        
        [resultData setObject:[picData objectForKey:@"id"] forKey:@"id"];

        
    }
    
    return resultData;
    
}

#pragma mark Update Spots DB
-(void)updateSpotsDB{
    
    NSString *url_string = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/assets/mobilespots.db.gz"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                            
    AFHTTPRequestOperation *m_requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request] ;
    NSString* dirName = [self getCahchePathFileName:@"database"];
    [self createDirectory:dirName];
    NSString *path = [NSString stringWithFormat:@"%@/%@",dirName,@"mobilespots.db.gz"];
    
    
    m_requestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [m_requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSData* unZipData = [[NSData dataWithContentsOfFile:path] gunzippedData];
        NSString* dbPath = [NSString stringWithFormat:@"%@/%@",dirName,@"mobilespots.db"];
        if ([fileManager fileExistsAtPath:dbPath]) {
            [fileManager removeItemAtPath:dbPath error:nil];
        }
        
        [unZipData writeToFile:dbPath atomically:YES];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[NSDate date] forKey:kSpotDBUpdateDate];
        [ud synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [m_requestOperation start];
    
}


- (void) offlineSearchSpotText: (NSString*)term :(NSString*) lat :(NSString*) lng :(NSString*) latSW : (NSString*)latNE :(NSString*)lngSW :(NSString*)lngNE success:(void (^)(NSDictionary* resultSpotText))success
{
    

    dispatch_queue_t dqueue = dispatch_queue_create("com.diveboard.searchSpotText", 0);
    
    dispatch_async(dqueue, ^{
        
        sqlite3*	spotsDataBase;
        
        NSString* dirName = [self getCahchePathFileName:@"database"];
        NSString* dbPath = [NSString stringWithFormat:@"%@/%@",dirName,@"mobilespots.db"];
        
        if (sqlite3_open([dbPath UTF8String], &spotsDataBase) != SQLITE_OK) {
            
            sqlite3_close(spotsDataBase);
            spotsDataBase = NULL;
            NSCAssert1(0, @"Failed to open database_list with message '%s'.", sqlite3_errmsg(spotsDataBase));
        }
        
        NSMutableDictionary* resultSpotText = [[NSMutableDictionary alloc] init];
        
        NSMutableString* condition_str = [NSMutableString stringWithString:@""];
        
        if (term != nil && term.length > 0)
        {
            NSArray* strarr = [term componentsSeparatedByString:@" "];
            NSMutableString* match_str = [NSMutableString stringWithString:@""];
            for (int i = 0 ; i < strarr.count ; i++)
            {
                if (i != 0)
                    [match_str appendString:@" "];
                
                [match_str appendFormat:@"%@*",strarr[i]];
            }
            
            if (condition_str.length == 0)
                [condition_str appendFormat:@"spots_fts.name MATCH '%@'",match_str];
            else
                [condition_str appendFormat:@" AND spots_fts.name MATCH '%@'",match_str];
            
        }
        if (latSW != nil && latNE != nil && lngSW != nil && lngNE != nil)
        {
            if ([lngSW doubleValue] >= 0 && [lngNE doubleValue] < 0)
            {
                if (condition_str.length == 0){
                    
                    [condition_str appendFormat:@"(spots.lng BETWEEN %@ AND 180 AND SPOTS.lng BETWEEN 0 AND %@ AND spots.lat BETWEEN %@ AND %@)",lngSW,lngNE,latSW,latNE];
                    
                }else{
                    
                    [condition_str appendFormat:@" AND (spots.lng BETWEEN %@ AND 180 AND SPOTS.lng BETWEEN 0 AND %@ AND spots.lat BETWEEN %@ AND %@)",lngSW,lngNE,latSW,latNE];
                }
            }
            
            if (condition_str.length == 0)
            {
                [condition_str appendFormat:@"(spots.lng BETWEEN %@ AND %@ AND spots.lat BETWEEN %@ AND %@)",lngSW,lngNE,latSW,latNE];
            }else{
                [condition_str appendFormat:@" AND (spots.lng BETWEEN %@ AND %@ AND spots.lat BETWEEN %@ AND %@)",lngSW,lngNE,latSW,latNE];
            }
        }
        if (condition_str == 0){
            
            [condition_str appendFormat:@"(spots.private_user_id IS NULL OR spots.private_user_id = %@)",[AppManager sharedManager].loginResult.user.ID];
            
        }else{
            
            [condition_str appendFormat:@" AND (spots.private_user_id IS NULL OR spots.private_user_id = %@)",[AppManager sharedManager].loginResult.user.ID];
            
        }
        if (lat != nil && lng != nil)
        {
            
            double lat_sqr = pow([lat doubleValue], 2.0);
            
            [condition_str appendFormat:@" ORDER BY ((spots.lat - %@)*(spots.lat - %@)) + (MIN((spots.lng - %@)*(spots.lng - %@), (spots.lng - %@ + 360)*(spots.lng - %@ + 360), (spots.lng - %@ - 360)*(spots.lng - %@ - 360))) * (1 - (((spots.lat * spots.lat) + %f) / 8100)) ASC",lat,lat,lng,lng,lng,lng,lng,lng,lat_sqr];
            
        }
        
        NSString* strQuery = @"";
        if (term == nil && term.length == 0)
        {
            
            strQuery = [NSString stringWithFormat:@"SELECT id,name,location_name,country_name,lat,lng,private_user_id FROM spots WHERE %@ LIMIT 30",condition_str];
            
        }else{
            
            strQuery = [NSString stringWithFormat:@"SELECT spots_fts.docid, spots_fts.name, spots.location_name, spots.country_name, spots.lat, spots.lng FROM spots_fts, spots WHERE spots_fts.docid = spots.id AND %@ LIMIT 30",condition_str];
            
        }
        sqlite3_stmt* statement;
        
        NSMutableArray* arr_Spots = [[NSMutableArray alloc] init];
        if (sqlite3_prepare(spotsDataBase, [strQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSMutableDictionary* spotDic = [NSMutableDictionary dictionaryWithCapacity:9];
                
                [spotDic setObject:[NSNumber numberWithInt:sqlite3_column_int(statement,0)] forKey:@"id"];
                [spotDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"name"];
                [spotDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"location_name"];
                [spotDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)] forKey:@"country_name"];
                
                [spotDic setObject:[NSNumber numberWithDouble:sqlite3_column_double(statement,4)] forKey:@"lat"];
                [spotDic setObject:[NSNumber numberWithDouble:sqlite3_column_double(statement,5)] forKey:@"lng"];
                
                
                [arr_Spots addObject:[NSDictionary dictionaryWithDictionary:spotDic]];
            }
            
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        
        [resultSpotText setObject:@YES forKey:@"success"];
        [resultSpotText setObject:arr_Spots forKey:@"spots"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(sqlite3_close(spotsDataBase) != SQLITE_OK) {
                
                NSCAssert1(0, @"Error: failed to close database_list with message '%s'.", sqlite3_errmsg(spotsDataBase));
            }
            
            success(resultSpotText);
            
        });
        
    });
    
}



-(void) offlinesearchRegionLocaitonsLat:(NSString*)lat lng:(NSString*)lng dist:(NSString*)dist  success:(void (^)(NSDictionary* resultRegionLocations))success{

    dispatch_queue_t dqueue = dispatch_queue_create("com.diveboard.searchRegionLocations", 0);
    
    dispatch_async(dqueue, ^{
        
        sqlite3*	spotsDataBase;
        
        NSString* dirName = [self getCahchePathFileName:@"database"];
        NSString* dbPath = [NSString stringWithFormat:@"%@/%@",dirName,@"mobilespots.db"];
        
        if (sqlite3_open([dbPath UTF8String], &spotsDataBase) != SQLITE_OK) {
            
            sqlite3_close(spotsDataBase);
            spotsDataBase = NULL;
            NSCAssert1(0, @"Failed to open database_list with message '%s'.", sqlite3_errmsg(spotsDataBase));
        }

        
        NSMutableString* condition_str_country = [NSMutableString stringWithString:@""];
        NSMutableString* condition_str_reg = [NSMutableString stringWithString:@""];
        NSMutableString* condition_str_loc = [NSMutableString stringWithString:@""];
        NSString* NElat = @"";
        NSString* SWlat = @"";
        NSString* NElng = @"";
        NSString* SWlng = @"";
        double lat_d = [lat doubleValue];
        double lng_d = [lng doubleValue];
        double dist_d = [dist doubleValue];
        BOOL onEdge = NO;
        NSMutableDictionary* resultRegionLocations = [[NSMutableDictionary alloc] init];
        
     
        
        
        
        if(lat_d + dist_d < 90.0){
            
            NElat = [NSString stringWithFormat:@"%f",lat_d+dist_d];
        }
        else{
            NElat = @"90.0";
        }
        
        
        if(lat_d - dist_d > -90.0){
            SWlat = [NSString stringWithFormat:@"%f",lat_d-dist_d];
        }
        else{
            SWlat = @"-90.0";
        }
        
        
        if(lng_d + dist_d < 180.0){
            NElng =[NSString stringWithFormat:@"%f",lng_d + dist_d];
        }
        else{
            onEdge = YES;
            double add = lng_d + dist_d - 180.0;
            
            NElng = [NSString stringWithFormat:@"%f",(180.0 - add) * (-1)];
        }
        
        if(lng_d - dist_d > -180.0){
            SWlng = [NSString stringWithFormat:@"%f",lng_d - dist_d];

        }
        else{
            onEdge = YES;
            double add = lng_d - dist_d + 180.0;
            SWlng = [NSString stringWithFormat:@"%f",180.0 + add];
        }
        
        
        if(!onEdge)
        {

            [condition_str_country appendFormat:@"(spots.lng BETWEEN %@ AND %@ AND spots.lat BETWEEN %@ AND %@)",SWlng,NElng,SWlat,NElat];
            
            
            [condition_str_reg appendFormat:@"(spots.lng BETWEEN %@ AND %@ AND spots.lat BETWEEN %@ AND %@)",SWlng,NElng,SWlat,NElat];
            
            
            [condition_str_loc appendFormat:@"(spots.lng BETWEEN %@ AND %@ AND spots.lat BETWEEN %@ AND %@)",SWlng,NElng,SWlat,NElat];
        }
        else
        {
         
            [condition_str_country appendFormat:@"(spots.lng BETWEEN %@ AND 180 OR spots.lng BETWEEN -180 AND %@ AND spots.lat BETWEEN %@ AND %@)",SWlng,NElng,SWlat,NElat];
            
            
            
            [condition_str_reg appendFormat:@"(spots.lng BETWEEN %@ AND 180 OR spots.lng BETWEEN -180 AND %@ AND spots.lat BETWEEN %@ AND %@)",SWlng,NElng,SWlat,NElat];
            
            
            [condition_str_loc appendFormat:@"(spots.lng BETWEEN %@ AND 180 OR spots.lng BETWEEN -180 AND %@ AND spots.lat BETWEEN %@ AND %@)",SWlng,NElng,SWlat,NElat];
        }
        
        if (lat != nil && lng != nil)
        {
            double lat_sqr = pow([lat doubleValue], 2.0);
            
            [condition_str_country appendFormat:@" GROUP BY spots.country_id having count(*) > 2 ORDER BY MIN(MIN ((((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@)*(spots.lng - %@) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))),(((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@ + 360)*(spots.lng - %@ + 360) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))),(((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@ - 360)*(spots.lng - %@ - 360) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))))) ASC ",lat,lat,lng,lng,lat_sqr,lat,lat,lng,lng,lat_sqr,lat,lat,lng,lng,lat_sqr];
            
            
            [condition_str_reg appendFormat:@" GROUP BY regions.id having count(*) > 2 ORDER BY MIN(MIN ((((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@)*(spots.lng - %@) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))),(((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@ + 360)*(spots.lng - %@ + 360) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))),(((spots.lat - %@ )*(spots.lat - %@)) + ((spots.lng - %@ - 360)*(spots.lng - %@ - 360) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))))) ASC ",lat,lat,lng,lng,lat_sqr,lat,lat,lng,lng,lat_sqr,lat,lat,lng,lng,lat_sqr];
            
            
            [condition_str_loc appendFormat:@" GROUP BY spots.location_id having count(*) > 2 ORDER BY MIN(MIN ((((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@)*(spots.lng - %@) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))),(((spots.lat - %@)*(spots.lat - %@)) + ((spots.lng - %@ + 360)*(spots.lng - %@ + 360) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))),(((spots.lat - %@ )*(spots.lat - %@)) + ((spots.lng - %@ - 360)*(spots.lng - %@ - 360) * (1 - (((spots.lat * spots.lat) + %f) / 8100)))))) ASC ",lat,lat,lng,lng,lat_sqr,lat,lat,lng,lng,lat_sqr,lat,lat,lng,lng,lat_sqr];
            
        }
        
        
        NSString* cQuery = [NSString stringWithFormat:@"SELECT sql_1.*,countries.code FROM ( SELECT country_id,country_name FROM spots WHERE %@ LIMIT 10 ) AS sql_1,countries WHERE sql_1.country_id = countries.id ",condition_str_country];
        sqlite3_stmt* statement;

        NSMutableArray* arr_Countries = [[NSMutableArray alloc] init];
        if (sqlite3_prepare(spotsDataBase, [cQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSMutableDictionary* countryDic = [NSMutableDictionary dictionaryWithCapacity:9];
                
                    [countryDic setObject:[NSNumber numberWithInt:sqlite3_column_int(statement,0)] forKey:@"id"];
                    [countryDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"name"];
                    [countryDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)] forKey:@"code"];
                
                    [arr_Countries addObject:[NSDictionary dictionaryWithDictionary:countryDic]];
            }
            
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        if (arr_Countries.count == 0) {
            
            [self offlinesearchRegionLocaitonsLat:lat lng:lng dist:[NSString stringWithFormat:@"%f",dist_d*2]success:success];
        }

        [resultRegionLocations setObject:arr_Countries forKey:@"countries"];
        
    ///////////////
        NSString* rQuery = [NSString stringWithFormat:@"SELECT spots.region_id, regions.name FROM spots, regions WHERE spots.region_id = regions.id AND %@ LIMIT 10",condition_str_reg];
        
        NSMutableArray* arr_Regions = [[NSMutableArray alloc] init];
        if (sqlite3_prepare(spotsDataBase, [rQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSMutableDictionary* regionDic = [NSMutableDictionary dictionaryWithCapacity:9];
                
                [regionDic setObject:[NSNumber numberWithInt:sqlite3_column_int(statement,0)] forKey:@"id"];
                [regionDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"name"];
                
                [arr_Regions addObject:[NSDictionary dictionaryWithDictionary:regionDic]];
            }
            
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        
        if (arr_Regions.count == 0) {
            
            [self offlinesearchRegionLocaitonsLat:lat lng:lng dist:[NSString stringWithFormat:@"%f",dist_d*2]success:success];
        }
        
        [resultRegionLocations setObject:arr_Regions forKey:@"regions"];
        
    ////////////////

        
        
        NSString* lQuery = [NSString stringWithFormat:@"SELECT location_id,location_name FROM spots WHERE %@ LIMIT 10",condition_str_loc];
        NSMutableArray* arr_Locations = [[NSMutableArray alloc] init];
        
        if (sqlite3_prepare(spotsDataBase, [lQuery UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSMutableDictionary* locationDic = [NSMutableDictionary dictionaryWithCapacity:9];
                
                [locationDic setObject:[NSNumber numberWithInt:sqlite3_column_int(statement,0)] forKey:@"id"];
                [locationDic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)] forKey:@"name"];
                
                [arr_Locations addObject:[NSDictionary dictionaryWithDictionary:locationDic]];
            }
            
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        
        if (arr_Locations.count == 0) {
            
            [self offlinesearchRegionLocaitonsLat:lat lng:lng dist:[NSString stringWithFormat:@"%f",dist_d*2]success:success];
        }
        
        [resultRegionLocations setObject:arr_Locations forKey:@"locations"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(sqlite3_close(spotsDataBase) != SQLITE_OK) {
                
                NSCAssert1(0, @"Error: failed to close database_list with message '%s'.", sqlite3_errmsg(spotsDataBase));
            }
            
            success(resultRegionLocations);
            
        });
        
    });
    
        
}

- (void)clearCache{
    
    [fileManager removeItemAtPath:[self getCahchePathFileName:@""]  error:nil];
    
}




@end
