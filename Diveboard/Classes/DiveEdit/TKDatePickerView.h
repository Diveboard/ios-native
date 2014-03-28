//
//  TKDatePickerView.h
//  Diveboard
//
//  Created by threek on 3/7/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKDatePickerView;

@protocol TKDatePickerViewDelegate <NSObject>

- (void) datePickerViewShow:(TKDatePickerView *)view;
- (void) datePickerViewHide:(TKDatePickerView *)view;
- (void) datePickerViewDoneAction:(TKDatePickerView *)view date:(NSDate *) date;

@end

@interface TKDatePickerView : UIView
{
    
}

@property (nonatomic, strong) id<TKDatePickerViewDelegate> delegate;
@property (nonatomic, readonly)       UIDatePickerMode dataMode;

- (id)initWithFrame:(CGRect)frame pickerMode:(UIDatePickerMode) pickerMode;
- (void) show;
- (void) hide;

@end
