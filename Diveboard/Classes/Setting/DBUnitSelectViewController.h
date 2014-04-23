//
//  DBUnitSelectViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BugSense-iOS/BugSenseController.h>


@protocol DBUnitSelectDelegate;

@interface DBUnitSelectViewController : UIViewController
{
    
}

@property (nonatomic, strong) id<DBUnitSelectDelegate> delegate;
@property int selectedIndex;


@property (strong, nonatomic) IBOutlet UIImageView *imgviewImperial;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewMetric;
@property (strong, nonatomic) IBOutlet UIButton *btnImperial;
@property (strong, nonatomic) IBOutlet UIButton *btnMetric;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)selectUnitAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end

@protocol DBUnitSelectDelegate <NSObject>

- (void) DBUnitSelectAction:(NSString *)unit;

@end