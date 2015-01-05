//
//  DiveDetailViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/2/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
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
#import "UIImageView+AFNetworking.h"
@interface DiveDetailViewController () <DiveDetailShopGraphCellDelegate>

{
    DiveInformation *m_DiveInformation;
    NSMutableArray *m_tableData;
    DiveDetailShopGraphCell* graphShopCell;
    DiveDetailDateCell* dateCell;
    DiveDetailNoteCell* noteCell;
    DiveDetailReviewCell* reviewCell;
    DiveDetailTankUsedCell* tankUsedCell;
    DiveDetailBuddiesCell* buddiesCell;
    DiveBrowserCell* browserCell;
    
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
    
    NSString* strNibCell;
    
    
    strNibCell = @"DiveDetailShopGraphCell";
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    graphShopCell = (DiveDetailShopGraphCell*)[nib objectAtIndex:0];
    graphShopCell.delegate = self;
    [graphShopCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    strNibCell = @"DiveDetailDateCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    dateCell = (DiveDetailDateCell*)[nib objectAtIndex:0];
    [dateCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    strNibCell = @"DiveDetailNoteCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    noteCell = (DiveDetailNoteCell*)[nib objectAtIndex:0];
    [noteCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    strNibCell = @"DiveDetailReviewCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    reviewCell = (DiveDetailReviewCell*)[nib objectAtIndex:0];
    [reviewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    strNibCell = @"DiveDetailTankUsedCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    tankUsedCell = (DiveDetailTankUsedCell*)[nib objectAtIndex:0];
    [tankUsedCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        
    
    
    strNibCell = @"DiveDetailBuddiesCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    buddiesCell = (DiveDetailBuddiesCell*)[nib objectAtIndex:0];
    [buddiesCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        
    strNibCell = @"DiveBrowserCell";
    nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
    browserCell = (DiveBrowserCell*)[nib objectAtIndex:0];
    [browserCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    
    
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showDetailData];
        
    });

    
}

- (void) showDetailData
{
    
    [m_tableData removeAllObjects];
    // username , photo

    [vdimgUserAvator setImageWithURL:[NSURL URLWithString:[AppManager sharedManager].loginResult.user.pictureSmall]];
    
    vdimgUserAvator.layer.cornerRadius = vdimgUserAvator.frame.size.width / 2;
    
    
    [vdlblNickname          setText:[AppManager sharedManager].loginResult.user.nickName];

    
    [vdlblCountry setText:[AppManager sharedManager].loginResult.user.countryName];
        
    
    
    
    
    [m_tableData addObject:graphShopCell];
    
    
    [m_tableData addObject:dateCell];

    
    [m_tableData addObject:noteCell];

    [m_tableData addObject:reviewCell];

    if (m_DiveInformation.tanksUsed.count > 0) {

        [m_tableData addObject:tankUsedCell];
        
    }

    if (m_DiveInformation.buddies.count > 0) {
        
        [m_tableData addObject:buddiesCell];
        
    }
    
    [m_tableData addObject:browserCell];
    
    
    [m_tableView reloadData];
    
    
    
//    [NSTimer scheduledTimerWithTimeInterval:0.2
//                                     target:m_tableView
//                                   selector:@selector(reloadData)
//                                   userInfo:nil
//                                    repeats:NO];
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
