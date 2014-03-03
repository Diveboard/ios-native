//
//  DiveData.m
//  Diveboard
//
//  Created by Vladimir Popov on 12/27/13.
//  Copyright (c) 2013 Vladimir Popov. All rights reserved.
//

#import "DiveData1.h"

@implementation DiveData

@synthesize image, title, navController;

#pragma mark - DiveScrollerHeaderInfo

- (NSString*) diveTitle
{
    return self.title;
}


//- (NSString*) pageSubtitle
//{
//    return self.subtitle;
//}


#pragma mark - NSObject

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ 0x: %@", [self class], self, self.title];
}

@end
