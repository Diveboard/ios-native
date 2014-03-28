//
//  DBUnitSelectViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DBUnitSelectViewController.h"

@interface DBUnitSelectViewController ()

@end

@implementation DBUnitSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.selectedIndex == 0) {
        [self.imgviewImperial setImage:[UIImage imageNamed:@"checked_check.png"]];
    } else {
        [self.imgviewMetric   setImage:[UIImage imageNamed:@"checked_check.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectUnitAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DBUnitSelectAction:)]) {
        if (sender == self.btnImperial) {
            [self.imgviewImperial setImage:[UIImage imageNamed:@"checked_check.png"]];
            [self.imgviewMetric setImage:[UIImage imageNamed:@"empty_check.png"]];
            [self.delegate DBUnitSelectAction:@"Imperial"];
        } else if (sender == self.btnMetric) {
            [self.imgviewMetric   setImage:[UIImage imageNamed:@"checked_check.png"]];
            [self.imgviewImperial setImage:[UIImage imageNamed:@"empty_check.png"]];
            [self.delegate DBUnitSelectAction:@"Metric"];
        }
    }

}

- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DBUnitSelectAction:)]) {
        [self.delegate DBUnitSelectAction:@"Cancel"];
    }
}

@end
