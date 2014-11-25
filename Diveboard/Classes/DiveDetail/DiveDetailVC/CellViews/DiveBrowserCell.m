//
//  DiveBrowserCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveBrowserCell.h"

@implementation DiveBrowserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)onBrowser:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", SERVER_URL, [AppManager sharedManager].loginResult.user.nickName, m_DiveInformation.shakenID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

}
@end
