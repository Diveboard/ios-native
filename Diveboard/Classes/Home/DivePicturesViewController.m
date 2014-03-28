//
//  DivePicturesViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/28/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DivePicturesViewController.h"
#import "DiveInformation.h"
//#import "UIImageView+AFNetworking.h"
#import "AsyncImageView.h"
#import "AsyncUIImageView.h"


#define kAnimationTime     0.3f

@interface DivePicturesViewController ()
{
    CGSize  rootSize;
    NSArray *divePictures;
    
    CGPoint touchStartPoint;
//    UIImageView *mainImageView, *secondImageView;
//    AsyncImageView *mainImageView, *secondImageView;
    AsyncUIImageView *mainImageView, *secondImageView;
    AsyncUIImageView *prevImageView, *nextImageView;
    
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

//- (void) initMethod
//{
////    mainImageView = [[UIImageView alloc] initWithFrame:viewMain.frame];
//    mainImageView = [[AsyncImageView alloc] initWithFrame:viewMain.frame]; // contentMode:(UIViewContentModeScaleAspectFit)];
//    mainImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [viewMain insertSubview:mainImageView belowSubview:btnClose];
//    DivePicture *picture = [divePictures objectAtIndex:0];
////    [mainImageView setImageWithURL:[NSURL URLWithString:picture.largeURL]];
////                  placeholderImage:[UIImage imageNamed:@"preload"]];
//    [mainImageView loadImageFromURL:[NSURL URLWithString:picture.largeURL]];
//    currentPictureIndex = 0;
//    
//    [mainImageView setUserInteractionEnabled:YES];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanGestureAction:)];
//    [mainImageView addGestureRecognizer:panGesture];
//    
//    if (divePictures.count > 1) {
////        secondImageView = [[UIImageView alloc] initWithFrame:viewMain.frame];
//        secondImageView = [[AsyncImageView alloc] initWithFrame:viewMain.frame]; // contentMode:(UIViewContentModeScaleAspectFit)];
//        
//        secondImageView.contentMode = UIViewContentModeScaleAspectFit;
//        secondImageView.userInteractionEnabled = NO;
//        [viewMain insertSubview:secondImageView belowSubview:mainImageView];
//        DivePicture *picture1 = [divePictures objectAtIndex:1];
////        [secondImageView setImageWithURL:[NSURL URLWithString:picture1.largeURL]];
////                      placeholderImage:[UIImage imageNamed:@"preload"]];
//        [secondImageView loadImageFromURL:[NSURL URLWithString:picture1.largeURL]];
//        secondPictureIndex = 1;
//        
//        UIPanGestureRecognizer *panGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanGestureAction:)];
//        [secondImageView addGestureRecognizer:panGesture1];
//
//    }
//}

- (void) initMethod0303 {
    imgviewArray = [[NSMutableArray alloc] init];
    int picCount = divePictures.count;
    
    for (int i = 0; i < picCount; i ++) {
        DivePicture *picture = [divePictures objectAtIndex:(picCount - 1 - i)];
        CGRect rect = CGRectMake(rootSize.width * 0.2, rootSize.height * 0.2, rootSize.width * 0.6, rootSize.height * 0.6);
        AsyncUIImageView *imgview = [[AsyncUIImageView alloc] initWithFrame:rect];
        [imgview setAlpha:0.0f];
        [imgview setContentMode:(UIViewContentModeScaleAspectFit)];
        [imgview setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.2f]];
        [imgview setIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        [imgview setImageURL:[NSURL URLWithString:picture.largeURL] placeholder:nil];
//        [imgview loadImageFromURL:[NSURL URLWithString:picture.largeURL]];
        [imgview setUserInteractionEnabled:YES];
        [viewMain addSubview:imgview];
        [imgviewArray addObject:imgview];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanGestureAction:)];
        [imgview addGestureRecognizer:panGesture];
        
    }
    
//    [self showPictureWithIndex:0];
//    
//    currentPictureIndex = picCount - 1;
//    prevPicIndex = currentPictureIndex + 1;
//    nextPicIndex = currentPictureIndex - 1;
//    
//    mainImageView = [imgviewArray lastObject];
//    [mainImageView setFrame:viewMain.bounds];
//    [mainImageView setAlpha:1.0f];
//    prevImageView = nil;
//    nextImageView = (imgviewArray.count > 1 ? [imgviewArray objectAtIndex:nextPicIndex] : nil);
//    
//    AsyncUIImageView *imgview = [imgviewArray lastObject];
//    [imgview setFrame:viewMain.bounds];
//    [imgview setAlpha:1.0f];
//    
//    mainImageView = imgview;
//    [mainImageView setUserInteractionEnabled:YES];
//    if (picCount > 1) {
//        AsyncUIImageView *imgview = [imgviewArray objectAtIndex:(picCount - 2)];
//        secondImageView = imgview;
//    } else {
//        secondImageView = nil;
//    }

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    rootSize  = viewMain.frame.size;
//    for (AsyncUIImageView *view in imgviewArray) {
//        view.center = viewMain.center;
//    }
    [mainImageView setFrame:viewMain.frame];
