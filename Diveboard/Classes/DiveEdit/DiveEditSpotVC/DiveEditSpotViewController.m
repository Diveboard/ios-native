//
//  DiveEditSpotViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditSpotViewController.h"
#import "DiveInformation.h"
#import "MKMapView+ZoomLevel.h"
#import "AFNetworking.h"
#import "NIDropDown.h"
#import "DrawerMenuViewController.h"
@interface DiveEditSpotViewController () <NIDropDownDelegate>
{
    DiveInformation* m_DiveInformation;
    NSMutableArray *spotSearchResultArray;
    DiveEditSpotState m_editSpotState;
    MKPointAnnotation *mySpotAnnotation;
    NSMutableArray* m_arrCountry;
    NSMutableArray* m_arrRegion;
    NSMutableArray* m_arrLocation;

    NSMutableArray* m_arrCountryStr;
    NSMutableArray* m_arrRegionStr;
    NSMutableArray* m_arrLocationStr;

    
    NIDropDown* m_dropDown;
    int m_CountryIndex;
    int m_RegionIndex;
    int m_LocaitonIndex;
    
    NSMutableArray* m_arrAnnotations;
    
    UIView* m_currentEditView;
    CGPoint m_prevScrollPoint;
}
@end

@implementation DiveEditSpotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithDiveData:(DiveInformation *)diveInfo;
{
    NSString *nibFilename;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibFilename = @"DiveEditSpotViewController";
    } else {
        nibFilename = @"DiveEditSpotViewController-ipad";
    }

    self = [self initWithNibName:nibFilename bundle:nil];
    if (self) {
        m_DiveInformation = diveInfo;
    }
    return self;
}

