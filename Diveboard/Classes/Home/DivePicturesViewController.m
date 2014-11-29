//
//  DivePicturesViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/28/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DivePicturesViewController.h"
#import "DiveInformation.h"
#import "UIImageView+AFNetworking.h"
//#import "AsyncUIImageView.h"
#import "MRZoomScrollView.h"

#define kAnimationTime     0.3f

@interface DivePicturesViewController ()
{
    CGSize  rootSize;
    NSArray *divePictures;
    
    CGPoint touchStartPoint;
    
    UIView *mainImageView, *secondImageView;
    UIView *prevImageView, *nextImageView;
    
    NSMutableArray *imgviewArray;
    
    int currentPictureIndex;
    int nextPicIndex, prevPicIndex;
    int secondPictureIndex;
}

@end

@implementation DivePicturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithPicturesData:(NSArray *)pictures
{
    self = [super init];
    if (self) {
        divePictures = [NSArray arrayWithArray:pictures];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    rootSize  = viewMain.frame.size;
    [self initMethod0303];
    
}


- (void) initMethod0303 {
    
    imgviewArray = [[NSMutableArray alloc] init];
    int picCount = (int)divePictures.count;
    
    for (int i = 0; i < picCount; i ++) {
        DivePicture *picture = [divePictures objectAtIndex:(picCount - 1 - i)];
        
        if (picture.isLocal) {
            
            UIView* containerView = [[UIView alloc] initWithFrame:viewMain.frame];
            //            [containerView setBackgroundColor:[UIColor redColor]];
            [containerView setAlpha:0.0f];
            
            MRZoomScrollView *zoomView = [[MRZoomScrollView alloc] initWithFrame:viewMain.frame];
            
            [zoomView.imageView setContentMode:(UIViewContentModeScaleAspectFit)];
            [zoomView.imageView setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.2f]];
            
            [zoomView.imageView setImage:[[DiveOfflineModeManager sharedManager] getLocalDivePicture:picture.urlString]];
            
            [containerView addSubview:zoomView];
            [viewMain addSubview:containerView];
            
            [imgviewArray addObject:containerView];
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanGestureAction:)];
            [containerView addGestureRecognizer:panGesture];
            
        }else{
            
            UIView* containerView = [[UIView alloc] initWithFrame:viewMain.frame];
            [containerView setAlpha:0.0f];
            
            MRZoomScrollView *zoomView = [[MRZoomScrollView alloc] initWithFrame:viewMain.frame];
            
            [zoomView.imageView setContentMode:(UIViewContentModeScaleAspectFit)];
            [zoomView.imageView setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.2f]];
            
            UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            [indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
            
            [indicator setCenter:containerView.center];
            [indicator startAnimating];
            [zoomView addSubview:indicator];
            
            UIImageView *imgview = zoomView.imageView;
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:picture.urlString]];
            
            [zoomView.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                [imgview setImage:image];
                [indicator stopAnimating];
                
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
                [imgview setImage:[[DiveOfflineModeManager sharedManager] getImageWithUrl:request.URL.absoluteString]];
                [indicator stopAnimating];
                
            }];
            
            [containerView addSubview:zoomView];
            [viewMain addSubview:containerView];
            
            [imgviewArray addObject:containerView];
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanGestureAction:)];
            [containerView addGestureRecognizer:panGesture];
            
            
        }
    }
    

}

-(void)viewWillLayoutSubviews
{
    
    MRZoomScrollView* zoomView = [mainImageView subviews][0];
    [zoomView setZoomScale:zoomView.minimumZoomScale];
    rootSize  = viewMain.frame.size;
    
    [mainImageView setFrame:viewMain.frame];
    [zoomView setFrame:mainImageView.frame];
    [zoomView setContentSize:zoomView.imageView.frame.size];
    
}

- (void)showPictureWithIndex:(int)index
{
    int picCount = (int)divePictures.count;
    currentPictureIndex = picCount - 1 - index;
    prevPicIndex = currentPictureIndex + 1;
    nextPicIndex = currentPictureIndex - 1;
    
    mainImageView = [imgviewArray objectAtIndex:currentPictureIndex];
    [mainImageView setFrame:viewMain.bounds];
    [mainImageView setAlpha:1.0f];
    prevImageView = (prevPicIndex < picCount ? [imgviewArray objectAtIndex:prevPicIndex] : nil);
    nextImageView = (nextPicIndex >= 0       ? [imgviewArray objectAtIndex:nextPicIndex] : nil);

}

