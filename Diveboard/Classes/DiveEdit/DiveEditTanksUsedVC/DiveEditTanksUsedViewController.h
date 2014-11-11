//
//  DiveEditTanksUsedViewController.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/22/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiveEditTanksUsedViewDelegate <NSObject>

@optional

- (void)didChangeTanksUsed:(NSArray*)tanks;
- (void)didCancelTanksUsed;

@end

@interface DiveEditTanksUsedViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView* m_tableView;
    IBOutlet UIView* m_viewEdit;
    
   IBOutlet UIButton* m_btnCylinderCount;
   IBOutlet UIButton* m_btnCylinderUnit;
   IBOutlet UIButton* m_btnVolumeUnit;
   IBOutlet UIButton* m_btnGasMix;
   IBOutlet UIButton* m_btnEndPressureUnit;
    
    IBOutlet UITextField* m_txtVolume;
    IBOutlet UITextField* m_txtStartPressure;
    IBOutlet UITextField* m_txtEndPressure;
    IBOutlet UITextField* m_txtStartTime;
    NSMutableArray* m_tanks;
    NSIndexPath* m_indexPath;
    
    IBOutlet UILabel* m_lblO2;
    IBOutlet UILabel* m_lblHe;
    IBOutlet UITextField* m_txtO2;
    IBOutlet UITextField* m_txtHe;
    
    IBOutlet UIView*    m_viewStartTimeRow;
    
}

@property (nonatomic, strong) id<DiveEditTanksUsedViewDelegate> delegate;

- (id) initWithTanks:(NSArray*)tanks;
- (void)setTanksUsed:(NSArray *)tanks;
- (IBAction)onAddTank:(id)sender;
- (IBAction)onOk:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onDropDown:(id)sender;
@end
