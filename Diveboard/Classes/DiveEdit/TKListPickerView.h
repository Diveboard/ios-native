//
//  TKListPickerView.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BugSense-iOS/BugSenseController.h>


@class TKListPickerView;

@protocol TKListPickerViewDelegate <NSObject>

- (void) listPickerView:(TKListPickerView*)view selectedString:(NSString *)string index:(int)index ;

@end

@interface TKListPickerView : UIView
{
    
}

@property (nonatomic, strong) id<TKListPickerViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title list:(NSArray *)list;

@end