-(void)setDiveInformation:(DiveInformation *)diveInfo
{
    m_DiveInformation = diveInfo;
    
    //    if ([m_DiveInformation.spotInfo.lat floatValue] == 0 && [m_DiveInformation.spotInfo.lng floatValue] == 0 ) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if ([m_DiveInformation.spotInfo.ID floatValue] != 1) {
            
            [self setAssignState];
            
        }else{
            
            
            [self onSetCurrentLocation:nil];
            [self setSearchState];
            
            
        }
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    m_arrCountry = [[NSMutableArray alloc] init];
    m_arrRegion = [[NSMutableArray alloc] init];
    m_arrLocation = [[NSMutableArray alloc] init];
    
    m_arrCountryStr = [[NSMutableArray alloc] init];
    m_arrRegionStr = [[NSMutableArray alloc] init];
    m_arrLocationStr = [[NSMutableArray alloc] init];
    
    [m_btnGPS.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_btnGPS.layer setBorderWidth:1.0];
    
    [m_btnAdd.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_btnAdd.layer setBorderWidth:1.0];

    [m_viewZoomCtrl.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_viewZoomCtrl.layer setBorderWidth:1.0];
    
    NSArray* infosubviews = [m_viewCurrentSpot subviews];
    for (UIView* view in infosubviews) {
        
        if (view.tag == 200) {
            
            [view.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
            [view.layer setBorderWidth:1.0];
            
        }
        
    }
    NSArray* subviews = [m_viewSpotAdd subviews];

    for (UIView* view in subviews) {
        
        if (view.tag == 200) {
            
            [view.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
            [view.layer setBorderWidth:1.0];
            
        }
        
    }

    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelWithNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    m_txtSearch.inputAccessoryView = numberToolbar;
    
   UILongPressGestureRecognizer* mapLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPressDetected:)];
    [m_mapViewSpot addGestureRecognizer:mapLongPressRecognizer];

    m_arrAnnotations = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([m_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [m_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //    if ([m_DiveInformation.spotInfo.lat floatValue] == 0 && [m_DiveInformation.spotInfo.lng floatValue] == 0 ) {
    if ([m_DiveInformation.spotInfo.ID floatValue] != 1) {
        
        [self setAssignState];
        
    }else{
        
        
        [self onSetCurrentLocation:nil];
        [self setSearchState];
        
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    
    
}

-(void)viewWillLayoutSubviews{
    
    [m_scrollView setContentSize:CGSizeMake(m_viewContainer.frame.size.width, m_viewContainer.frame.size.height)];
    
    
}
-(void)setAssignState{
    
    m_editSpotState = DiveEditSpotStateAssign;
    [m_viewCurrentSpot setHidden:NO];
    [m_viewSpotSearch setHidden:YES];
    [m_viewSpotAdd setHidden:YES];
    [self.view endEditing:YES];
    
    if (m_DiveInformation.spotInfo) {
        
        m_lblCurrentName.text = m_DiveInformation.spotInfo.name;
        m_lblCurrentCountry.text = m_DiveInformation.spotInfo.countryName;
        
        if (([m_DiveInformation.spotInfo.lat floatValue] == 0) && ([m_DiveInformation.spotInfo.lng floatValue] == 0)) {
            // coordinate value is empty
            m_lblCurrentGPS.text = @"";
            
        }
        else {
            // coordinate value is exist
            m_lblCurrentGPS.text = [NSString stringWithFormat:@"%.4f°N,  %.4f°E", [m_DiveInformation.spotInfo.lat floatValue], [m_DiveInformation.spotInfo.lng floatValue]];
        }
     
        ;
        
        CLLocationCoordinate2D spotLocation;
        spotLocation = CLLocationCoordinate2DMake([m_DiveInformation.spotInfo.lat doubleValue], [m_DiveInformation.spotInfo.lng doubleValue]);
        
        [m_mapViewSpot removeAnnotations:m_mapViewSpot.annotations];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setTitle:m_DiveInformation.spotInfo.name];
        [annotation setCoordinate:spotLocation];
        [m_mapViewSpot addAnnotation:annotation];

        [m_mapViewSpot setCenterCoordinate:spotLocation zoomLevel:10 animated:NO];
        
        
    }
}
- (void)setSearchState{

    [m_mapViewSpot removeAnnotations:m_mapViewSpot.annotations];
    m_editSpotState = DiveEditSpotStateSearch;
    [m_viewSpotSearch setHidden:NO];
    [m_viewCurrentSpot setHidden:YES];
    [m_viewSpotAdd setHidden:YES];
    [self searchSpotByLocation];

}
-(void)onSetCurrentLocation:(id)sender{
    
    
    [m_mapViewSpot setCenterCoordinate:[AppManager sharedManager].currentLocation.coordinate zoomLevel:10 animated:NO];
    
}

-(void)onChangeMapType:(id)sender{
    
    if (m_mapViewSpot.mapType == MKMapTypeStandard) {
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_map_view.png"] forState:UIControlStateNormal];
        [m_mapViewSpot setMapType:MKMapTypeSatellite];
        
    }else{
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_earth_view.png"] forState:UIControlStateNormal];
        [m_mapViewSpot setMapType:MKMapTypeStandard];
        
    }
    
}

#pragma mark    MKMapView Delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    if (m_txtSearch.text.length < 3) {
        
        
        [self searchSpotByLocation];
        
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* SpotMapAnnotationIdentifier = @"SpotAnnotationIdentifier";
    
    MKAnnotationView* pinView =  (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SpotMapAnnotationIdentifier];
    
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:SpotMapAnnotationIdentifier];
        
    }
    
    if (m_editSpotState == DiveEditSpotStateAdd ) {

        if (annotation == mySpotAnnotation) {
            [pinView setImage:[UIImage imageNamed:@"marker.png"]];
        }else{
            [pinView setImage:[UIImage imageNamed:@"marker_grey.png"]];
        }
        
    }else{
        
        [pinView setImage:[UIImage imageNamed:@"marker.png"]];
    }
        
        
        pinView.canShowCallout = YES;
    return pinView;
    
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    
    
    if (m_editSpotState == DiveEditSpotStateSearch) {
        
        MKPointAnnotation *annotation = view.annotation;
        int index = (int)[m_arrAnnotations indexOfObject:annotation];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [m_tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        
        
        
    }
    
}
- (void)onAddManualSpot:(id)sender{
    
    
    m_editSpotState = DiveEditSpotStateAdd;
    
    [m_viewSpotAdd setHidden:NO];
    [m_viewSpotSearch setHidden:YES];
    [m_viewCurrentSpot setHidden:YES];
    
    m_txtSpotName.text = @"My Spot";
    
    [m_mapViewSpot removeAnnotations:m_mapViewSpot.annotations];
    
    mySpotAnnotation = [[MKPointAnnotation alloc] init];
    mySpotAnnotation.title = @"My Spot";
    mySpotAnnotation.coordinate = m_mapViewSpot.centerCoordinate;
    [m_mapViewSpot addAnnotation:mySpotAnnotation];
    [self searchRegionLocaitons:mySpotAnnotation.coordinate.latitude :mySpotAnnotation.coordinate.longitude];
    

    
}
-(void)onZoomIn:(id)sender{
    
    float zoomLevel = m_mapViewSpot.zoomLevel+1;
    
    [m_mapViewSpot setCenterCoordinate:m_mapViewSpot.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
    
}
-(void)onZoomOut:(id)sender{
    
    float zoomLevel = m_mapViewSpot.zoomLevel-1;
    
    [m_mapViewSpot setCenterCoordinate:m_mapViewSpot.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
    
}

#pragma mark - Search Spot

- (void) searchSpot:(NSDictionary*) params
{
    
    [m_mapViewSpot removeAnnotations:m_mapViewSpot.annotations];
    [spotSearchResultArray removeAllObjects];
    [m_tableView reloadData];
    
    if (m_editSpotState == DiveEditSpotStateAdd) {
        
        [m_mapViewSpot addAnnotation:mySpotAnnotation];
        
    }
    
    

    if ([DiveOfflineModeManager sharedManager].isOffline) {
        
       [[DiveOfflineModeManager sharedManager] offlineSearchSpotText:[params objectForKey:@"term"] :[params objectForKey:@"lat"] :[params objectForKey:@"lng"] :[params objectForKey:@"latSW"] :[params objectForKey:@"latNE"] :[params objectForKey:@"lngSW"] :[params objectForKey:@"lngNE"] success:^(NSDictionary *resultSpotText) {
           
           [self filterSearchResult:resultSpotText];
           
       }];

        
    }else{
        
        NSString *requestURLString = [NSString stringWithFormat:@"%@/api/search_spot_text", SERVER_URL];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            [self filterSearchResult:data];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[DiveOfflineModeManager sharedManager] offlineSearchSpotText:[params objectForKey:@"term"] :[params objectForKey:@"lat"] :[params objectForKey:@"lng"] :[params objectForKey:@"latSW"] :[params objectForKey:@"latNE"] :[params objectForKey:@"lngSW"] :[params objectForKey:@"lngNE"] success:^(NSDictionary *resultSpotText) {
                
                [self filterSearchResult:resultSpotText];
                
            }];
            
        }];
    }
    
}

