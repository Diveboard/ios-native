//
//  AsyncUIImageView.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
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
