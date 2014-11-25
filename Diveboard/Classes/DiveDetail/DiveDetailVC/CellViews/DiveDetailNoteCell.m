//
//  DiveDetailNoteCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailNoteCell.h"

@implementation DiveDetailNoteCell

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
    
    NSString* strNote = @"";
    if (m_DiveInformation.note.length > 0) {
        
        strNote = m_DiveInformation.note;
        
    } else {
        
        strNote = @"No notes for this dive.";
        
    }
    
    float width = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? 528.0f : 280.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  // iPad
        
        width = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? 964.0f : 708.0f;
        
    }
    
    CGSize sizeText = [strNote sizeWithFont:[UIFont fontWithName:kDefaultFontName size:10]
                              constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    
    [vdlblNoteContent setText:strNote];
    
    
    CGRect frame = vdlblNoteContent.frame;
    frame.size = sizeText;
    
    if (frame.size.height < 20) {
        
        frame.size.height = 20;
    }
    
    [vdlblNoteContent setFrame:frame];

    
    frame = self.frame;
    
    frame.size.height = CGRectGetMaxY(vdlblNoteContent.frame)+10;
    
    [self setFrame:frame];
    
    
}


@end
