//
//  DrawerMenuViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/14/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OSBlurSlideMenuController;
@interface DrawerMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* m_tableViewMenu;
    NSMutableArray *m_MenuArray;
    int m_CurrentMenuIndex;
    

}


@property (nonatomic, assign) BOOL isEditedDive;
@property (nonatomic, assign) BOOL isShowList;

-(void) toggleDrawerMenu;
- (void) setMenuIndex:(int)menuIndex;
+ (DrawerMenuViewController*)sharedMenu;
@end
