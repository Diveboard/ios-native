//
//  DiveDetailPhotosViewController.m
//  Diveboard
//
//  Created by SergeyPetrov on 11/2/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import "DiveDetailPhotosViewController.h"
#import "DiveEditPhotoCell.h"
#import "Global.h"
@interface DiveDetailPhotosViewController ()
{
    DiveInformation* m_DiveInformation;
}

@end

@implementation DiveDetailPhotosViewController

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
        nibFilename = @"DiveDetailPhotosViewController";
    } else {
        nibFilename = @"DiveDetailPhotosViewController-ipad";
    }
    
    nibFilename = @"DiveDetailPhotosViewController";
    self = [self initWithNibName:nibFilename bundle:nil];
    if (self) {
        m_DiveInformation = diveInfo;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [m_collectionViewPhoto registerNib:[UINib nibWithNibName:@"DiveEditPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPhotoData)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [self showPhotoData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    m_DiveInformation = diveInfo;
}

- (void)showPhotoData{
    
    if (m_DiveInformation.divePictures.count > 0) {
        
        [m_collectionViewPhoto setHidden:NO];
        [m_lblNoPictures setHidden:YES];
        [self.view setBackgroundColor:[UIColor clearColor]];
        
    }else{
        
        [m_collectionViewPhoto setHidden:YES];
        [m_lblNoPictures setHidden:NO];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    }
    [m_collectionViewPhoto reloadData];
}

-(DiveEditPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiveEditPhotoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (indexPath.row == m_DiveInformation.divePictures.count) {
        
        [cell setAddButton:indexPath];
        
    }else{
        
        DivePicture* divePicture = [m_DiveInformation.divePictures objectAtIndex:indexPath.row];
        [cell setDivePicture:indexPath:divePicture];
        
    }
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPhotoCell:)]) {
        
        [self.delegate didSelectedPhotoCell:(int)indexPath.row];
        
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return m_DiveInformation.divePictures.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    
        size.width = m_collectionViewPhoto.bounds.size.width/3;
        size.height = m_collectionViewPhoto.bounds.size.width/3;
    
    
    return size;
}

@end
