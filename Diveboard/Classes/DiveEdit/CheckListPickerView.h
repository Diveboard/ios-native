//
//  CheckListPickerViewController.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/18/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckListPickerViewDelegate <NSObject>

@optional

- (void) didCheckedSelectedItems:(NSArray*)selectedItems;
- (void) didCancelCheckList;

@end

@interface CheckListPickerView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, strong) id<CheckListPickerViewDelegate> delegate;



- (id)initWithTitle:(NSString *)title list:(NSArray *)list checkedIndexList:(NSArray *)checkedIndexList;

@end
