//
//  DiveCountlineView.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/26/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <BugSense-iOS/BugSenseController.h>
#import "CMPopTipView.h"

@protocol DiveCountlineDelegate;

@interface DiveCountlineView : UIView
{
    int     maxValue;
    int     currentValue;
    IBOutlet UIView* m_viewBubble;
    IBOutlet UILabel* m_lblDateBubble;
    IBOutlet UILabel* m_lblCountryNameBubble;
    IBOutlet UILabel* m_lblTripNamBubblee;
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentDiveNum;
@property (strong, nonatomic) IBOutlet UILabel *lblMaxDiveNumb;
@property (nonatomic, readonly) CMPopTipView* tipView;


@property (strong, nonatomic) id<DiveCountlineDelegate> delegate;

- (void) setMaxValue:(int)value;
- (void) setCurrentValue:(int)value;

- (void) setLayoutWithPortrate;
- (void) setLayoutWithLandscape;

@end



@protocol DiveCountlineDelegate <NSObject>

@optional;
- (void) diveCountlineView:(DiveCountlineView *)diveCountlineView Number:(int)number;

@end