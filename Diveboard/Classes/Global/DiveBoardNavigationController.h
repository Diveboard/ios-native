//
//  DiveBoardNavigationController.h
//  Diveboard
//
//  Created by Vladimir Popov on 5/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiveBoardNavigationController : UINavigationController

@property (nonatomic) int   sudoID;

- (id)initWithRootViewController:(UIViewController *)rootViewController sudoID:(int)sudoID;

@end
