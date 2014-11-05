//
//  DiveDatePicker.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiveDatePickerDelegate<NSObject>

@optional
-(void) didSelectedDate :(NSDate*)date;
-(void) didCancelDate;


@end
@interface DiveDatePicker : UIViewController
{
    IBOutlet UIDatePicker *m_datePicker;
    UIDatePickerMode m_pickerMode;
    
}
@property (nonatomic, assign) id<DiveDatePickerDelegate> delegate;

+ (DiveDatePicker*)sharedInstance;

- (IBAction) onDone;

-(IBAction) onCancel;

-(void)setDate:(NSDate*)date;
-(void)setPickerMode:(UIDatePickerMode)pickerMode;



@end
