//
//  DiveListViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/26/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#import <BugSense-iOS/BugSenseController.h>

#import "DiveCountlineView.h"
#import "OneDiveView.h"
#import "iCarousel.h"

@interface DiveListViewController : UIViewController <DiveCountlineDelegate, OneDiveViewDelegate,  UIScrollViewDelegate, MFMailComposeViewControllerDelegate, iCarouselDataSource, iCarouselDelegate>
{
    
    
    
}
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCoordinate;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewBackground;

@property (nonatomic, strong)  NSMutableArray *preloadRequestManagers;


- (IBAction)menuAction:(id)sender;

- (void)setCoordinateValue:(DiveInformation *)diveInfoOfSelf;

- (void) diveViewsUpdate;
- (void) updateUnit;
- (void) refreshAction;
- (void) currentDiveViewUpdate;


@end