-(void) searchSpotByLocation{

    if (m_editSpotState == DiveEditSpotStateAssign) {
        return;
    }
    
    CLLocationCoordinate2D SWCoordinate = [m_mapViewSpot convertPoint:CGPointMake(0, m_mapViewSpot.frame.size.height) toCoordinateFromView:m_mapViewSpot];

    CLLocationCoordinate2D NECoordinate = [m_mapViewSpot convertPoint:CGPointMake(m_mapViewSpot.frame.size.width, 0) toCoordinateFromView:m_mapViewSpot];
    
    
    
    NSDictionary *params = @{@"lat": [NSNumber numberWithDouble:m_mapViewSpot.centerCoordinate.latitude],
                             @"lng": [NSNumber numberWithDouble:m_mapViewSpot.centerCoordinate.longitude],
                             @"latSW":[NSNumber numberWithDouble:SWCoordinate.latitude],
                             @"lngSW":[NSNumber numberWithDouble:SWCoordinate.longitude],
                             @"latNE":[NSNumber numberWithDouble:NECoordinate.latitude],
                             @"lngNE":[NSNumber numberWithDouble:NECoordinate.longitude],
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };

    
    [self searchSpot:params];
    
}

-(void) searchSpotByName{
    
    NSDictionary *params = @{@"term": m_txtSearch.text,
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };

    [self searchSpot:params];
    
    
}


