//
//  DataRequestManager.h
//  Diveboard
//
//  Created by Vladimir Popov on 4/5/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface DataRequestManager : NSObject

+ (instancetype) sharedManager;

- (void) loginRequestWithEmail:(NSString *)email
                      password:(NSString *)password
                        result:(void (^)(id result, NSError *error))result;


@end
