//
//  DiveEditSafetyStopsViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/20/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SafetyStopsEditViewDelegate <NSObject>

@optional

- (void)didChangeSafetyStops:(NSArray*)safetyStops;
- (void)didCancelSafetyStops;

@end

@interface DiveEditSafetyStopsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* m_safetyStops;
    IBOutlet UITableView* m_tableView;
    IBOutlet UIView* m_viewEdit;
    IBOutlet UITextField* m_txtDepth;
    IBOutlet UITextField* m_txtDuration;
    IBOutlet UIButton* m_btnUnit;
    
}
@property (nonatomic, strong) id<SafetyStopsEditViewDelegate> delegate;

-(id) initWithSafetyStops:(NSArray*)safetyStops;
-(void)setSafetyStops:(NSArray*)safetyStops;


- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onAddSafeStop:(id)sender;
- (IBAction)onChangeUnit;

@end
