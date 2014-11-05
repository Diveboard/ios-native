//
//  RadioPickerViewController.h
//  Diveboard
//
//  Created by XingYing on 10/7/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioPickerViewControllerDelegate;


@interface RadioPickerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* m_tableView;
    NSArray* m_tableList;
    int m_selectedIndex;
}

@property (nonatomic, strong) id<RadioPickerViewControllerDelegate> delegate;

- (id)initWithList:(NSArray *)list selectedIndex:(int)selectedIndex;
- (IBAction)onCancel:(id)sender;

@end
@protocol RadioPickerViewControllerDelegate <NSObject>

@optional
-(void)didSelectRadioIndex:(int)selectedIndex pickerViewController:(RadioPickerViewController*) pickerViewController;
-(void)didCancelRadioPickerViewController:(RadioPickerViewController*) pickerViewController;

@end