- (void) filterSearchResult:(NSDictionary *)data
{
    if (!spotSearchResultArray) {
        spotSearchResultArray = [[NSMutableArray alloc] init];
    }
    [spotSearchResultArray removeAllObjects];
    [m_arrAnnotations removeAllObjects];
    if ([[data objectForKey:@"success"] boolValue]) {
        NSArray *results = [data objectForKey:@"spots"];
        int index = 0;
        for (NSDictionary *elem in results) {
            index++;
            DiveSpotInfo *spotInfo = [[DiveSpotInfo alloc] initWithDictionary:elem];
            [spotSearchResultArray addObject:spotInfo];
            
            CLLocationCoordinate2D spotLocation;
            
            spotLocation = CLLocationCoordinate2DMake([spotInfo.lat doubleValue], [spotInfo.lng doubleValue]);
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setTitle:[NSString stringWithFormat:@"%d: %@",index,spotInfo.name]];
            [annotation setCoordinate:spotLocation];
            [m_mapViewSpot addAnnotation:annotation];
            
            [m_arrAnnotations addObject:annotation];
            
            
        }
        
        
        
    }
    if (spotSearchResultArray.count == 0) {
        
        [m_lblNoResult setHidden:NO];
        
    } else {
        
        if (m_txtSearch.text.length > 2) {
            DiveSpotInfo* fObj = [spotSearchResultArray firstObject];
            CLLocationCoordinate2D firstSpotLocation = CLLocationCoordinate2DMake([fObj.lat doubleValue], [fObj.lng doubleValue]);
            
            [m_mapViewSpot setCenterCoordinate:firstSpotLocation zoomLevel:10 animated:NO];

        }
        [m_lblNoResult setHidden:YES];
        
    }
    [m_tableView reloadData];
}

#pragma mark - UITableView Datasource & delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
        [cell.textLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:kDefaultFontName size:12.0f]];
        UIView* selectedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
        [selectedBackView setBackgroundColor:kMainDefaultColor];
        [cell setSelectedBackgroundView:selectedBackView];
        
    }
    DiveSpotInfo *spotInfo = [spotSearchResultArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%d: %@",(int)indexPath.row+1,spotInfo.name]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@, %@", spotInfo.locationName,spotInfo.countryName]];
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DiveSpotInfo *spotInfo = [spotSearchResultArray objectAtIndex:indexPath.row];
//    m_DiveInformation.spotInfo = [[DiveSpotInfo alloc] initWithDictionary:[spotInfo getDataDictionary]];

    m_DiveInformation.spotInfo = [spotSearchResultArray objectAtIndex:indexPath.row];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self setAssignState];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return spotSearchResultArray.count;
}

#pragma UISearchBar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    if (m_txtSearch.text.length > 2) {
        
        [self searchSpotByName];
        [self.view endEditing:YES];
        
    }else{
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter 2+ characters." delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles: nil] show];
    
    }
    
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    m_currentEditView = searchBar;
    
}

-(void)onChangeSpot:(id)sender{
    
    if (m_dropDown) {
        [m_dropDown hideDropDown:m_dropDown.btnSender];
        m_dropDown = nil;
    }

    m_DiveInformation.spotInfo = [[DiveSpotInfo alloc] initWithEmptySpot];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    
    [self setSearchState];
    
}
- (void)onAddConfirm:(id)sender{
    
    if (m_dropDown) {
        [m_dropDown hideDropDown:m_dropDown.btnSender];
        m_dropDown = nil;
    }
    DiveSpotInfo* newSpot = [[DiveSpotInfo alloc] initWithDictionary:nil];
    
    newSpot.name = m_txtSpotName.text;
    newSpot.lat = [NSString stringWithFormat:@"%f",mySpotAnnotation.coordinate.latitude];
    newSpot.lng = [NSString stringWithFormat:@"%f",mySpotAnnotation.coordinate.longitude];
    

    if (m_arrCountry.count > 0) {
        
        NSDictionary* country = [m_arrCountry objectAtIndex:m_CountryIndex];
        
        newSpot.countryCode = getStringValue([country objectForKey:@"code"]);
        newSpot.countryName = getStringValue([country objectForKey:@"name"]);
        newSpot.countryID   = getStringValue([country objectForKey:@"id"]);

    }
    
    if (m_arrRegion.count > 0) {

        NSDictionary* region = [m_arrRegion objectAtIndex:m_RegionIndex];
        newSpot.regionName = getStringValue([region objectForKey:@"name"]);
        newSpot.regionID = getStringValue([region objectForKey:@"id"]);
        
    }
    
    if (m_arrLocation.count > 0) {
        
        NSDictionary* location = [m_arrLocation objectAtIndex:m_LocaitonIndex];
        newSpot.locationName =  getStringValue([location objectForKey:@"name"]);
        newSpot.locationID   =  getStringValue([location objectForKey:@"id"]);
    }
    
    
    m_DiveInformation.spotInfo = newSpot;
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self setAssignState];

}
- (void)doneWithNumberPad{
    
    
    [self.view endEditing:YES];
    [self searchBarSearchButtonClicked:m_txtSearch];
}
- (void)cancelWithNumberPad{
    
    [self.view endEditing:YES];
}
- (void)mapLongPressDetected:(UIGestureRecognizer*) gestureRecognizer{
    
    if (m_dropDown) {
        [m_dropDown hideDropDown:nil];
        m_dropDown = nil;
    }

    if (m_editSpotState != DiveEditSpotStateAdd) return;
    
    CGPoint point = [gestureRecognizer locationInView:m_mapViewSpot];
    
    CLLocationCoordinate2D tapPoint = [m_mapViewSpot convertPoint:point toCoordinateFromView:m_mapViewSpot];
    
    
    if (!mySpotAnnotation) {
        
        mySpotAnnotation = [[MKPointAnnotation alloc] init];
        mySpotAnnotation.title = @"My Spot";
        mySpotAnnotation.coordinate = tapPoint;
        [m_mapViewSpot addAnnotation:mySpotAnnotation];
        
    }else{
        
        mySpotAnnotation.coordinate = tapPoint;

    }
    
    [self searchRegionLocaitons:tapPoint.latitude :tapPoint.longitude];
    
    
}

