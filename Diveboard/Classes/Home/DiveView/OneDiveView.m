//
//  OneDiveView.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/27/14.
//  Copyright (c) 2014 C. All rights reserved.
//

#import "OneDiveView.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImageView.h"

@interface OneDiveView()
{
    AppManager *appManager;
    int         diveLengthUnit;
    
    NSString *currentDiveID;
    float     subPicImageHeight;
    UIInterfaceOrientation orientation;
}

@end


@implementation OneDiveView

- (id)initWithFrame:(CGRect)frame diveID:(NSString *)diveID rotate:(UIInterfaceOrientation)orien
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (orien == UIInterfaceOrientationPortrait) {
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveView" owner:self options:Nil] objectAtIndex:0];
            } else {
                self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveView-mini" owner:self options:Nil] objectAtIndex:0];
            }
        } else {
            self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveViewLand" owner:self options:Nil] objectAtIndex:0];
        }
        
    } else {
        if (orien == UIInterfaceOrientationPortrait) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveView-ipad" owner:self options:Nil] objectAtIndex:0];

        } else {
            self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveView-ipadland" owner:self options:Nil] objectAtIndex:0];
        }

    }

    
    if (self) {
        [self setFrame:frame];
        appManager = [AppManager sharedManager];
        orientation = orien;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        diveLengthUnit = [[ud objectForKey:kDiveboardUnit] intValue];
        
        [self initMethod];
        
//        [self setDiveID:diveID];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) initMethod
{
    
    subPicImageHeight = 40.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        subPicImageHeight = 70.0f;
    }


    // layout orientation is portrate
    if (orientation == UIInterfaceOrientationPortrait) {
        imgviewMainPhoto.layer.cornerRadius = imgviewMainPhoto.frame.size.width / 2;
        float borderWidth = 5.0f;
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectInset(imgviewMainPhoto.frame, borderWidth * 0.2f, borderWidth * 0.2f)];
        borderView.backgroundColor = [UIColor clearColor];
        borderView.layer.cornerRadius = borderView.frame.size.width / 2;
        borderView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3f].CGColor;
        borderView.layer.borderWidth = borderWidth ;
        borderView.userInteractionEnabled = NO;
        [imgviewMainPhoto.superview addSubview:borderView];
        subPicImageHeight = 45.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            subPicImageHeight = 90;
        }
    }
    

    
    [imgviewMainPhoto setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
    lblLogedUserName.text = appManager.loginResult.user.nickName;
    [imgviewAvator setImageWithURL:[NSURL URLWithString:appManager.loginResult.user.pictureSmall]];
//                  placeholderImage:[UIImage imageNamed:@"default_user_photo"]];
    
    [viewLoadingScreen setHidden:NO];
    
}

- (void) addLoadingScreen
{
    [viewLoadingScreen setHidden:NO];
    [viewLoadingScreen setAlpha:1.0f];
    [indicatorLoading startAnimating];
}

- (void) removeLoadingScreen
{
    [UIView animateWithDuration:0.5f animations:^{
        [viewLoadingScreen setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [viewLoadingScreen setHidden:YES];
    }];
}

#pragma mark -

- (void)setDiveID:(NSString *)diveID
{
    currentDiveID = diveID;
    if (appManager.loadedDives) {
        NSDictionary *diveInfo = [appManager.loadedDives objectForKey:currentDiveID];
        if (diveInfo) {
            [self removeLoadingScreen];
            [self requestResultCheckingWithObject:diveInfo];
        } else {
            [self loadDiveData:diveID];
        }
    } else {
        appManager.loadedDives = [[NSMutableDictionary alloc] init];
        [self loadDiveData:diveID];
    }
}

- (DiveInformation *)getDiveInformation
{
    return diveInfoOfSelf;
}

- (void) setDiveInformation:(DiveInformation *)diveInfo
{
    diveInfoOfSelf = diveInfo;
    [self setDiveValueToSelf];
}

- (void)changeDepthUnit:(int)type
{
    [lblSpotDepth setText:[DiveInformation unitOfLengthWithValue:diveInfoOfSelf.maxDepth
                                                     defaultUnit:diveInfoOfSelf.maxDepthUnit]];
    diveLengthUnit = type;
}

#pragma mark - Loading Dive Data

- (void) loadDiveData:(NSString *)diveID
{
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        [self requestResultCheckingWithObject:[[DiveOfflineModeManager sharedManager] getOneDiveInformation:diveID]];
        [self removeLoadingScreen];
        return;
    }
    
    
    [self addLoadingScreen];
    NSString *authToken = appManager.loginResult.token;
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/dive/%@", SERVER_URL, diveID] ; //]@"77197"];
    
    NSDictionary *params = @{@"auth_token": authToken,
                             @"apikey"    : API_KEY,
                             @"flavour"   : FLAVOUR,
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data"  forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json"     forHTTPHeaderField:@"Accept"];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self requestResultCheckingWithObject:responseObject];
        [self removeLoadingScreen];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 13/May/2014
        [DiveOfflineModeManager sharedManager].isOffline = YES;
        [self loadDiveData:diveID];
        
