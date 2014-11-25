//
//  DiveDetailBuddiesCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailBuddiesCell.h"
#import "UIImageView+AFNetworking.h"
@implementation DiveDetailBuddiesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{

    [super setDiveInformation:diveInfo];
    
    for (UIView* v in m_scrollView.subviews) {
        [v removeFromSuperview];
    }
    
    float ww = 90, hh = 110;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        ww = 120;
        hh = 140;
    }
    CGRect buddiesFrame = m_scrollView.frame;
    buddiesFrame.size.height = hh;

    [m_scrollView setFrame:buddiesFrame];
    
    float ox = 0;
    [m_DiveInformation.buddies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Buddy *buddy = (Buddy *)obj;
        
        CGRect frame = CGRectMake(ox + idx  * ww, 0, ww, hh);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        [view setFrame:frame];
        [m_scrollView addSubview:view];
        
        UIImageView* imgBuddy = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ww-20, ww-20)];
        [imgBuddy setImageWithURL:[NSURL URLWithString:buddy.pictureLarge]];
        [view addSubview:imgBuddy];
        
        UILabel* lblNickName = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imgBuddy.frame), ww-20, 20)];
        
        lblNickName.text = buddy.nickName;
        lblNickName.textAlignment = NSTextAlignmentLeft;
        [lblNickName setFont:[UIFont fontWithName:kDefaultFontName size:12]];
        
        [view addSubview:lblNickName];
        
    }];
    
    [m_scrollView setContentSize:CGSizeMake(ww*m_DiveInformation.buddies.count+ox, m_scrollView.frame.size.height)];
    
    CGRect cellFrame = self.frame;
    
    cellFrame.size.height = CGRectGetMaxY(m_scrollView.frame);
    [self setFrame:cellFrame];
    
    
}
@end