//    [secondImageView setFrame:viewMain.frame];
}

- (void)showPictureWithIndex:(int)index
{
    int picCount = divePictures.count;
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
        
//        [self setSecondImageIndex:(currentPictureIndex - 1)];
//        
//        [mainImageView setFrame:rect1];
//        [mainImageView setAlpha:alpha1];
//        
//        if (currentPictureIndex > 0) {
//            [viewMain bringSubviewToFront:secondImageView];
//            [secondImageView setFrame:rect3];
//        }
        
        [mainImageView setFrame:rect1];
        [mainImageView setAlpha:alpha1];
        
        if (prevImageView) {
            [prevImageView setFrame:rect3];
        }

        
    } else {        // <-
        
//        [self setSecondImageIndex:(currentPictureIndex + 1)];
//        [viewMain bringSubviewToFront:mainImageView];
//        [mainImageView setFrame:rect2];
//        
//        if (currentPictureIndex < (divePictures.count - 1)) {
//            [secondImageView setFrame:rect4];
//            [secondImageView setAlpha:alpha2];
//        }
        [mainImageView setFrame:rect2];
        
        if (nextImageView) {
            [nextImageView setFrame:rect4];
            [nextImageView setAlpha:alpha2];
        }
        
    }
    
//    if ([sender state] == UIGestureRecognizerStateEnded) {
//        CGFloat velocityX = (0.15 * [sender velocityInView:self.view].x);
//        
//        if (velocityX > 100) {   // ->
//            if (currentPictureIndex > 0) {
//                [self slideAnimationToFadeOut:mainImageView swapView:YES];
//                if (secondPictureIndex < divePictures.count) {
//                    [self slideAnimationToRight:secondImageView swapView:NO];
//
//                }
//            } else {  //if ( currentPictureIndex == 0 )
//                [self slideAnimationToRight:mainImageView swapView:NO];
//                
//            }
//            
//        } else if (velocityX < -100) {  //  <-
//            if (currentPictureIndex < (divePictures.count - 1)) {
//                [self slideAnimationToLeft:mainImageView swapView:YES];
//                if (secondPictureIndex < divePictures.count) {
//                    [self slideAnimationToFadeIn:secondImageView swapView:NO];
//                }
//
//            } else {
//                [self slideAnimationToRight:mainImageView swapView:NO];
//            }
//            
//        } else if (mainImageView.frame.origin.x < -rootSize.width * 0.4) {   // <|-
//            
//            if (currentPictureIndex < (divePictures.count - 1)) {
//                [self slideAnimationToLeft:mainImageView swapView:YES];
//                if (secondPictureIndex < divePictures.count) {
//                    [self slideAnimationToFadeIn:secondImageView swapView:NO];
//                }
//                
//            } else {
//                [self slideAnimationToRight:mainImageView swapView:NO];
//            }
//            
//            
//        } else if (mainImageView.frame.origin.x > rootSize.width * 0.2) {   // -|>
//            
//            if (currentPictureIndex > 0) {
//                [self slideAnimationToFadeOut:mainImageView swapView:YES];
//                if (secondPictureIndex < divePictures.count) {
//                    [self slideAnimationToRight:secondImageView swapView:NO];
//                    
//                }
//            } else {  //if ( currentPictureIndex == 0 )
//                [self slideAnimationToRight:mainImageView swapView:NO];
//                
//            }
//            
//        } else {    // restore
//            
//            [self slideAnimationToRight:mainImageView swapView:NO];
//            if (currentPictureIndex > secondPictureIndex) {
//                [self slideAnimationToLeft:secondImageView swapView:NO];
//            } else {
//                [self slideAnimationToFadeOut:secondImageView swapView:NO];
//            }
//        }
//        
//    }
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
        [view setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) swapViewWithIncrease:(int)inc
{
//    id temp = mainImageView;
//    mainImageView = secondImageView;
//    secondImageView = temp;
//    secondPictureIndex = currentPictureIndex;
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
//    [mainImageView setUserInteractionEnabled:YES];
//    [secondImageView setUserInteractionEnabled:NO];
//    secondImageView.image = nil;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
