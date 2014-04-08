//
//  main.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([DBAppDelegate class]));
        } @catch (NSException *exc) {
            NSDictionary *data = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"sample-value", nil]
                                                             forKeys:[NSArray arrayWithObjects:@"sample-key", nil]];
            BUGSENSE_LOG(exc, data);
        }
    }
}
