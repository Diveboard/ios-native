//
//  DiveEditNotesViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiveInformation;

@interface DiveEditNotesViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UITextView* m_txtDiveNote;
    
}

- (id)initWithDiveData:(DiveInformation *)diveInfo;
- (void)setDiveInformation:(DiveInformation *)diveInfo;

@end
