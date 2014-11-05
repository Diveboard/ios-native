//
//  DiveEditReviewViewController.m
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/18/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import "DiveEditReviewViewController.h"
#import "DXStarRatingView.h"
#import "DiveInformation.h"
@interface DiveEditReviewViewController ()
{
    NSArray *m_arrRatings1;
    NSArray *m_arrRatings2;
    DiveReview* m_review;
    
}
@end

@implementation DiveEditReviewViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDiveReview:(DiveReview *)review{
    
    self = [super initWithNibName:@"DiveEditReviewViewController" bundle:nil];
    
    if (self) {
        
        m_review = [[DiveReview alloc] init];
        m_review.overall = review.overall;
        m_review.difficulty = review.difficulty;
        m_review.marine = review.marine;
        m_review.bigfish = review.bigfish;
        m_review.wreck = review.wreck;
        
    }
    
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    m_arrRatings1 = @[@"",@"Terrible",@"Poor",@"Average",@"Very good",@"Excellent!"];
    m_arrRatings2 = @[@"",@"Trivial",@"Simple",@"Somewhat simple",@"Tricky",@"Hardcore!"];
    
    [m_DXStarViewOverAll setStars:m_review.overall target:self callbackAction:@selector(didChangeOverAllRating:)];
    
    [m_DXStarViewDiveDifficulty setStars:m_review.difficulty target:self callbackAction:@selector(didChangeDiveDifficultyRating:)];
    
    [m_DXStarViewMarineLife setStars:m_review.marine target:self callbackAction:@selector(didChangeMarineLifeRating:)];
    
    [m_DXStarViewBigFish setStars:m_review.bigfish target:self callbackAction:@selector(didChangeBigFishRating:)];
    
    [m_DXStarViewWreckSighted setStars:m_review.wreck target:self callbackAction:@selector(didChangeWreckSightedRating:)];
    
    [self didChangeOverAllRating:[NSNumber numberWithInt:m_review.overall]];
    
    [self didChangeDiveDifficultyRating:[NSNumber numberWithInt:m_review.difficulty]];
    
    [self didChangeMarineLifeRating:[NSNumber numberWithInt:m_review.marine]];
    
    [self didChangeBigFishRating:[NSNumber numberWithInt:m_review.bigfish]];
    
    [self didChangeWreckSightedRating:[NSNumber numberWithInt:m_review.wreck]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didChangeOverAllRating:(NSNumber*)newRating
{
    
    m_review.overall = [newRating intValue];
    NSString* strRating = [m_arrRatings1 objectAtIndex:[newRating intValue]];
    
    [m_lblOverAll setText:strRating];
    
}
- (void)didChangeDiveDifficultyRating:(NSNumber*)newRating
{

    m_review.difficulty = [newRating intValue];

    NSString* strRating = [m_arrRatings2 objectAtIndex:[newRating intValue]];
    
    [m_lblDiveDifficulty setText:strRating];
    

}
- (void)didChangeMarineLifeRating:(NSNumber*)newRating
{

    m_review.marine = [newRating intValue];
    
    NSString* strRating = [m_arrRatings1 objectAtIndex:[newRating intValue]];
    
    [m_lblMarineLife setText:strRating];
    
    
}
- (void)didChangeBigFishRating:(NSNumber*)newRating
{
 
    m_review.bigfish = [newRating intValue];
    
    NSString* strRating = [m_arrRatings1 objectAtIndex:[newRating intValue]];
    
    [m_lblBigFish setText:strRating];
    
}

- (void)didChangeWreckSightedRating:(NSNumber*)newRating
{
    
    m_review.wreck = [newRating intValue];
    
    NSString* strRating = [m_arrRatings1 objectAtIndex:[newRating intValue]];
    
    [m_lblWreckSighted setText:strRating];

}

-(void)onOK:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectReview:)]) {
        
        [self.delegate didSelectReview:m_review];
        
    }
    
    
}
-(void)onCancel:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelReview)]) {
        
        [self.delegate didCancelReview];
        
    }
    
    
}
-(void)onClearStar:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    switch (button.tag) {
            
        case 100:
            
            [m_DXStarViewOverAll setStars:0];
            [self didChangeOverAllRating:0];

            break;
        case 101:
            
            [m_DXStarViewDiveDifficulty setStars:0];
            [self didChangeDiveDifficultyRating:0];
            
            break;
        case 102:
            
            [m_DXStarViewMarineLife setStars:0];
            [self didChangeMarineLifeRating:0];
            
            break;
        case 103:
            
            [m_DXStarViewBigFish setStars:0];
            [self didChangeBigFishRating:0];
            
            break;
        case 104:
            
            [m_DXStarViewWreckSighted setStars:0];
            [self didChangeWreckSightedRating:0];
            
            break;
            
        default:
            break;
    }
    
    
    
    
    
    
}


@end
