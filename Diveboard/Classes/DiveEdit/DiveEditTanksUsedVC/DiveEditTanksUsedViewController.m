//
//  DiveEditTanksUsedViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/22/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditTanksUsedViewController.h"
#import "DiveInformation.h"
#import "NIDropDown.h"
@interface DiveEditTanksUsedViewController () <NIDropDownDelegate>
{
    NIDropDown* m_dropDown;
    NSArray* m_arrCylinder;
    NSArray* m_arrCylinderUnit;
    NSArray* m_arrVolumeUnit;
    NSArray* m_arrGasMix;
    NSArray* m_arrEndPressureUnit;
    UITextField* m_currentTextField;
    CGRect m_originalFrameOfView;
    
}
@end

@implementation DiveEditTanksUsedViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTanks:(NSArray *)tanks{
    
    self = [super initWithNibName:@"DiveEditTanksUsedViewController" bundle:nil];
    if (self) {
        
        m_tanks = [[NSMutableArray alloc] init];
        [m_tanks addObjectsFromArray:tanks];
        
    }
    
    return self;
    
}
-(void)setTanksUsed:(NSArray *)tanks{
    
    [m_tanks removeAllObjects];
    [m_tanks addObjectsFromArray:tanks];
    [m_tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_arrCylinder = [NSArray arrayWithObjects:@"1",@"2", nil];
    m_arrCylinderUnit = [NSArray arrayWithObjects:@"Aluminium",@"Steel",@"Carbon", nil];
    m_arrVolumeUnit = [NSArray arrayWithObjects:@"L",@"cuft", nil];
    m_arrGasMix = [NSArray arrayWithObjects:@"Air",@"Nitrox",@"Trimix", nil];
    m_arrEndPressureUnit = [NSArray arrayWithObjects:@"bar",@"psi", nil];
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    m_txtVolume.inputAccessoryView = numberToolbar;
    m_txtStartPressure.inputAccessoryView = numberToolbar;
    m_txtEndPressure.inputAccessoryView = numberToolbar;
    m_txtStartTime.inputAccessoryView = numberToolbar;
    m_txtO2.inputAccessoryView = numberToolbar;
    m_txtHe.inputAccessoryView = numberToolbar;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [m_viewEdit setHidden:YES];

    if (m_dropDown) {
        [m_dropDown hideDropDown:nil];
        m_dropDown = nil;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];

    
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
    [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontName size:15]];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]];
    
    [cell.textLabel setNumberOfLines:3];

    
    DiveTank* tank = (DiveTank*)[m_tanks objectAtIndex:indexPath.row];
    
    NSMutableString *tankString  = [[NSMutableString alloc] init];
    if (tank.multitank > 1) {
        [tankString appendString:[NSString stringWithFormat:@"%dx ", (int)tank.multitank]];
    }
    [tankString appendString:[NSString stringWithFormat:@"%.1f%@         ", tank.volumeValue, tank.volumeUnit.uppercaseString]];
    if ([tank.gasType isEqualToString:@"nitrox"]) {
        [tankString appendString:[NSString stringWithFormat:@"Nx %d", (int)tank.o2]];
    } else if ([tank.gasType isEqualToString:@"trimix"]) {
        [tankString appendString:[NSString stringWithFormat:@"Tx %d/%d", (int)tank.o2, (int)tank.he]];
    } else if ([tank.gasType isEqualToString:@"air"]) {
        [tankString appendString:@"Air"];
    } else {
        if (tank.gasType) {
            [tankString appendString:tank.gasType.uppercaseString];
        }
    }
    [tankString appendString:@"\n"];
    
    [tankString appendString:[NSString stringWithFormat:@"%.1f%@ → %.1f%@\n", tank.pStartValue, tank.pStartUnit, tank.pEndValue, tank.pEndUnit]];
    
    if (indexPath.row > 0) {
        [tankString appendString:[NSString stringWithFormat:@"Switched at : %dmin", (int)tank.timeStart/60]];
    }
    
    
    [cell.textLabel setText:tankString];
    
    UIButton* btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 25)];
    [btnDelete setTag:indexPath.row];
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_recycle_bin.png"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(onDeleteTank:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = btnDelete;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return m_tanks.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    m_indexPath = indexPath;
    
    DiveTank* tank = (DiveTank*)[m_tanks objectAtIndex:indexPath.row];

    [m_btnCylinderCount setTitle:[NSString stringWithFormat:@"%d",(int)tank.multitank] forState:UIControlStateNormal];
    [m_btnCylinderUnit setTitle:tank.material forState:UIControlStateNormal];
    [m_txtVolume setText:[NSString stringWithFormat:@"%.1f",tank.volumeValue]];
    [m_btnVolumeUnit setTitle:tank.volumeUnit forState:UIControlStateNormal];
    [m_btnGasMix setTitle:[tank.gasType capitalizedString] forState:UIControlStateNormal];
    [m_txtStartPressure setText:[NSString stringWithFormat:@"%0.1f",tank.pStartValue]];
    [m_txtEndPressure setText:[NSString stringWithFormat:@"%0.1f",tank.pEndValue]];
    [m_btnEndPressureUnit setTitle:tank.pEndUnit forState:UIControlStateNormal];
    [m_txtStartTime setText:[NSString stringWithFormat:@"%d",(int)tank.timeStart/60]];
    
    
    [m_txtO2 setText:[NSString stringWithFormat:@"%d",(int)tank.o2]];
    
    [m_txtHe setText:[NSString stringWithFormat:@"%d",(int)tank.he]];

    if ([tank.gasType isEqualToString:@"air"]) {
        
        [m_lblO2 setHidden:YES];
        [m_txtO2 setHidden:YES];
        
        [m_lblHe setHidden:YES];
        [m_txtHe setHidden:YES];
        
    }else if ([tank.gasType isEqualToString:@"nitrox"]) {
        
        [m_lblO2 setHidden:NO];
        [m_txtO2 setHidden:NO];
        
        [m_lblHe setHidden:YES];
        [m_txtHe setHidden:YES];
        
    }else if ([tank.gasType isEqualToString:@"trimix"]) {
        
        [m_lblO2 setHidden:NO];
        [m_txtO2 setHidden:NO];
        
        [m_lblHe setHidden:NO];
        [m_txtHe setHidden:NO];
        
    }

    if (m_dropDown) {
        [m_dropDown hideDropDown:nil];
        m_dropDown = nil;
    }
    
    if (indexPath.row > 0) {
        
        [m_viewStartTimeRow setHidden:NO];
        
    }else{
        
        [m_viewStartTimeRow setHidden:YES];
    }
    
    
    [m_viewEdit setHidden:NO];
    
    
}

