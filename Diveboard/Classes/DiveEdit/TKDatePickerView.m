//
//  TKDatePickerView.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "TKDatePickerView.h"

@interface TKDatePickerView()
{
    UIDatePicker *datePicker;
    UIButton *dateDoneButton;
    UIButton *cancelButton;
    
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton     *dateDoneButton;
@property (nonatomic, strong) UIButton     *cancelButton;

@end

@implementation TKDatePickerView

@synthesize datePicker, dateDoneButton, cancelButton;

static TKDatePickerView *_sharedView;

- (id)initWithFrame:(CGRect)frame pickerMode:(UIDatePickerMode) pickerMode
{
    if (!_sharedView) {
        self = [super init];
        if (self) {
            [self initMethod];
        }
        _sharedView = self;
    }
    [_sharedView setFrame:frame];
    [_sharedView.datePicker setFrame:CGRectMake(0, 30, frame.size.width, frame.size.height - 30)];
    [_sharedView addDatePickerView:pickerMode];
    _dataMode = pickerMode;
    return _sharedView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) initMethod
{
    datePicker = [[UIDatePicker alloc] init];
    
    
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *currentDate = [NSDate date];
    //    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //    [comps setYear:0];
    //    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    //    [comps setYear:-100];
    //    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    //    [datePicker setMaximumDate:maxDate];
    //    [datePicker setMinimumDate:minDate];
    
    dateDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateDoneButton setBackgroundColor:[UIColor grayColor]];
    [dateDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [dateDoneButton.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
    [dateDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dateDoneButton addTarget:self action:@selector(datePickerDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundColor:[UIColor grayColor]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(datePickerCancelAction:) forControlEvents:UIControlEventTouchUpInside];

    [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.95]];
    [self addSubview:datePicker];
    [self addSubview:dateDoneButton];
    [self addSubview:cancelButton];
    
    [self setClipsToBounds:YES];

}

#pragma mark - UIDatePickerCustomize

- (void) addDatePickerView:(UIDatePickerMode)pickerMode;
{
    [_sharedView.dateDoneButton setFrame:CGRectMake(CGRectGetWidth(_sharedView.frame) - 75, 5, 70, 25)];
    [_sharedView.cancelButton setFrame:CGRectMake(5, 5, 70, 25)];
    [_sharedView.datePicker setDatePickerMode:pickerMode];
    _dataMode = pickerMode;
}

- (void) datePickerShow:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewShow:)]) {
        [self.delegate datePickerViewShow:self];
    }

    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectOffset(self.frame, 0, -CGRectGetHeight(self.frame))];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) datePickerHide:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectOffset(self.frame, 0, CGRectGetHeight(self.frame))];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewHide:)]) {
            [self.delegate datePickerViewHide:self];
        }
    }];
}

- (void) datePickerDoneAction:(id)sender
{
    NSDate *date = datePicker.date;
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewDoneAction:date:)]) {
        [self.delegate datePickerViewDoneAction:self date:date];
    }
    
    [self datePickerHide:sender];
}

- (void) datePickerCancelAction:(id)sender
{
    [self datePickerHide:sender];
}

- (void)show
{
    [self datePickerShow:Nil];
    
}

- (void) hide
{
    [self datePickerHide:nil];
}
@end
