//
//  NSObject_DiveHeaderInfo.h
//  Diveboard
//
//  Created by Vladimir Popov on 12/28/13.
//  Copyright (c) 2013 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DiveHeaderInfo <NSObject>

@optional
- (NSString*) diveTrip_name;
- (NSDate*) diveDate;

@end