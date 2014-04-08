//
//  Global.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "Global.h"
//#import "LoginResult.h"


@implementation Global

@end


#pragma mark - AppManager class

@implementation AppManager

static AppManager *_sharedManager;
+ (AppManager *) sharedManager
{
    if (!_sharedManager) {
        _sharedManager = [[AppManager alloc] init];
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [BugSenseController sharedControllerWithBugSenseAPIKey:@"6ab17859"
                                                userDictionary:nil
                                               sendImmediately:YES];
        [BugSenseController setLogMessagesCount:10];
        [BugSenseController setLogMessagesLevel:8];
        
    }
    return self;
}

@end


#pragma mark - GlobalMethods class

@implementation GlobalMethods

+ (void) setRoundView:(UIView *)view cornorRadious:(float)rad borderColor:(UIColor *)color border:(float)border
{
    view.layer.cornerRadius = rad;
    view.layer.masksToBounds = YES;
    view.layer.borderColor  = color.CGColor;
    view.layer.borderWidth  = border;
}

@end