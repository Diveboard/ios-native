//
//  DiveDetailNoteCell.m
//  Diveboard
//
//  Created by SergeyPetrov on 11/3/14.
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
    
    [vdlblNoteContent setText:strNote];
    vdlblNoteContent.frame = CGRectMake(vdlblNoteContent.frame.origin.x, vdlblNoteContent.frame.origin.y, vdlblNoteContent.frame.size.width, 0);
    vdlblNoteContent.lineBreakMode = NSLineBreakByWordWrapping;
    vdlblNoteContent.numberOfLines = 0;
    [vdlblNoteContent sizeToFit];
    
    CGRect frame = vdlblNoteContent.frame;
    if (frame.size.height < 20) {
        
        frame.size.height = 20;
        [vdlblNoteContent setFrame:frame];
        
        
    }
    
    frame = self.frame;
    
    frame.size.height = CGRectGetMaxY(vdlblNoteContent.frame)+10;
    
    [self setFrame:frame];
    
    
}


@end
