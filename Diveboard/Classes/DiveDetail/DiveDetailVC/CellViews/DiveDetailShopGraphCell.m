//
//  DiveDetailShopGraphCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailShopGraphCell.h"
#import "UIImageView+AFNetworking.h"
#import "DiveGraphViewController.h"
@implementation DiveDetailShopGraphCell

- (void)awakeFromNib {
    // Initialization code
    // dive shop
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    [super setDiveInformation:diveInfo];
    
    if (m_DiveInformation.diveShop.name.length > 0) {
        [vdlblShopContent       setText:m_DiveInformation.diveShop.name];
    } else {
        [vdlblShopContent       setText:@"No shop"];
    }
    
    if (m_DiveInformation.diveShop.picture.length > 0) {
        
        [imgviewShop setImageWithURL:[NSURL URLWithString:m_DiveInformation.diveShop.picture]];
        
    }
    
    
    
    // graph
    
    NSString *myNickName = [[AppManager sharedManager].loginResult.user.nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *diveShakenID   = m_DiveInformation.shakenID;

    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/profile.png?g=mobile_v002&u=m", SERVER_URL, myNickName, diveShakenID];
    
    
    
    
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        
        [vdimgviewGraph setImage:[[DiveOfflineModeManager sharedManager] getImageWithUrl:urlString]];
        
    }else{

        [vdimgviewGraph clearImageCacheForURL:[NSURL URLWithString:urlString]];
        
        UIImageView *imgviewGraph = vdimgviewGraph;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [vdimgviewGraph setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            [imgviewGraph setImage:image];
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

            
            [imgviewGraph setImage:[[DiveOfflineModeManager sharedManager] getImageWithUrl:urlString]];
            
        }];
        
    }
    
    
    // dive max depth
    [vdlblDepth setText:[DiveInformation unitOfLengthWithValue:m_DiveInformation.maxDepth
                                                   defaultUnit:m_DiveInformation.maxDepthUnit]];
    
    
    
}
-(void)onTapGraph:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedGraph)]) {
        
        [self.delegate didClickedGraph];
    }
    
    
}

@end
