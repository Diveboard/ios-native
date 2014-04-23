//
//  DataRequestManager.m
//  Diveboard
//
//  Created by Vladimir Popov on 4/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//


#define kLoginResultFilename    @"loginResult.dat"

#import "DataRequestManager.h"

@interface DataRequestManager()
{
    
}

@end



@implementation DataRequestManager

static DataRequestManager *_sharedManager;
+ (instancetype)sharedManager
{
    if (!_sharedManager) {
        _sharedManager = [[DataRequestManager alloc] init];
    }
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *) getLocalDirectory:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return path;
}

- (void) loginRequestWithEmail:(NSString *)email
                      password:(NSString *)password
                        result:(void (^)(id result, NSError *error))result;
{
    
    
    NSString     *requestURLString = [NSString stringWithFormat:@"%@/api/login_email", SERVER_URL];
    NSDictionary *params = @{@"apikey"      : API_KEY,
                             @"flavour"     : FLAVOUR,
                             @"email"       : email,
                             @"password"    : password,
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (result) {
                result(responseObject, nil);
            }
        } else {
            if (result) {
                result(nil, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
}

- (id) getLocalLoginResult
{
    return nil;
}

@end
