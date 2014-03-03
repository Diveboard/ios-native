//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
//

#import <UIKit/UIKit.h>

//@class AppManager;

@interface AsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
	UIImage* image;
}

@property (nonatomic, retain) UIImage* image;
//@property(readwrite)int is_post;

-(void)loadImageFromURL:(NSURL*)url;

@end
