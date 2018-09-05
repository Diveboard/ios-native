//
//  DiveEditPhotoCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/23/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditPhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface DiveEditPhotoCell ()
{
    NSIndexPath* m_indexPath;
    UILongPressGestureRecognizer* _longPressRecognizer;
}
@end

@implementation DiveEditPhotoCell
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDivePicture:(NSIndexPath*)indexPath :(DivePicture*)divePicture{

    [m_imgDivePicture setImage:nil];
    
    if (divePicture.isLocal) {

        [m_imgDivePicture setImage:[[DiveOfflineModeManager sharedManager] getLocalDivePicture:divePicture.urlString]];
        
    }else{
        
        [m_imgDivePicture setImageWithURL:[NSURL URLWithString:divePicture.urlString]];
        
    }
    
    m_indexPath = indexPath;
    [m_btnAdd setHidden:YES];
    [m_btnYoutube setHidden:YES];
    
     _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    [self addGestureRecognizer:_longPressRecognizer];
    
    
}
-(void)setAddButton:(NSIndexPath *)indexPath
{
 
    m_indexPath = indexPath;
    
    [m_imgDivePicture setImage:nil];
    
    [m_imgDivePicture setBackgroundColor:[UIColor clearColor]];
    
    [m_btnAdd setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    
    [m_btnAdd setHidden:NO];
    
    [self removeGestureRecognizer:_longPressRecognizer];
    
    
}

-(void)setYoutubeButton:(NSIndexPath *)indexPath :(NSString *)youtubeVideoId
{
    
    m_indexPath = indexPath;
    self.youtubeVideoId = youtubeVideoId;

    [m_btnYoutube setBackgroundImage:[UIImage imageNamed:@"btn_youtube.png"] forState:UIControlStateNormal];
    
    [m_btnYoutube setHidden:NO];
    
    [self removeGestureRecognizer:_longPressRecognizer];
    
    
}

-(void) longPressDetected:(UIGestureRecognizer*) gestureRecognizer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressedPhoto:::)]) {
        
        [self.delegate didLongPressedPhoto:gestureRecognizer :m_indexPath :m_imgDivePicture.image];
    
    }
    
}
- (void)onAddButton:(id)sender{
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddPhotoButton:)]) {
        
        [self.delegate didClickedAddPhotoButton:m_indexPath];
    }
}
- (void)onYoutubeButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedYoutubeButton::)]) {
        
        [self.delegate didClickedYoutubeButton:m_indexPath :self.youtubeVideoId];
    }
}

@end
