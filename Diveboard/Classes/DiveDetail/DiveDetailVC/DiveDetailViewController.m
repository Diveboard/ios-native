//
//  DiveDetailViewController.m
//  Diveboard
//
//  Created by SergeyPetrov on 11/2/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import "DiveDetailViewController.h"
#import "DiveDetailShopGraphCell.h"
#import "DiveDetailDateCell.h"
#import "DiveDetailBaseCell.h"
#import "DiveDetailNoteCell.h"
#import "DiveDetailReviewCell.h"
#import "DiveDetailTankUsedCell.h"
#import "DiveDetailBuddiesCell.h"
#import "DiveBrowserCell.h"
#import "DiveGraphViewController.h"
#import "UIView+FindUIViewController.h"
#import "Global.h"
@interface DiveDetailViewController () <DiveDetailShopGraphCellDelegate>

{
    DiveInformation *m_DiveInformation;
    NSMutableArray *m_tableData;
    
}

@end


@implementation DiveDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithDiveInformation:(DiveInformation *) diveInfo
{
    NSString *nibFilename;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibFilename = @"DiveDetailViewController";
    } else {
        nibFilename = @"DiveDetailViewController-iPad";
    }
    
    self = [self initWithNibName:nibFilename bundle:nil];
    if (self) {
        m_DiveInformation = diveInfo;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    vdbtnDelete.layer.cornerRadius = 5.0f;
    vdbtnEdit.layer.cornerRadius = 5.0f;
    
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([m_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [m_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    m_tableData = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showDetailData];
    
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    m_DiveInformation = diveInfo;
    
}

- (void) showDetailData
{
    
    [m_tableData removeAllObjects];
    // username , photo
    [vdimgUserAvator setImageURL:[NSURL URLWithString:[AppManager sharedManager].loginResult.user.pictureSmall]
                     placeholder:Nil];
    vdimgUserAvator.layer.cornerRadius = vdimgUserAvator.frame.size.width / 2;
    
    
    [vdlblNickname          setText:[AppManager sharedManager].loginResult.user.nickName];
    
    if ([[AppManager sharedManager].loginResult.user.danData.address isKindOfClass:[NSArray class]]) {
        id country = [[AppManager sharedManager].loginResult.user.danData.address lastObject];
        if (country != [NSNull null]) {
            [vdlblCountry           setText:(NSString *)country];
        } else {
            [vdlblCountry setText:@""];
        }
        
    }
    
    
    
    NSString* strNibCell;
    strNibCell = @"DiveDetailShopGraphCell";
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    DiveDetailShopGraphCell* graphShopCell = (DiveDetailShopGraphCell*)[nib objectAtIndex:0];
    graphShopCell.delegate = self;
    [graphShopCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [m_tableData addObject:graphShopCell];
    
    
    
    strNibCell = @"DiveDetailDateCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    DiveDetailDateCell* dateCell = (DiveDetailDateCell*)[nib objectAtIndex:0];
    [dateCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [m_tableData addObject:dateCell];

    
    
    strNibCell = @"DiveDetailNoteCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    DiveDetailNoteCell* noteCell = (DiveDetailNoteCell*)[nib objectAtIndex:0];
    [noteCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [m_tableData addObject:noteCell];

    strNibCell = @"DiveDetailReviewCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    DiveDetailReviewCell* reviewCell = (DiveDetailReviewCell*)[nib objectAtIndex:0];
    [reviewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [m_tableData addObject:reviewCell];

    if (m_DiveInformation.tanksUsed.count > 0) {

        strNibCell = @"DiveDetailTankUsedCell";
        nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
        DiveDetailTankUsedCell* tankUsedCell = (DiveDetailTankUsedCell*)[nib objectAtIndex:0];
        [tankUsedCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [m_tableData addObject:tankUsedCell];

        
    }

    if (m_DiveInformation.buddies.count > 0) {
        
        strNibCell = @"DiveDetailBuddiesCell";
        nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
        DiveDetailBuddiesCell* buddiesCell = (DiveDetailBuddiesCell*)[nib objectAtIndex:0];
        [buddiesCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [m_tableData addObject:buddiesCell];
        
        
    }
    strNibCell = @"DiveBrowserCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    DiveBrowserCell* browserCell = (DiveBrowserCell*)[nib objectAtIndex:0];
    [browserCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [m_tableData addObject:browserCell];
    
    
    
    [m_tableView reloadData];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:m_tableView
                                   selector:@selector(reloadData)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)viewWillLayoutSubviews
{
    [m_tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DiveDetailBaseCell *cell = (DiveDetailBaseCell*) [m_tableData objectAtIndex:indexPath.row];
    
    [cell setDiveInformation:m_DiveInformation];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return m_tableData.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DiveDetailBaseCell* cell = (DiveDetailBaseCell*)[m_tableData objectAtIndex:indexPath.row];
    
    return [cell getHeight];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)diveDeleteAction:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedDeleteButton)]) {

        [self.delegate didClickedDeleteButton];
        
    }
    
}

-(void)diveEditAction:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedEditButton)]) {


        [self.delegate didClickedEditButton];
        
    }
    
}

-(void)didClickedGraph
{
    
    DiveGraphViewController* graphVC = [[DiveGraphViewController alloc] initWithDiveData:m_DiveInformation];
    
    UIViewController* vc = [self.view.superview firstAvailableUIViewController];
    [vc presentViewController:graphVC animated:YES completion:nil];
    
}

@end