- (void) imagePanGestureAction:(UIPanGestureRecognizer *)sender
{
    
    CGPoint translatedPoint = [sender translationInView:self.view];
    
//    NSLog(@"pan X:%f, Y:%f", translatedPoint.x, translatedPoint.y);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        touchStartPoint = mainImageView.center;
    }
    
    float dx = translatedPoint.x / 4;
    float dy = dx * (rootSize.height / rootSize.width);
    CGRect rect1 = CGRectInset(CGRectMake(0, 0, rootSize.width, rootSize.height), dx, dy); // main image zoom out
    CGRect rect2 = CGRectMake(translatedPoint.x, 0, rootSize.width, rootSize.height);      // main image left slide
    CGRect rect3 = CGRectMake(translatedPoint.x - rootSize.width, 0, rootSize.width, rootSize.height);  // second image right slide
    CGRect rect4 = CGRectInset(CGRectMake(rootSize.width * 0.2, rootSize.height * 0.2, rootSize.width * 0.6, rootSize.height * 0.6), dx, dy); // second image zoom in
    float alpha1 = (rootSize.width - translatedPoint.x) / rootSize.width;  // main image fade out
    float alpha2 = -translatedPoint.x / rootSize.width;                     // second image fade in
    
    if (translatedPoint.x > 0) {  // ->
        
        
        [mainImageView setFrame:rect1];
        [mainImageView setAlpha:alpha1];
        
        if (prevImageView) {
            [prevImageView setFrame:rect3];
        }

        
    } else {        // <-
        
        [mainImageView setFrame:rect2];
        
        if (nextImageView) {
            [nextImageView setFrame:rect4];
            [nextImageView setAlpha:alpha2];
        }
        
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.15 * [sender velocityInView:self.view].x);
        
        if (velocityX > 100) {   // ->
            if (currentPictureIndex < (divePictures.count - 1)) {
                [self slideAnimationToFadeOut:mainImageView swapView:YES];
                if (prevImageView) {
                    [self slideAnimationToRight:prevImageView swapView:NO];
                    
                }
            } else {  //if ( currentPictureIndex == 0 )
                [self slideAnimationToRight:mainImageView swapView:NO];
                
            }
            
        } else if (velocityX < -100) {  //  <-
            if (currentPictureIndex > 0) {
                [self slideAnimationToLeft:mainImageView swapView:YES];
                if (nextImageView) {
                    [self slideAnimationToFadeIn:nextImageView swapView:NO];
                }
                
            } else {
                [self slideAnimationToRight:mainImageView swapView:NO];
            }
            
        } else if (mainImageView.frame.origin.x < -rootSize.width * 0.4) {   // <|-
            
            if (currentPictureIndex > 0) {
                [self slideAnimationToLeft:mainImageView swapView:YES];
                if (nextImageView) {
                    [self slideAnimationToFadeIn:nextImageView swapView:NO];
                }
                
            } else {
                [self slideAnimationToRight:mainImageView swapView:NO];
            }
            
        } else if (mainImageView.frame.origin.x > rootSize.width * 0.2) {   // -|>
            
            if (currentPictureIndex < (divePictures.count - 1)) {
                [self slideAnimationToFadeOut:mainImageView swapView:YES];
                if (prevImageView) {
                    [self slideAnimationToRight:prevImageView swapView:NO];
                    
                }
            } else {  //if ( currentPictureIndex == 0 )
                [self slideAnimationToRight:mainImageView swapView:NO];
                
            }
            
        } else {    // restore
            
            [self slideAnimationToRight:mainImageView swapView:NO];
            if (prevImageView) {
                [self slideAnimationToLeft:prevImageView swapView:NO];
            }
            if (nextImageView) {
                [self slideAnimationToFadeOut:nextImageView swapView:NO];
            }
        }
    }

}

- (void) setSecondImageIndex:(int)index
{
    if (index < 0 || index >= divePictures.count) {
        return;
    }
    
    if (secondPictureIndex != index) {
        NSLog(@"turn!");
        
        secondPictureIndex = index;
        secondImageView = [imgviewArray objectAtIndex:index];
        NSLog(@"current index : %d, second index : %d", currentPictureIndex, secondPictureIndex);
//        DivePicture *picture1 = [divePictures objectAtIndex:secondPictureIndex];
//        [secondImageView setImageWithURL:[NSURL URLWithString:picture1.largeURL]];
//                        placeholderImage:[UIImage imageNamed:@"preload"]];
//        [secondImageView loadImageFromURL:[NSURL URLWithString:picture1.largeURL]];
        
    }
}

- (void) slideAnimationToLeft:(UIView *)view swapView:(BOOL)flag
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        CGRect rect = CGRectMake(-rootSize.width, 0, rootSize.width, rootSize.height);
        [view setFrame:rect];
        
        
    } completion:^(BOOL finished) {
        if (flag) {
            [self swapViewWithIncrease:-1];
        }
    }];
}

- (void) slideAnimationToRight:(UIView *)view swapView:(BOOL)flag
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        CGRect rect = CGRectMake(0, 0, rootSize.width, rootSize.height);
        [view setAlpha:1.0f];
        [view setFrame:rect];
        
        MRZoomScrollView* zoomView = [view subviews][0];
        [zoomView setFrame:view.frame];
        [zoomView setContentSize:zoomView.imageView.frame.size];
        
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) slideAnimationToFadeOut:(UIView *)view swapView:(BOOL)flag
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        CGRect rect = CGRectMake(rootSize.width * 0.2, rootSize.height * 0.2, rootSize.width * 0.6, rootSize.height * 0.6);
        [view setFrame:rect];
        [view setAlpha:0];
    } completion:^(BOOL finished) {
        if (flag) {
            [self swapViewWithIncrease:1];
        }
    }];
}

- (void) slideAnimationToFadeIn:(UIView *)view swapView:(BOOL)flag
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        CGRect rect = CGRectMake(0, 0, rootSize.width, rootSize.height);
        [view setFrame:rect];
        
        MRZoomScrollView* zoomView = [view subviews][0];
        [zoomView setFrame:view.frame];
        [zoomView setContentSize:zoomView.imageView.frame.size];
        
        [view setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) swapViewWithIncrease:(int)inc
{
    currentPictureIndex += inc;
    if (0 <= currentPictureIndex && currentPictureIndex < divePictures.count) {
        mainImageView = [imgviewArray objectAtIndex:currentPictureIndex];
        if (currentPictureIndex > 0) {
            nextImageView = [imgviewArray objectAtIndex:(currentPictureIndex - 1)];
        } else {
            nextImageView = nil;
        }
        if (currentPictureIndex < (divePictures.count - 1)) {
            prevImageView = [imgviewArray objectAtIndex:(currentPictureIndex + 1)];
        } else {
            prevImageView = nil;
        }
    }
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
