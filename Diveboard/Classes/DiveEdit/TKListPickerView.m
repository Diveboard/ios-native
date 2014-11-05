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

- (id)initWithTitle:(NSString *)title list:(NSArray *)list
{
    
    float listHeight = 35.0f;
    CGRect rect = CGRectMake((self.frame.size.width - 220) / 2,
                             (self.frame.size.height - listHeight * (list.count + 2)) / 2,
                             220,
                             listHeight * (list.count + 2));

    self = [super initWithFrame:rect];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, listHeight)];
        [titleLabel setBackgroundColor:kMainDefaultColor];
        [titleLabel setFont:[UIFont fontWithName:kDefaultFontNameBold size:14.0f]];
        [titleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setFrame:CGRectOffset(titleLabel.frame, 0, listHeight)];
        [button.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:14.0f]];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setTitle:@"-" forState:(UIControlStateNormal)];
        [button setTag:buttonTag];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [button addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchDragOutside];

        [self addSubview:button];
        
        int index = 2;
        for (NSString *listTitle in list) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button setFrame:CGRectOffset(titleLabel.frame, 0, listHeight * index)];
            [button.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:14.0f]];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitle:listTitle forState:(UIControlStateNormal)];
            [button setTag:(buttonTag + index - 1)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [button addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchDragOutside];
            
            UIView* topBorder = [[UIView alloc] init];
            
            topBorder.frame = CGRectMake(0.0f, 0, button.frame.size.width, 1.0f);
            topBorder.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
            [button addSubview:topBorder];
            [self addSubview:button];
            index ++;
        }
        
        
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(listPickerView:selectedString:index:)]) {
        NSString *string = [[sender.titleLabel.text componentsSeparatedByString:@" ("] objectAtIndex:0];
        [self.delegate listPickerView:self selectedString:string index:index];
    }
}
-(void)buttonHighlight:(UIButton *)sender{
    
    [sender setBackgroundColor:kMainDefaultColor];
    
}
-(void)buttonNormal:(UIButton *)sender{
    
    [sender setBackgroundColor:[UIColor clearColor]];
    
}


@end
