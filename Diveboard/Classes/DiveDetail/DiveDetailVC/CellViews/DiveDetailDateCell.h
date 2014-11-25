//
//  DiveDetailDateCell.h
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiveDetailBaseCell.h"
@interface DiveDetailDateCell : DiveDetailBaseCell

{
    IBOutlet UIView* m_viewDateBox;
    IBOutlet UIView* m_viewVisibilityBox;
    IBOutlet UIView* m_viewWaterBox;
    IBOutlet UIView* m_viewDurationBox;
    IBOutlet UIView* m_viewTempBox;
    IBOutlet UIView* m_viewDiveTypeBox;
    
    IBOutlet UILabel* m_lblDate;
    IBOutlet UILabel* m_lblVisibility;
    IBOutlet UILabel* m_lblWater;
    IBOutlet UILabel* m_lblDuration;
    IBOutlet UILabel* m_lblTemp;
    IBOutlet UILabel* m_lblDiveType;
    
}

@end
