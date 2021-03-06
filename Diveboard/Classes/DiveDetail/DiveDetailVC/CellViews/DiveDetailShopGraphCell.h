//
//  DiveDetailShopGraphCell.h
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiveDetailBaseCell.h"

@protocol DiveDetailShopGraphCellDelegate <NSObject>

@optional
-(void) didClickedGraph;

@end

@interface DiveDetailShopGraphCell : DiveDetailBaseCell
{
    IBOutlet UILabel        *vdlblDiveShop;
    IBOutlet UILabel        *vdlblShopContent;
    IBOutlet UIImageView *imgviewShop;
    IBOutlet UILabel        *vdlblGraphTitle;
    IBOutlet UIImageView    *vdimgviewGraph;
    IBOutlet UILabel        *vdlblDepthTitle;
    IBOutlet UILabel        *vdlblDepth;

}

@property (nonatomic, strong) id<DiveDetailShopGraphCellDelegate> delegate;
- (IBAction)onTapGraph:(id)sender;

@end
