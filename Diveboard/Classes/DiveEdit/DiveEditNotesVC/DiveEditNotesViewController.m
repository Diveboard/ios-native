//
//  DiveEditNotesViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditNotesViewController.h"
#import "DiveInformation.h"
#import "DrawerMenuViewController.h"
@interface DiveEditNotesViewController ()

{
    DiveInformation* m_DiveInformation;
    CGRect m_frameOfOriginalTextNote;
}


@end

@implementation DiveEditNotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDiveData:(id)diveInfo{
    
    NSString *nibFilename;
    nibFilename = @"DiveEditNotesViewController";
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        nibFilename = @"DiveEditNotesViewController";
//    } else {
//        nibFilename = @"DiveEditNotesViewController-ipad";
//    }
    
    self = [self initWithNibName:nibFilename bundle:nil];
    
    if (self) {
        m_DiveInformation = diveInfo;
    }
    
    return self;
    
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    m_DiveInformation = diveInfo;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [m_txtDiveNote setText:m_DiveInformation.note];
        
    });
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [m_txtDiveNote setText:m_DiveInformation.note];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    m_txtDiveNote.inputAccessoryView = numberToolbar;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doneWithNumberPad{
    
    [self.view endEditing:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    
    m_DiveInformation.note = m_txtDiveNote.text;
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;

    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (![m_DiveInformation.note isEqualToString:m_txtDiveNote.text]) {
        m_DiveInformation.note = m_txtDiveNote.text;
        [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    }
}
-(void)keyboardWillHide:(NSNotification *)_notification
{
    [m_txtDiveNote setFrame:m_frameOfOriginalTextNote];
    m_frameOfOriginalTextNote = CGRectMake(0, 0, 0, 0);
}

-(void)keyboardWillShow:(NSNotification *)_notification
{
    

    CGSize keyboardSize = [[[_notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    float keyboardHeight = keyboardSize.height;
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            keyboardHeight = keyboardSize.width;
        }
        
    }
    
    CGRect frame = m_txtDiveNote.frame;
    
    if (CGRectIsEmpty(m_frameOfOriginalTextNote)) {
        m_frameOfOriginalTextNote = frame;
    }

    frame.size.height -=keyboardHeight-40;
    
    [m_txtDiveNote setFrame:frame];
    
}

@end
