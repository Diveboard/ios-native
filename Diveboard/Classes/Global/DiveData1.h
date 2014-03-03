//
//  DiveData.h
//  Diveboard
//
//  Created by Vladimir Popov on 12/27/13.
//  Copyright (c) 2013 Vladimir Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiveData : NSObject{
    
}

// some properties for our pages
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) bool isImageOnly;

// an example of using UINavigationController as the owner of the page.
@property (nonatomic, retain) UINavigationController *navController;


@end