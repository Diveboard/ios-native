//
//  DiveBoardNavigationController.m
//  Diveboard
//
//  Created by Vladimir Popov on 5/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveBoardNavigationController.h"

@interface DiveBoardNavigationController ()

@end

@implementation DiveBoardNavigationController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithRootViewController:(UIViewController *)rootViewController sudoID:(int)sudoID
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.sudoID = sudoID;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
