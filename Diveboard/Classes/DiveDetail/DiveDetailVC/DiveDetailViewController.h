//
//  DiveDetailViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiveDetailViewControllerDelegate <NSObject>

@optional

-(void) didClickedEditButton;
-(void) didClickedDeleteButton;

@end

@interface DiveDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UIView         *vdTopBox;
    IBOutlet UIImageView *vdimgUserAvator;
    IBOutlet UILabel        *vdlblNickname;
    IBOutlet UILabel        *vdlblCountry;
    IBOutlet UIButton       *vdbtnEdit;
    IBOutlet UIButton       *vdbtnDelete;
    IBOutlet UITableView    *m_tableView;
    
}

@property (nonatomic, strong) id<DiveDetailViewControllerDelegate> delegate;

- (IBAction)diveEditAction:(id)sender;
- (IBAction)diveDeleteAction:(id)sender;
- (id)initWithDiveInformation:(DiveInformation *) diveInfo;

- (void) setDiveInformation: (DiveInformation *) diveInfo;
- (void) showDetailData;


@end
