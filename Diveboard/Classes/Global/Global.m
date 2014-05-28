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
        
    }
    return self;
}

- (void)setLoadedDives:(NSMutableDictionary *)loadedDives
{
    if (_currentSudoID > 0) {
        loadedDivesofSudo = loadedDives;
    }
    else {
        loadedDivesofMaster = loadedDives;
    }
}

- (NSMutableDictionary *)loadedDives
{
    if (_currentSudoID > 0) {
        return loadedDivesofSudo;
    }
    else {
        return loadedDivesofMaster;
    }
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

+ (NSString *)encodeValueToFloat:(NSString *)value
{
    
    return nil;
}
@end