//        [lblLoadingError setHidden:NO];
//        [lblLoadingError setText:[NSString stringWithFormat:@"%@", error]];
    }];
    
}

- (void) requestResultCheckingWithObject:(id)responseObject
{
    if (responseObject) {
        NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject];
        NSLog(@"%@", data);
        if ([[data objectForKey:@"success"] boolValue]) {
            diveInfoOfSelf = [[DiveInformation alloc] initWithDictionary:[data objectForKey:@"result"]];
            [appManager.loadedDives setObject:responseObject forKey:currentDiveID];
            [[DiveOfflineModeManager sharedManager] writeOneDiveInformation:responseObject overwrite:NO];
            NSLog(@"--- end ----");
            
            [self setDiveValueToSelf];
            
        } else {
            
        }
    }
}

- (void) setDiveValueToSelf
{
    lblSpotName.text = diveInfoOfSelf.spotInfo.name;
    lblSpotDate.text = diveInfoOfSelf.date;
    
    
    [lblSpotDepth setText:[DiveInformation unitOfLengthWithValue:diveInfoOfSelf.maxDepth
                                                     defaultUnit:diveInfoOfSelf.maxDepthUnit]];
    
    lblSpotDuration.text = [NSString stringWithFormat:@"%@ mins", diveInfoOfSelf.duration];
    lblSpotCountryCity.text = [NSString stringWithFormat:@"%@ - %@", diveInfoOfSelf.spotInfo.countryName, diveInfoOfSelf.spotInfo.locationName];
    lblTripName.text = diveInfoOfSelf.tripName;
    if (diveInfoOfSelf.tripName.length == 0) {
        [viewTripBox setHidden:YES];
    } else {
        [viewTripBox setHidden:NO];
    }
    
    if (diveInfoOfSelf.divePictures.count > 0) {
        UITapGestureRecognizer *tapGesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imgviewMainPhoto addGestureRecognizer:tapGesture0];
        [imgviewMainPhoto setUserInteractionEnabled:YES];
        
        int subPicCount = diveInfoOfSelf.divePictures.count;
        if (subPicCount > 5) subPicCount = 5;
        float subPicSpace = subPicImageHeight * 0.1;
        float ww1 = (subPicImageHeight * subPicCount) + (subPicSpace * (subPicCount - 1));
        float ox  = (viewSubPicturesBox.frame.size.width - ww1) / 2;
        for (int i = 0; i < subPicCount; i ++) {
            CGRect picRect = CGRectMake(ox + (subPicImageHeight + subPicSpace) * i, 0, subPicImageHeight, subPicImageHeight);
            //            UIImageView *subPicImageView = [[UIImageView alloc] initWithFrame:picRect];
            AsyncUIImageView *subPicImageView = [[AsyncUIImageView alloc] initWithFrame:picRect];
            [subPicImageView setContentMode:(UIViewContentModeScaleAspectFill)];
            subPicImageView.clipsToBounds = YES;
            subPicImageView.layer.cornerRadius = subPicImageHeight / 2;
            subPicImageView.backgroundColor = [UIColor clearColor];
            DivePicture *onePicInfo = [diveInfoOfSelf.divePictures objectAtIndex:i];
            NSURL *picURL = [NSURL URLWithString:onePicInfo.smallURL];
            //            [subPicImageView setImageWithURL:picURL]; // placeholderImage:[UIImage imageNamed:@"preload"]];
            [subPicImageView setImageURL:picURL placeholder:nil]; // loadImageFromURL:picURL];
            
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
//            [subPicImageView addGestureRecognizer:tapGesture];
            
            [subPicImageView setUserInteractionEnabled:NO];
            
            [viewSubPicturesBox addSubview:subPicImageView];
            if (i == 0) {
                [imgviewMainPhoto setImageURL:picURL placeholder:nil]; // setImageWithURL:[NSURL URLWithString:onePicInfo.largeURL]];
            }
        }
    } else {
        [imgviewMainPhoto setImageURL:[NSURL URLWithString:diveInfoOfSelf.imageURL] placeholder:nil];
    }
    
    self.isLoadedData = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(oneDiveViewDataLoadFinish:diveInfo:)]) {
        [self.delegate oneDiveViewDataLoadFinish:self diveInfo:diveInfoOfSelf];
    }
}

- (void) imageTapAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(oneDiveViewImageTouch:diveInfo:)]) {
        [self.delegate oneDiveViewImageTouch:self diveInfo:diveInfoOfSelf];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isLoadedData) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(oneDiveViewDetailClick:diveInfo:)]) {
            [self.delegate oneDiveViewDetailClick:self diveInfo:diveInfoOfSelf];
        }

    }
}

@end
