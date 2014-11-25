//
//  DiveDetailTankUsedCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailTankUsedCell.h"

@implementation DiveDetailTankUsedCell

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
    
    for (UIView* v in m_scrollTanksView.subviews) {
        [v removeFromSuperview];
    }
    
    float ox = 20, oy = 0;
    [m_DiveInformation.tanksUsed enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect frame = CGRectMake(ox + idx * 150, oy , 140, 30);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        //            [label setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin)];
        [label setFont:[UIFont fontWithName:kDefaultFontName size:10]];
        [label setNumberOfLines:0];
        
        DiveTank *tank = (DiveTank *)obj;
        NSMutableString *tankString  = [[NSMutableString alloc] init];
        if (tank.multitank > 1) {
            [tankString appendString:[NSString stringWithFormat:@"%dx ", (int)tank.multitank]];
        }
        [tankString appendString:[NSString stringWithFormat:@"%.1f%@         ", tank.volumeValue, tank.volumeUnit.uppercaseString]];
        if ([tank.gasType isEqualToString:@"nitrox"]) {
            [tankString appendString:[NSString stringWithFormat:@"Nx %d", (int)tank.o2]];
        } else if ([tank.gasType isEqualToString:@"trimix"]) {
            [tankString appendString:[NSString stringWithFormat:@"Tx %d/%d", (int)tank.o2, (int)tank.he]];
        } else if ([tank.gasType isEqualToString:@"air"]) {
            [tankString appendString:@"Air"];
        } else {
            if (tank.gasType) {
                [tankString appendString:tank.gasType.uppercaseString];
            }
        }
        [tankString appendString:@"\n"];
        
        [tankString appendString:[NSString stringWithFormat:@"%.1f%@ → %.1f%@", tank.pStartValue, tank.pStartUnit, tank.pEndValue, tank.pEndUnit]];
        
        if (tank.timeStart > 0) {
            [tankString appendString:@"\n"];
            [tankString appendString:[NSString stringWithFormat:@"Switched at : %dmin", (int)tank.timeStart/60]];
            frame.size.height = 40;
            [label setFrame:frame];
        }
        
        [label setText:tankString];
        [m_scrollTanksView addSubview:label];
        
    }];
    
    [m_scrollTanksView setContentSize:CGSizeMake(150*m_DiveInformation.tanksUsed.count, m_scrollTanksView.frame.size.height)];
}
@end
