//
//  TKListPickerView.h
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKListPickerView;

@protocol TKListPickerViewDelegate <NSObject>

- (void) listPickerView:(TKListPickerView*)view selectedString:(NSString *)string index:(int)index targetLabel:(UILabel *)label;

@end

@interface TKListPickerView : UIView
{
    
}

@property (nonatomic, strong) id<TKListPickerViewDelegate> delegate;

- (id)initWithTarget:(UIView *)parentView title:(NSString *)title list:(NSArray *)list sender:(UILabel *)sender;
- (void) show;

@end