- (void) searchRegionLocaitons:(double) lat :(double)lng
{

    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/search_region_text", SERVER_URL];
    NSDictionary *params = @{@"lat": [NSNumber numberWithDouble:lat],
                             @"lng": [NSNumber numberWithDouble:lng],
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };
    
    
    
    if ([DiveOfflineModeManager sharedManager].isOffline) {
        
        [[DiveOfflineModeManager sharedManager] offlinesearchRegionLocaitonsLat:[NSString stringWithFormat:@"%f",lat] lng:[NSString stringWithFormat:@"%f",lng] dist:@"2.0" success:^(NSDictionary *resultRegionLocations) {
            
            [self setRegionLocaitons:resultRegionLocations];
        }];
        
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            if ([[data objectForKey:@"success"] boolValue]) {
                
                [self setRegionLocaitons:data];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[DiveOfflineModeManager sharedManager] offlinesearchRegionLocaitonsLat:[NSString stringWithFormat:@"%f",lat] lng:[NSString stringWithFormat:@"%f",lng] dist:@"2.0" success:^(NSDictionary *resultRegionLocations) {
                
                [self setRegionLocaitons:resultRegionLocations];
                
            }];
            
            
        }];
        
        
    }
    
    
    

    
}

-(void)setRegionLocaitons:(NSDictionary*)data{
    
    
    [m_btnCountry setTitle:@"" forState:UIControlStateNormal];
    [m_btnRegion setTitle:@"" forState:UIControlStateNormal];
    [m_btnLocation setTitle:@"" forState:UIControlStateNormal];
    
    NSArray* countries = [data objectForKey:@"countries"];
    NSArray* regions =[data objectForKey:@"regions"];
    NSArray* locations = [data objectForKey:@"locations"];

    [m_arrCountry removeAllObjects];
    [m_arrRegion removeAllObjects];
    [m_arrLocation removeAllObjects];
    
    [m_arrCountryStr removeAllObjects];
    [m_arrRegionStr removeAllObjects];
    [m_arrLocationStr removeAllObjects];
    
    for (NSDictionary* dic in countries) {
        
        if (![getStringValue([dic objectForKey:@"name"]) isEqualToString:@""]) {
            
            [m_arrCountryStr addObject:getStringValue([dic objectForKey:@"name"])];
            [m_arrCountry addObject:dic];
        }
        
    }
    for (NSDictionary* dic in regions) {
        
        if (![getStringValue([dic objectForKey:@"name"]) isEqualToString:@""]) {
            [m_arrRegionStr addObject:getStringValue([dic objectForKey:@"name"])];
            [m_arrRegion addObject:dic];
            
        }
    }
    for (NSDictionary* dic in locations) {
        
        if (![getStringValue([dic objectForKey:@"name"]) isEqualToString:@""]) {
            
            [m_arrLocationStr addObject:getStringValue([dic objectForKey:@"name"])];
            [m_arrLocation addObject:dic];
            
        }
            
    }
    
    
    if (m_arrCountryStr.count > 0) {

        [m_btnCountry setTitle:[m_arrCountryStr firstObject] forState:UIControlStateNormal];
    
    }
    
    if (m_arrRegionStr.count > 0) {
        
        [m_btnRegion setTitle:[m_arrRegionStr firstObject] forState:UIControlStateNormal];
        
    }
    
    if (m_arrLocationStr.count > 0) {
        
        [m_btnLocation setTitle:[m_arrLocationStr firstObject] forState:UIControlStateNormal];
        
    }
    
    m_CountryIndex = 0;
    m_RegionIndex = 0;
    m_LocaitonIndex = 0;
    
}

