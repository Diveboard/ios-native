//
//  OneDiveView.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/27/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "OneDiveView.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImageView.h"


@interface OneDiveView()
{
    AppManager *appManager;
    
    NSString *currentDiveID;
    float     subPicImageHeight;
    UIInterfaceOrientation orientation;
}

@end
@implementation OneDiveView

- (id)initWithFrame:(CGRect)frame diveID:(NSString *)diveID rotate:(UIInterfaceOrientation)orien
{
    if (orien == UIInterfaceOrientationPortrait) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveView" owner:self options:Nil] objectAtIndex:0];
    } else {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OneDiveViewLand" owner:self options:Nil] objectAtIndex:0];
    }
    
    if (self) {
        [self setFrame:frame];
        appManager = [AppManager sharedManager];
        orientation = orien;
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
    lblLogedBy.font         = [UIFont fontWithName:kDefaultFontName size:8.0f];
    lblLogedUserName.font   = [UIFont fontWithName:kDefaultFontName size:12.0f];
    lblTripName.font        = [UIFont fontWithName:kDefaultFontNameBold size:12.0f];
    lblTripNameTitle.font   = [UIFont fontWithName:kDefaultFontName size:10.0f];
    lblSpotName.font        = [UIFont fontWithName:kDefaultFontName size:14.0f];
    lblSpotCountryCity.font = [UIFont fontWithName:kDefaultFontName size:12.0f];
    lblSpotDate.font        = [UIFont fontWithName:kDefaultFontName size:10.0f];
    lblSpotDepth.font       = [UIFont fontWithName:kDefaultFontName size:10.0f];
    lblSpotDuration.font    = [UIFont fontWithName:kDefaultFontName size:10.0f];
    
    
    subPicImageHeight = 40.0f;
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
    }
    
    [imgviewMainPhoto setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
    lblLogedUserName.text = appManager.loginResult.user.nickName;
    [imgviewAvator setImageWithURL:[NSURL URLWithString:appManager.loginResult.user.pictureSmall]];
//                  placeholderImage:[UIImage imageNamed:@"default_user_photo"]];
    
    [viewLoadingScreen setHidden:YES];
    
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

#pragma mark - Loading Dive Data

- (void) loadDiveData:(NSString *)diveID
{
    [self addLoadingScreen];
    NSString *authToken = appManager.loginResult.token;
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/V2/dive/%@", SERVER_URL, diveID] ; //]@"77197"];
    
    NSDictionary *params = @{@"auth_token": authToken,
                             @"apikey"    : API_KEY,
                             @"flavour"   :FLAVOUR,
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data"  forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json"     forHTTPHeaderField:@"Accept"];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self requestResultCheckingWithObject:responseObject];
        [self removeLoadingScreen];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [lblLoadingError setHidden:NO];
        [lblLoadingError setText:[NSString stringWithFormat:@"%@", error]];
    }];
    
}

- (void) requestResultCheckingWithObject:(id)responseObject
{
    if (responseObject) {
        NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject];
//        NSLog(@"%@", data);
        if ([[data objectForKey:@"success"] boolValue]) {
            diveInfoOfSelf = [[DiveInformation alloc] initWithDictionary:[data objectForKey:@"result"]];
            [appManager.loadedDives setObject:responseObject forKey:currentDiveID];
            
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
    lblSpotDepth.text = [NSString stringWithFormat:@"%@ METERS", diveInfoOfSelf.maxDepth];
    lblSpotDuration.text = [NSString stringWithFormat:@"%@ MINS", diveInfoOfSelf.duration];
    lblSpotCountryCity.text = [NSString stringWithFormat:@"%@ - %@", diveInfoOfSelf.spotInfo.counttyName, diveInfoOfSelf.spotInfo.locationName];
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
            AsyncImageView *subPicImageView = [[AsyncImageView alloc] initWithFrame:picRect];
            subPicImageView.clipsToBounds = YES;
            subPicImageView.layer.cornerRadius = subPicImageHeight / 2;
            subPicImageView.backgroundColor = [UIColor clearColor];
            DivePicture *onePicInfo = [diveInfoOfSelf.divePictures objectAtIndex:i];
            NSURL *picURL = [NSURL URLWithString:onePicInfo.smallURL];
//            [subPicImageView setImageWithURL:picURL]; // placeholderImage:[UIImage imageNamed:@"preload"]];
            [subPicImageView loadImageFromURL:picURL];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            [imgviewMainPhoto addGestureRecognizer:tapGesture];
            [subPicImageView addGestureRecognizer:tapGesture];
            
            [subPicImageView setUserInteractionEnabled:YES];
            
            [viewSubPicturesBox addSubview:subPicImageView];
            if (i == 0) {
//                [imgviewMainPhoto setImageWithURL:[NSURL URLWithString:onePicInfo.largeURL]];
                AsyncImageView *imageview = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imgviewMainPhoto.frame.size.width, imgviewMainPhoto.frame.size.height)];
                [imageview setBackgroundColor:[UIColor clearColor]];
                [imageview loadImageFromURL:[NSURL URLWithString:onePicInfo.largeURL]];
                [imageview setUserInteractionEnabled:NO];
                [imgviewMainPhoto addSubview:imageview];
            }
        }
    } else {
//        [imgviewMainPhoto setImageWithURL:[NSURL URLWithString:diveInfoOfSelf.imageURL]];
        //                     placeholderImage:[UIImage imageNamed:@"preload"]];
        AsyncImageView *imageview = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imgviewMainPhoto.frame.size.width, imgviewMainPhoto.frame.size.height)];
        [imageview setBackgroundColor:[UIColor clearColor]];
        [imageview loadImageFromURL:[NSURL URLWithString:diveInfoOfSelf.imageURL]];
        [imageview setUserInteractionEnabled:NO];
        [imgviewMainPhoto addSubview:imageview];

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


@end
