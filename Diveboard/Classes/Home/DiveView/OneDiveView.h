//
//  OneDiveView.h
//  Diveboard
//
//  Created by Vladimir Popov on 2/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BugSense-iOS/BugSenseController.h>

#import "DiveInformation.h"

@protocol OneDiveViewDelegate;

@interface OneDiveView : UIView
{
    IBOutlet UIView         *viewBottomBox;
    IBOutlet UIImageView    *imgviewAvator;
    IBOutlet UILabel *lblLogedBy;
    IBOutlet UILabel        *lblLogedUserName;
    
    IBOutlet UIView         *viewMain;
    IBOutlet UIImageView    *imgviewMainPhoto;
    IBOutlet UILabel        *lblSpotName;
    IBOutlet UILabel        *lblSpotCountryCity;
    IBOutlet UILabel        *lblSpotDate;
    IBOutlet UILabel        *lblSpotDuration;
    IBOutlet UILabel        *lblSpotDepth;
    IBOutlet UIView         *viewSubPicturesBox;
    IBOutlet UIView         *viewTripBox;
    IBOutlet UILabel        *lblTripNameTitle;
    IBOutlet UILabel        *lblTripName;
    IBOutlet UIView *viewLoadingScreen;
    IBOutlet UIActivityIndicatorView *indicatorLoading;
    IBOutlet UILabel *lblLoadingError;
    
    
    DiveInformation *diveInfoOfSelf;
    
}

@property (nonatomic, strong) id<OneDiveViewDelegate> delegate;
@property int diveIndex;
@property BOOL isLoadedData;

- (id)initWithFrame:(CGRect)frame diveID:(NSString *)diveID rotate:(UIInterfaceOrientation)orien;

- (void) setDiveID:(NSString *)diveID;
- (DiveInformation *) getDiveInformation;
- (void) setDiveInformation:(DiveInformation *)diveInfo;
- (void) changeDepthUnit:(int)type;

@end


@protocol OneDiveViewDelegate <NSObject>

@optional;
- (void) oneDiveViewDataLoadFinish:(OneDiveView*)diveView diveInfo:(DiveInformation *)diveInfoOfSelf;
- (void) oneDiveViewImageTouch:(OneDiveView*)diveView     diveInfo:(DiveInformation *)diveInfoOfSelf;
- (void) oneDiveViewDetailClick:(OneDiveView*)diveView    diveInfo:(DiveInformation *)diveInfoOfSelf;

@end

