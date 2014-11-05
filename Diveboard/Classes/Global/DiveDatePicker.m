//
//  DiveDatePicker.m
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import "DiveDatePicker.h"

static DiveDatePicker* sharedInstance;

@implementation DiveDatePicker

@synthesize delegate;

+ (DiveDatePicker*)sharedInstance {
	
	if(sharedInstance == nil)
		sharedInstance = [[DiveDatePicker alloc] init];
	
    
	return sharedInstance;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (m_pickerMode == UIDatePickerModeTime) {
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
        [m_datePicker setLocale:locale];
        
    }else{
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"default"];
        [m_datePicker setLocale:locale];
        
    }
    
    [m_datePicker setDatePickerMode:m_pickerMode];
    
    
}

-(id)init{
    
    self = [super initWithNibName:@"DiveDatePicker" bundle:nil];
    if (self) {
        
    }
    return  self;
}
-(void)setDate:(NSDate *)date{
    
    [m_datePicker setDate:date];

}
-(void)setPickerMode:(UIDatePickerMode)pickerMode{
    
    m_pickerMode = pickerMode;
    
}

-(void)onDone{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
        [self.delegate didSelectedDate:m_datePicker.date];
    }
    
}
-(void)onCancel{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelDate)]) {
        [self.delegate didCancelDate];
    }
    
    
}




@end