- (void)onDeleteTank:(id)sender{
    
    UIButton* btn = (UIButton*)sender;
    
    int index = (int)btn.tag;
    
    [m_tanks removeObjectAtIndex:index];
    [m_tableView reloadData];
    
    
}

-(void)onAddTank:(id)sender{
    
    if (m_dropDown) {
        [m_dropDown hideDropDown:nil];
        m_dropDown = nil;
    }

    
    [m_btnCylinderCount setTitle:@"1" forState:UIControlStateNormal];
    [m_btnCylinderUnit setTitle:@"Aluminium" forState:UIControlStateNormal];
    [m_btnVolumeUnit setTitle:([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"cuft" : @"L" forState:UIControlStateNormal];
    [m_btnGasMix setTitle:@"Air" forState:UIControlStateNormal];
    
    if ([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) {
        
        [m_txtVolume setText:@"80"];
        [m_txtStartPressure setText:@"3000"];
        [m_txtEndPressure setText:@"700"];
        
    }else{
        [m_txtVolume setText:@"12"];
        [m_txtStartPressure setText:@"200"];
        [m_txtEndPressure setText:@"50"];
        
    }
    
    [m_btnEndPressureUnit setTitle:([AppManager sharedManager].userSettings.unit == UserSettingUnitTypeImperial) ? @"psi" : @"bar"  forState:UIControlStateNormal];
    [m_txtStartTime setText:@"0"];
    
    [m_txtO2 setText:@"21"];
    [m_txtHe setText:@"0"];

    
    [m_lblO2 setHidden:YES];
    [m_txtO2 setHidden:YES];
    
    [m_lblHe setHidden:YES];
    [m_txtHe setHidden:YES];
    
    
    if (m_tanks.count > 0) {
        
        [m_viewStartTimeRow setHidden:NO];
        
    }else{
        
        [m_viewStartTimeRow setHidden:YES];
    }
    
    [m_viewEdit setHidden:NO];
    
    
}

-(void)onOk:(id)sender{
    
    
    if ([m_viewEdit isHidden]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeTanksUsed:)]) {
            
            [self.delegate didChangeTanksUsed:m_tanks];
            
        }
        
    }else{
        
        if(![self checkIsValid]){
            return;
        }
        
        
        [m_viewEdit setHidden:YES];
        
        if (m_indexPath) {
            
            DiveTank* tank =(DiveTank*)[m_tanks objectAtIndex:m_indexPath.row];
            
            
            tank.multitank = [m_btnCylinderCount.titleLabel.text integerValue];
            [m_btnCylinderUnit setTitle:tank.material forState:UIControlStateNormal];
            tank.material = [m_btnCylinderUnit.titleLabel.text lowercaseString];
            tank.volumeValue = [[DiveInformation convertInternationalFormatValue:m_txtVolume.text] doubleValue];
            tank.volume = [[DiveInformation convertInternationalFormatValue:m_txtVolume.text] doubleValue];
            tank.volumeUnit = m_btnVolumeUnit.titleLabel.text;
            
            tank.gasType = [m_btnGasMix.titleLabel.text lowercaseString];
            
            tank.pStartValue = [[DiveInformation convertInternationalFormatValue:m_txtStartPressure.text] doubleValue];
            tank.pStart = [[DiveInformation convertInternationalFormatValue:m_txtStartPressure.text] doubleValue];
            tank.pStartUnit = m_btnEndPressureUnit.titleLabel.text;
            
            tank.pEnd = [[DiveInformation convertInternationalFormatValue:m_txtEndPressure.text] doubleValue];
            tank.pEndValue = [[DiveInformation convertInternationalFormatValue:m_txtEndPressure.text] doubleValue];
            tank.pEndUnit = m_btnEndPressureUnit.titleLabel.text;
            tank.timeStart = [[DiveInformation convertInternationalFormatValue:m_txtStartTime.text] integerValue]*60;
            
            
            tank.o2 = [[DiveInformation convertInternationalFormatValue:m_txtO2.text] integerValue];
            tank.he = [[DiveInformation convertInternationalFormatValue:m_txtHe.text] integerValue];
            
        }else{
            
            DiveTank* tank = [[DiveTank alloc] init];
            
            tank.multitank = [m_btnCylinderCount.titleLabel.text integerValue];
            [m_btnCylinderUnit setTitle:tank.material forState:UIControlStateNormal];
            tank.material = [m_btnCylinderUnit.titleLabel.text lowercaseString];
            tank.volumeValue = [[DiveInformation convertInternationalFormatValue:m_txtVolume.text] doubleValue];
            tank.volume = [[DiveInformation convertInternationalFormatValue:m_txtVolume.text] doubleValue];
            tank.volumeUnit = m_btnVolumeUnit.titleLabel.text;
            tank.order = m_tanks.count;
            tank.gasType = [m_btnGasMix.titleLabel.text lowercaseString];
            
            tank.pStartValue = [[DiveInformation convertInternationalFormatValue:m_txtStartPressure.text] doubleValue];
            tank.pStart = [[DiveInformation convertInternationalFormatValue:m_txtStartPressure.text] doubleValue];
            tank.pStartUnit = m_btnEndPressureUnit.titleLabel.text;
            
            tank.pEnd = [[DiveInformation convertInternationalFormatValue:m_txtEndPressure.text] doubleValue];
            tank.pEndValue = [[DiveInformation convertInternationalFormatValue:m_txtEndPressure.text] doubleValue];
            tank.pEndUnit = m_btnEndPressureUnit.titleLabel.text;
            tank.timeStart = [[DiveInformation convertInternationalFormatValue:m_txtStartTime.text] integerValue]*60;
            
            tank.o2 = [[DiveInformation convertInternationalFormatValue:m_txtO2.text] integerValue];
            tank.he = [[DiveInformation convertInternationalFormatValue:m_txtHe.text] integerValue];
            
            [m_tanks addObject:tank];
            
        }
        
       m_indexPath = nil;
        
        [m_tableView reloadData];
        
    }

}

