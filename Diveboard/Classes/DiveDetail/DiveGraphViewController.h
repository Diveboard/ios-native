//
//  DiveGraphViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 10/1/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiveGraphViewController : UIViewController
{
 
    NSString* m_graphURLString;
    IBOutlet UIView* m_viewContainer;
}

-(IBAction)onClose:(id)sender;
- (id)initWithDiveData:(DiveInformation *)diveInfo;

@end
