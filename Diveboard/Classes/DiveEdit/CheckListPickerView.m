//
//  CheckListPickerViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/18/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "CheckListPickerView.h"

@interface CheckListPickerView ()
{
    NSArray* m_list;
    UITableView* m_tableView;
    NSMutableArray* m_selectedItems;
}
@end

@implementation CheckListPickerView
@synthesize delegate;


- (id)initWithTitle:(NSString *)title list:(NSArray *)list checkedIndexList:(NSArray *)checkedIndexList
{

    self = [super initWithFrame:CGRectMake(0, 0, 280, 300)];
    
    
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];

        m_list = list;
        m_selectedItems = [[NSMutableArray alloc] init];
        if (checkedIndexList && checkedIndexList.count > 0) {

            for (NSNumber *index in checkedIndexList) {
                
                [m_selectedItems addObject:[m_list objectAtIndex:[index intValue]]];
                
            }
            
            
        }
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width, 44)];
        [lblTitle setText:title];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [lblTitle setFont:[UIFont fontWithName:kDefaultFontName size:20]];
        [lblTitle setTextColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]];
        
        
        [self addSubview:lblTitle];
        
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 180)];
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        [self addSubview:m_tableView];
        
        
        UIButton* btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOk setFrame:CGRectMake(15, 240, 85, 35)];
        [btnOk setTitle:@"Ok" forState:UIControlStateNormal];
        [btnOk setTitleColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnOk setBackgroundColor:kMainDefaultColor];
        [btnOk addTarget:self action:@selector(onOK:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnOk];

        UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setFrame:CGRectMake(115, 240, 85, 35)];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel.titleLabel setTextColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]];
        
        [btnCancel setTitleColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [btnCancel setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0]];
        
        [btnCancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnCancel];
        
    }
    
    return self;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        
    }
    
    if ([m_selectedItems containsObject:[m_list objectAtIndex:indexPath.row]])
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
    
    [cell.textLabel setText:[m_list objectAtIndex:indexPath.row]];
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return m_list.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    

    if ([m_selectedItems containsObject:[m_list objectAtIndex:indexPath.row]]) {
        
        [m_selectedItems removeObject:[m_list objectAtIndex:indexPath.row]];
        
    }else{
        
        [m_selectedItems addObject:[m_list objectAtIndex:indexPath.row]];
    }
    
    [tableView reloadData];
    
}

-(void)onOK:(id)sender{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCheckedSelectedItems:)]) {

        [self.delegate didCheckedSelectedItems:m_selectedItems];
        
    }
    
}

-(void)onCancel:(id)sender{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelCheckList)]) {
        
        [self.delegate didCancelCheckList];
    }
    
}

@end
