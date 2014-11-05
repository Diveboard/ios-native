//
//  DiveEditReviewViewController.h
//  Diveboard
//
//  Created by Vladimir Popov on 9/18/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXStarRatingView;
@class DiveReview;
@protocol DiveEditReviewViewControllerDelegate <NSObject>

@optional

- (void)didSelectReview:(DiveReview*)review;
- (void)didCancelReview;

@end

@interface DiveEditReviewViewController : UIViewController
{
    
    
    
    IBOutlet UILabel* m_lblOverAll;
    IBOutlet UILabel* m_lblDiveDifficulty;
    IBOutlet UILabel* m_lblMarineLife;
    IBOutlet UILabel* m_lblBigFish;
    IBOutlet UILabel* m_lblWreckSighted;
    IBOutlet DXStarRatingView *m_DXStarViewOverAll;
    IBOutlet DXStarRatingView *m_DXStarViewDiveDifficulty;
    IBOutlet DXStarRatingView *m_DXStarViewMarineLife;
    IBOutlet DXStarRatingView *m_DXStarViewBigFish;
    IBOutlet DXStarRatingView *m_DXStarViewWreckSighted;
    
    
}
@property (nonatomic, strong) id<DiveEditReviewViewControllerDelegate> delegate;

- initWithDiveReview:(DiveReview*)review;

- (IBAction) onOK:(id)sender;
- (IBAction) onCancel:(id)sender;
- (IBAction) onClearStar:(id)sender;


@end
