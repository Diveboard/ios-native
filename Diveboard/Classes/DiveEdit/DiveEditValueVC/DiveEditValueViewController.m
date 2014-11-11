//
//  DiveEditValueViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditValueViewController.h"
#import "NIDropDown.h"
@interface DiveEditValueViewController ()<NIDropDownDelegate,UITextFieldDelegate>
{
    NIDropDown* m_dropDown;
    NSString* m_strSelUnit;
    NSArray* m_arrUnits;
}

@end

@implementation DiveEditValueViewController
@synthesize dataSource,delegate;
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
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    m_txtValue.inputAccessoryView = numberToolbar;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(valueForDiveEdit)]) {
     
        [m_txtValue setText:[self.dataSource valueForDiveEdit]];
    }else{
        
        [m_txtValue setText:@""];
        
    }
    

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleForDiveEdit)]) {
        
        [m_lblTitle setText:[self.dataSource titleForDiveEdit]];
        
    }else{
        
        [m_lblTitle setText:@""];
        
    }
    [m_txtValue setKeyboardType:UIKeyboardTypeDefault];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(valueTypeForDiveEdit)]) {
        
        if ([self.dataSource valueTypeForDiveEdit] == DiveEditValueTypeNumber) {
            
            [m_txtValue setKeyboardType:UIKeyboardTypeDecimalPad];
            
        }
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(strSelUnitForDiveEdit)]) {
        
        m_strSelUnit = [self.dataSource strSelUnitForDiveEdit];
        [m_btnUnit setTitle:m_strSelUnit forState:UIControlStateNormal];
        
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(arrUnitsForDiveEdit)]) {
        
        m_arrUnits = [self.dataSource arrUnitsForDiveEdit];
    }

    if (m_arrUnits.count > 1) {
        
        [m_imgTriangle setHidden:NO];
        
    }else{
        
        [m_imgTriangle setHidden:YES];
        
    }
    
    if (m_dropDown) {
        [m_dropDown hideDropDown:m_btnUnit];
        m_dropDown = nil;
    }

    [m_txtValue becomeFirstResponder];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onOk{
    
    [self.view endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeValueForDiveEdit::)]) {
        
        [self.delegate didChangeValueForDiveEdit:m_txtValue.text:m_strSelUnit];
    }
    
}
-(void)onCancel{

    [self.view endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelValueForDiveEdit)]) {
        
        [self.delegate didCancelValueForDiveEdit];
    }
    
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
- (void)doneWithNumberPad{
    
    [self.view endEditing:YES];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField selectAll:self];
    
}
@end
