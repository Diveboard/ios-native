//
//  AsyncUIImageView.h
//  Diveboard
//
//  Created by threek on 3/3/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncUIImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary

}

- (void) setImageURL:(NSURL *)url placeholder:(UIImage *)image;
- (void) setIndicatorStyle:(UIActivityIndicatorViewStyle)style;

@end
