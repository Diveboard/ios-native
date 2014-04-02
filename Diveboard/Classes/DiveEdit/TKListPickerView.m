//
//  TKListPickerView.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#define buttonTag       120

#import "TKListPickerView.h"

@interface TKListPickerView()
{
    UILabel *targetLabel;
}

@end
@implementation TKListPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTarget:(UIView *)parentView title:(NSString *)title list:(NSArray *)list sender:(UILabel *)sender
{
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.3f];
        [self setAlpha:0];
        
        float listHeight = 35.0f;
        CGRect rect = CGRectMake((self.frame.size.width - 220) / 2,
                                 (self.frame.size.height - listHeight * (list.count + 2)) / 2,
                                 220,
                                 listHeight * (list.count + 2));
        UIView *listView = [[UIView alloc] initWithFrame:rect];
        [listView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, listHeight)];
        [titleLabel setBackgroundColor:kMainDefaultColor];
        [titleLabel setFont:[UIFont fontWithName:kDefaultFontNameBold size:14.0f]];
        [titleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [titleLabel setText:title];
        [listView addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setFrame:CGRectOffset(titleLabel.frame, 0, listHeight)];
        [button.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:14.0f]];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setTitle:@"-" forState:(UIControlStateNormal)];
        [button setTag:buttonTag];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [listView addSubview:button];
        
        int index = 2;
        for (NSString *listTitle in list) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button setFrame:CGRectOffset(titleLabel.frame, 0, listHeight * index)];
            [button.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:14.0f]];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitle:listTitle forState:(UIControlStateNormal)];
            [button setTag:(buttonTag + index - 1)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [listView addSubview:button];
            index ++;
        }
        
        targetLabel = sender;
        [self addSubview:listView];
        [parentView addSubview:self];
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

- (void) buttonAction:(UIButton *)sender
{
    int index = sender.tag - buttonTag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(listPickerView:selectedString:index:targetLabel:)]) {
        NSString *string = [[sender.titleLabel.text componentsSeparatedByString:@" ("] objectAtIndex:0];
        [self.delegate listPickerView:self selectedString:string index:index targetLabel:targetLabel];
    }
    [self hide];
}

- (void) show
{
    [UIView animateWithDuration:0.3f animations:^{
        [self setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hide
{
    [UIView animateWithDuration:0.3f animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

@end
