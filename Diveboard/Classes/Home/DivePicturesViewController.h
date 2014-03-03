//
//  DivePicturesViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/28/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DivePicturesViewController : UIViewController
{
    IBOutlet UIView *viewMain;
    IBOutlet UIButton *btnClose;
    
}

- (id) initWithPicturesData:(NSArray *)pictures;

- (IBAction)closeAction:(id)sender;

@end
