//
//  DiveEditSafetyStopsViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/20/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditSafetyStopsViewController.h"
#import "DiveInformation.h"
#import "NIDropDown.h"
@interface DiveEditSafetyStopsViewController ()<NIDropDownDelegate>
{
    NSIndexPath* m_indexPath;
    
    NIDropDown* m_dropDown;
    NSString* m_strSelUnit;
    NSArray* m_arrUnits;
}
@end

@implementation DiveEditSafetyStopsViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithSafetyStops:(NSArray *)safetyStops{
    
    self = [super initWithNibName:@"DiveEditSafetyStopsViewController" bundle:nil];
    
    if (self) {
        
        m_safetyStops = [[NSMutableArray alloc] init];
        [m_safetyStops addObjectsFromArray:safetyStops];
        
    }
    
    return self;
    
}
-(void)setSafetyStops:(NSArray *)safetyStops{
    
    [m_safetyStops removeAllObjects];
    [m_safetyStops addObjectsFromArray:safetyStops];
    [m_tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_arrUnits = @[@"m",@"ft"];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    m_txtDepth.inputAccessoryView = numberToolbar;
    m_txtDuration.inputAccessoryView = numberToolbar;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [m_viewEdit setHidden:YES];
    
    if (m_dropDown) {
        [m_dropDown hideDropDown:m_btnUnit];
        m_dropDown = nil;
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        
    }
    
    
    [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontName size:18]];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]];
    
    
    SafetyStop* safetyStop =(SafetyStop*)[m_safetyStops objectAtIndex:indexPath.row];
    
    NSString* strSafety = [NSString stringWithFormat:@"%@%@ - %@mins",safetyStop.depth,safetyStop.depthUnit,safetyStop.duration];
    [cell.textLabel setText:strSafety];
    
    UIButton* btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
    [btnDelete setTag:indexPath.row];
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_recycle_bin.png"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(onDeleteSafetyStop:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = btnDelete;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return m_safetyStops.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    m_indexPath = indexPath;
    SafetyStop* safetyStop =(SafetyStop*)[m_safetyStops objectAtIndex:indexPath.row];

    [m_txtDepth setText:safetyStop.depth];
    [m_txtDuration setText:safetyStop.duration];
    m_strSelUnit = safetyStop.depthUnit;
    [m_btnUnit setTitle:m_strSelUnit forState:UIControlStateNormal];
    
    [m_viewEdit setHidden:NO];
    
    
}

-(void)onOK:(id)sender{
    
    if (![self checkIsValid]) {
        return;
    }
    
    if ([m_viewEdit isHidden]) {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeSafetyStops:)]) {
            
            [self.delegate didChangeSafetyStops:m_safetyStops];
            
        }
        
    }else{
        
        [m_viewEdit setHidden:YES];
        
        if (m_indexPath) {
            
            SafetyStop* safetyStop =(SafetyStop*)[m_safetyStops objectAtIndex:m_indexPath.row];
            safetyStop.depth = [DiveInformation convertInternationalFormatValue:m_txtDepth.text];
            safetyStop.duration =[DiveInformation convertInternationalFormatValue:m_txtDuration.text];
            safetyStop.depthUnit = m_strSelUnit;
            
        }else{
            
            SafetyStop* safetyStop = [[SafetyStop alloc] init];
            safetyStop.depth = [DiveInformation convertInternationalFormatValue:m_txtDepth.text];
            safetyStop.duration = [DiveInformation convertInternationalFormatValue:m_txtDuration.text];
            safetyStop.depthUnit = m_strSelUnit;
            [m_safetyStops addObject:safetyStop];
            
        }
        
         m_indexPath = nil;
        [m_tableView reloadData];
        
    }
    
}

-(void)onCancel:(id)sender{
    
    
    if ([m_viewEdit isHidden]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelSafetyStops)]) {
            
            [self.delegate didCancelSafetyStops];
        }
        
    }else{
        
        [m_viewEdit setHidden:YES];
        m_indexPath = nil;
        [m_tableView reloadData];
        
    }
    
}
-(void)onAddSafeStop:(id)sender{
    
    [m_viewEdit setHidden:NO];
    
    [m_txtDepth setText:([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ?@"10" : @"3"];
        
    [m_txtDuration setText:@"3"];
    
    m_strSelUnit = ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"ft" : @"m" ;

    [m_btnUnit setTitle:m_strSelUnit forState:UIControlStateNormal];
    
    
}
- (void)onDeleteSafetyStop:(id)sender{
    
    UIButton* btn = (UIButton*)sender;
    
    int index = (int)btn.tag;
    
    [m_safetyStops removeObjectAtIndex:index];
    [m_tableView reloadData];
    
    
}
-(void)onChangeUnit{
    
    if (m_arrUnits.count < 2) {
        return;
    }
    
    if(m_dropDown == nil) {
        CGFloat f = 60;
        m_dropDown = [[NIDropDown alloc]showDropDown:m_btnUnit :&f :m_arrUnits :@"down"];
        m_dropDown.delegate = self;
    }
    else {
        [m_dropDown hideDropDown:m_btnUnit];
        m_dropDown = nil;
    }
    
}

-(void)niDropDownDelegateMethod:(int)selectedRow :(NIDropDown *)sender{
    
    m_dropDown = nil;
    m_strSelUnit = m_arrUnits[selectedRow];
    
    
}



-(void)doneWithNumberPad{
    
    [self.view endEditing:YES];
}

- (BOOL) checkIsValid
{
    
    // MaxDepth
    
    if (!([[DiveInformation convertInternationalFormatValue:m_txtDepth.text] doubleValue] > 0)) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Depth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
        
    }
    // Duration
    if ([[DiveInformation convertInternationalFormatValue:m_txtDuration.text] doubleValue] < 1)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Duration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    
    return YES;
}
@end
