//
//  DiveDetailBaseCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailBaseCell.h"

@implementation DiveDetailBaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    m_DiveInformation = diveInfo;
}

-(float)getHeight
{
    float height = self.frame.size.height;

    if (height < 30) {
        height = 30;
    }
    return height;
}

@end
