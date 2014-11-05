//
//  DiveEditBuddiesPhotoCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/29/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditBuddiesPhotoCell.h"
#import "UIImageView+AFNetworking.h"
@implementation DiveEditBuddiesPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setBuddyData:(Buddy *)buddy
{
    if (![buddy.pictureURLString isEqualToString:@""]) {
        
        [m_imgBuddyPhoto setImageWithURL:[NSURL URLWithString:buddy.pictureURLString] placeholderImage:[UIImage imageNamed:@"no_picture.png"]];
        
    }else{

        [m_imgBuddyPhoto setImageWithURL:[NSURL URLWithString:buddy.picture] placeholderImage:[UIImage imageNamed:@"no_picture.png"]];
        
    }
    
        m_lblBuddyName.text = buddy.nickName;
        
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
