//
//  SettingViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 3/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "SettingViewController.h"
//#import "SGActionView.h"
#import "UIViewController+MJPopupViewController.h"
#import "DBUnitSelectViewController.h"


@interface SettingViewController () <DBUnitSelectDelegate>
{
    int selectedIndex;
    DBUnitSelectViewController *unitSelectViewController;
}

@end

@implementation SettingViewController

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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    selectedIndex = [ud objectForKey:kDiveboardUnit] == nil ? 1 : [[ud objectForKey:kDiveboardUnit] intValue];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [btnUnit setTitle:(selectedIndex == 0 ? @"Imperial" : @"Metric")
             forState:(UIControlStateNormal)];
    [scrview setContentSize:CGSizeMake(320, 300)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([[ud objectForKey:kDiveboardUnit] intValue] != selectedIndex) {
        [ud setObject:@(selectedIndex) forKey:kDiveboardUnit];
        [ud synchronize];
        [self.parent updateUnit];
    }
}

- (IBAction)backActions:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)unitSelectAction:(id)sender {
//    [SGActionView showSheetWithTitle:@"Select Unit"
//                          itemTitles:@[ @"Imperial", @"Metric"]
//                       itemSubTitles:@[ @"Feet", @"Meter"]
//                       selectedIndex:selectedIndex
//                      selectedHandle:^(NSInteger index){
//                          if (index != selectedIndex) {
//                              selectedIndex = index;
//                              if (index == 0)
//                                  [btnUnit setTitle:@"Imperial" forState:(UIControlStateNormal)];
//                              if (index == 1)
//                                  [btnUnit setTitle:@"Metric" forState:(UIControlStateNormal)];
//                          }
//                      }];
    unitSelectViewController = [[DBUnitSelectViewController alloc] initWithNibName:@"DBUnitSelectViewController" bundle:nil];
    [unitSelectViewController setDelegate:self];
    unitSelectViewController.selectedIndex = selectedIndex;
    [self presentPopupViewController:unitSelectViewController animationType:MJPopupViewAnimationFade];

    
}

- (void)DBUnitSelectAction:(NSString *)unit
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    unitSelectViewController = nil;
    if (![unit isEqualToString:@"Cancel"]) {
         [btnUnit setTitle:unit forState:(UIControlStateNormal)];
        if ([unit isEqualToString:@"Imperial"]) {
            selectedIndex = 0;
        } else {
            selectedIndex = 1;
        }
    }
}

@end
