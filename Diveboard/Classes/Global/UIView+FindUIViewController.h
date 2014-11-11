//
//  UIView+FindUIViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 10/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;

@end