-(void)onCancel:(id)sender{
    
    
    if ([m_viewEdit isHidden]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelTanksUsed)]) {
            
            [self.delegate didCancelTanksUsed];
        }
        
    }else{
        
        [m_viewEdit setHidden:YES];
        m_indexPath = nil;
        [m_tableView reloadData];
        
    }
    
}
-(void)onDropDown:(id)sender{
    
    UIButton* btnSender = (UIButton*)sender;
    NSArray * arr;
    
    if (btnSender == m_btnCylinderCount) {
        
        arr = m_arrCylinder;
        
    }else if (btnSender == m_btnCylinderUnit){
        
        arr = m_arrCylinderUnit;
        
    }else if (btnSender == m_btnVolumeUnit){
        
        arr = m_arrVolumeUnit;
        
    }else if (btnSender == m_btnGasMix){

        arr = m_arrGasMix;
        
    }else if (btnSender == m_btnEndPressureUnit){
        
        arr = m_arrEndPressureUnit;
        
    }

    
    CGFloat height = 30*arr.count;
    
    if (m_dropDown == nil) {
        
        m_dropDown = [[NIDropDown alloc] init];
        m_dropDown.delegate = self;
        
        [m_dropDown showDropDown:btnSender :&height :arr :@"down"];
        
    }else{
        
        if (m_dropDown.btnSender == btnSender) {
            
            [m_dropDown hideDropDown:btnSender];
            m_dropDown = nil;
        }else{
            [m_dropDown hideDropDown:m_dropDown.btnSender];
            m_dropDown = nil;
            
            m_dropDown = [[NIDropDown alloc] init];
            m_dropDown.delegate = self;
            
            
            [m_dropDown showDropDown:btnSender :&height :arr :@"down"];
            
            
        }
        
    }
    
    
    
}

