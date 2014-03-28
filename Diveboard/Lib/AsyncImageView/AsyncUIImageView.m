//
//  AsyncUIImageView.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "AsyncUIImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"


@interface AsyncUIImageView()
{
    UIActivityIndicatorView *spinny;
}

@end

static ImageCache *imageCache = nil;

@implementation AsyncUIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addIndicator];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) addIndicator {
    spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.center = self.center;
    spinny.hidesWhenStopped = YES;
	[spinny startAnimating];
    [self addSubview:spinny];

}

- (void) setIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    if (spinny) {
        spinny.activityIndicatorViewStyle = style;
    }
}

- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)image
{
    if (connection != nil) {
        [connection cancel];
        connection = nil;
    }
    if (data != nil) {
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    urlString = [[url absoluteString] copy];
    self.image = [imageCache imageForKey:urlString];
    if (image != nil) {
        [self setImage:image];
        [spinny removeFromSuperview];
        spinny = nil;
        return;
    } else {
		// Use a default placeholder when no cached image is found
//        [self setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
	}
    
#define SPINNY_TAG 5555
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {

    connection = nil;
    
    [spinny removeFromSuperview];
    spinny = nil;
    self.image = [UIImage imageWithData:data];
    
    [imageCache insertImage:self.image withSize:[data length] forKey:urlString];
    data = nil;
}

@end
