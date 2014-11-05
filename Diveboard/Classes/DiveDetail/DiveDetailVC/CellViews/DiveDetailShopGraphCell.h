//
//  DiveDetailShopGraphCell.h
//  Diveboard
//
//  Created by SergeyPetrov on 11/2/14.
//  Copyright (c) 2014 threek. All rights reserved.
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
    IBOutlet AsyncUIImageView *imgviewShop;
    IBOutlet UILabel        *vdlblGraphTitle;
    IBOutlet UIImageView    *vdimgviewGraph;
    IBOutlet UILabel        *vdlblDepthTitle;
    IBOutlet UILabel        *vdlblDepth;

}

@property (nonatomic, strong) id<DiveDetailShopGraphCellDelegate> delegate;
- (IBAction)onTapGraph:(id)sender;

@end