-(void)onDropDown:(id)sender{
    
    UIButton* btnSender = (UIButton*)sender;
    NSArray * arr;

    if (btnSender == m_btnCountry) {
        
        arr = m_arrCountryStr;
        
    }else if (btnSender == m_btnRegion){
        
        arr = m_arrRegionStr;
        
    }else if (btnSender == m_btnLocation){
        
        arr = m_arrLocationStr;
        
    }
    
    CGFloat height = 30*arr.count;
    
    if (arr.count > 4) {
    
        height = 30*4;
        
    }
    
    if (m_dropDown == nil) {
        
        m_dropDown = [[NIDropDown alloc] init];
        m_dropDown.delegate = self;
        
//        [m_dropDown showDropDown:btnSender :&height :arr :@"up"];
        [m_dropDown showDropDown:btnSender inView:m_viewContainer :&height :arr :@"up"];
        
    }else{
        
        if (m_dropDown.btnSender == btnSender) {
            
            [m_dropDown hideDropDown:btnSender];
            m_dropDown = nil;
        }else{
            [m_dropDown hideDropDown:m_dropDown.btnSender];
            m_dropDown = nil;
            
            m_dropDown = [[NIDropDown alloc] init];
            m_dropDown.delegate = self;
            
            
//            [m_dropDown showDropDown:btnSender :&height :arr :@"up"];
            
            [m_dropDown showDropDown:btnSender inView:m_viewContainer :&height :arr :@"up"];
            
            
        }
        
    }
    
    
    
}
-(void)niDropDownDelegateMethod:(int)selectedRow :(NIDropDown *)sender{
    
    if (m_dropDown.btnSender == m_btnCountry) {
        
        m_CountryIndex = selectedRow;
        
    }else if (m_dropDown.btnSender == m_btnRegion){
        
        m_RegionIndex = selectedRow;
        
    }else if (m_dropDown.btnSender == m_btnLocation){
        
        m_LocaitonIndex = selectedRow;
        
    }
    m_dropDown = nil;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    m_currentEditView = textField;
    
}

-(void)keyboardWillHide:(NSNotification *)_notification
{
    [m_scrollView setContentSize:CGSizeMake(m_viewContainer.frame.size.width, m_viewContainer.frame.size.height)];
    [m_scrollView setContentOffset:m_prevScrollPoint animated:YES];
    
}


-(void)keyboardWillShow:(NSNotification *)_notification
{
    

    m_prevScrollPoint = m_scrollView.contentOffset;
    
    CGRect aRect = self.view.frame;
    
    aRect.origin.x = 0;
    
    CGSize keyboardSize = [[[_notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    float keyboardHeight = keyboardSize.height;
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            keyboardHeight = keyboardSize.width;
        }
        
    }
    
    aRect.size.height -= keyboardHeight;
    
    
    CGPoint origin = [m_currentEditView.superview convertPoint:m_currentEditView.frame.origin toView:self.view];
    
    
    origin.y +=m_prevScrollPoint.y;
//    origin.y +=m_currentEditView.frame.size.height;
    
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        
        [m_scrollView setContentSize:CGSizeZero];
        CGPoint scrollPoint = CGPointMake(0.0,origin.y - aRect.size.height);
        [m_scrollView setContentOffset:scrollPoint animated:YES];
        
        
    }
    
    
    
}

@end
