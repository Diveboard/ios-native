//
//  DiveDetailReviewCell.m
//  Diveboard
//
//  Created by Vladimir Popov on 11/3/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveDetailReviewCell.h"
#import "DXStarRatingView.h"
@implementation DiveDetailReviewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    [super setDiveInformation:diveInfo];
    
    for (UIView* v in m_viewContainer.subviews) {
        [v removeFromSuperview];
    }
    
    NSString *nameKey = @"name";
    NSString *markKey = @"mark";
    
    NSMutableArray *arrayReviews = [NSMutableArray array];
    
    if (m_DiveInformation.review.overall          > 0) {
        [arrayReviews addObject:@{nameKey: @"Overall:",
                                  markKey:[NSNumber numberWithInteger:m_DiveInformation.review.overall]}];
    }
    if (m_DiveInformation.review.difficulty   > 0) {
        [arrayReviews addObject:@{nameKey: @"Dive difficulty:",
                                  markKey:[NSNumber numberWithInteger:m_DiveInformation.review.difficulty]}];
    }
    if (m_DiveInformation.review.marine       > 0) {
        [arrayReviews addObject:@{nameKey: @"Marine life:",
                                  markKey:[NSNumber numberWithInteger:m_DiveInformation.review.marine]}];
    }
    
    if (m_DiveInformation.review.bigfish          > 0) {
        [arrayReviews addObject:@{nameKey: @"Big fish:",
                                  markKey:[NSNumber numberWithInteger:m_DiveInformation.review.bigfish]}];
    }
    
    if (m_DiveInformation.review.wreck     > 0) {
        [arrayReviews addObject:@{nameKey: @"Wreck sighted:",
                                  markKey:[NSNumber numberWithInteger:m_DiveInformation.review.wreck]}];
    }
    
    if (arrayReviews.count > 0) {
        [m_lblReviewTitle setText:@"REVIEW"];
        [m_lblReviewTitle setFont:[UIFont fontWithName:kDefaultFontNameBold size:12]];
        
        [arrayReviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *data = (NSDictionary *)obj;
            
            UILabel* lbl = [[UILabel alloc] init];
            [lbl setText:[data objectForKey:nameKey]];
            [lbl setFont:[UIFont fontWithName:kDefaultFontNameBold size:12]];
            [lbl setTextAlignment:NSTextAlignmentRight];
            CGRect frame = CGRectMake(25,  25 * idx, 90, 21);
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                frame = CGRectMake(30, 45 * idx, 100, 21);
            }
            
            [lbl setFrame:frame];
            [m_viewContainer addSubview:lbl];
            
            DXStarRatingView *ratingView = [[DXStarRatingView alloc] init];
            [ratingView setDisable:YES];
            [ratingView setStars:(int)[[data objectForKey:markKey] integerValue]];
            
            frame = CGRectMake(120, 25 * idx, 250, 21);
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                frame = CGRectMake(135, 45 * idx, 350, 42);
            }
            [ratingView setFrame:frame];
            [m_viewContainer addSubview:ratingView];
            
            
            
        }];
    } else {
        [m_lblReviewTitle setText:@"No Review for this dive."];
        [m_lblReviewTitle setFont:[UIFont fontWithName:kDefaultFontName size:10]];
        
        
    }
    
    
    CGRect reviewFrame = m_viewContainer.frame;
    
    reviewFrame.size.height = 25*arrayReviews.count;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        reviewFrame.size.height = 45*arrayReviews.count;
    }
    [m_viewContainer setFrame:reviewFrame];


    reviewFrame = self.frame;
    reviewFrame.size.height = CGRectGetMaxY(m_viewContainer.frame)+10;
    
    if (arrayReviews.count == 0) {
        reviewFrame.size.height = 40;
    }
    [self setFrame:reviewFrame];
    
}

@end