-(void)niDropDownDelegateMethod:(int)selectedRow :(NIDropDown *)sender{
 
    if (m_dropDown.btnSender == m_btnGasMix) {
        NSString* strType = [m_arrGasMix[selectedRow] lowercaseString];
        
        if ([strType isEqualToString:@"air"]) {
            
            [m_lblO2 setHidden:YES];
            [m_txtO2 setHidden:YES];
            
            [m_lblHe setHidden:YES];
            [m_txtHe setHidden:YES];
            
        }else if ([strType isEqualToString:@"nitrox"]) {
            
            [m_lblO2 setHidden:NO];
            [m_txtO2 setHidden:NO];
            
            [m_lblHe setHidden:YES];
            [m_txtHe setHidden:YES];
            
        }else if ([strType isEqualToString:@"trimix"]) {
            
            [m_lblO2 setHidden:NO];
            [m_txtO2 setHidden:NO];
            
            [m_lblHe setHidden:NO];
            [m_txtHe setHidden:NO];
            
        }
    
    }
    
    m_dropDown = nil;
    
    

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    m_currentTextField = textField;
    
}

-(void)doneWithNumberPad{
    
    [self.view endEditing:YES];
}
#pragma mark keyboard actions

// Keyboard will show and Hide actions

-(void)keyboardWillHide:(NSNotification *)_notification
{

    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.5];
    [self.view setFrame:m_originalFrameOfView];
    [UIView commitAnimations];
    
}

-(void)keyboardWillShow:(NSNotification *)_notification
{
    
    if (CGRectIsEmpty(m_originalFrameOfView)) {
        
        m_originalFrameOfView = self.view.frame;
        
    }
    CGRect aRect = self.view.window.bounds;
    float winWidth = aRect.size.width;
    float winHeight = aRect.size.height;
    
    
    CGSize keyboardSize = [[[_notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    float keyboardHeight = keyboardSize.height;
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            keyboardHeight = keyboardSize.width;
            aRect.size.width = winHeight;
            aRect.size.height = winWidth;
        }
        
    }
    
    aRect.size.height -= keyboardHeight;
    
    
    
    CGPoint origin = [m_currentTextField.superview convertPoint:m_currentTextField.frame.origin toView:self.view];
    
    origin.x += self.view.superview.frame.origin.x;
    origin.y += self.view.superview.frame.origin.y;
    
    origin.y +=m_currentTextField.frame.size.height;
    
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (aRect.size.height) -origin.y);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.5];
        self.view.frame = CGRectMake(0,scrollPoint.y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    
    
}

- (BOOL) checkIsValid
{
    
    
    if (!([[DiveInformation convertInternationalFormatValue:m_txtVolume.text] doubleValue] > 0)) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Volume." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    
    if (!([[DiveInformation convertInternationalFormatValue:m_txtStartPressure.text] doubleValue] > 0))
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Start pressure." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    
    if (!([[DiveInformation convertInternationalFormatValue:m_txtEndPressure.text] doubleValue] > 0))
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of End pressure." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    
    if (![m_viewStartTimeRow isHidden]) {
       
        if ([[DiveInformation convertInternationalFormatValue:m_txtStartTime.text] doubleValue] < 1)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter value of Start time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return NO;
        }
        
    }
    
    return YES;
}

@end
