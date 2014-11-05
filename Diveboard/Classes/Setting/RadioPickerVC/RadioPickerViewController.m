//
//  RadioPickerViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 10/7/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "RadioPickerViewController.h"

@interface RadioPickerViewController ()

@end

@implementation RadioPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithList:(NSArray *)list selectedIndex:(int)selectedIndex{
    
    self = [super initWithNibName:@"RadioPickerViewController" bundle:nil];
    
    if (self) {
        
        m_tableList = list;
        m_selectedIndex = selectedIndex;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return m_tableList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.row == m_selectedIndex)
    {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [imgView setImage:[UIImage imageNamed:@"checked_check.png"]];
        
        cell.accessoryView = imgView;
        
    }
    else
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [imgView setImage:[UIImage imageNamed:@"empty_check.png"]];
        
        cell.accessoryView = imgView;
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontName size:15]];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]];
    
    [cell.textLabel setText:[m_tableList objectAtIndex:indexPath.row]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    m_selectedIndex = indexPath.row;
    [tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRadioIndex:pickerViewController:)]) {
        
        [self.delegate didSelectRadioIndex:m_selectedIndex pickerViewController:self];
        
    }
}

-(void)onCancel:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelRadioPickerViewController:)]) {
        
        [self.delegate didCancelRadioPickerViewController:self];
        
    }
}

@end
