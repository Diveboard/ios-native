//
//  DiveEditShopViewController.m
//  Diveboard
//
//  Created by Vladimir Popov on 9/17/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveEditShopViewController.h"
#import "DiveInformation.h"
#import "MKMapView+ZoomLevel.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DrawerMenuViewController.h"
@interface DiveEditShopViewController ()
{
    DiveInformation* m_DiveInformation;
    DiveEditShopState m_editShopState;
    NSMutableArray* m_arrShop;
    NSMutableArray* m_arrAnnotations;
    CGPoint m_prevScrollPoint;
    UIView* m_currentEditView;
}
@end

@implementation DiveEditShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDiveData:(DiveInformation *)diveInfo
{
    NSString *nibFilename;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        nibFilename = @"DiveEditShopViewController";
    } else {
        nibFilename = @"DiveEditShopViewController-ipad";
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (![m_DiveInformation.diveShop.ID isEqualToString:@""]) {
            
            
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
    m_arrShop = [[NSMutableArray alloc] init];
    m_arrAnnotations = [[NSMutableArray alloc] init];

    [m_btnGPS.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_btnGPS.layer setBorderWidth:1.0];
    
    
    [m_viewZoomCtrl.layer setBorderColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1.0].CGColor];
    [m_viewZoomCtrl.layer setBorderWidth:1.0];
 
    NSArray* infosubviews = [m_viewCurrentShop subviews];
    for (UIView* view in infosubviews) {
        
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
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([m_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [m_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    if (![m_DiveInformation.diveShop.ID isEqualToString:@""]) {
        
        
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
    NSDictionary *shop = [m_arrShop objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%d: %@",(int)indexPath.row+1,getStringValue([shop objectForKey:@"name"])]];
    [cell.detailTextLabel setText:getStringValue([shop objectForKey:@"cname"])];
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
    NSDictionary *shopData = [m_arrShop objectAtIndex:indexPath.row];

    m_DiveInformation.diveShop = [[DiveShop alloc] initWithDictionary:shopData];
    [DrawerMenuViewController sharedMenu].isEditedDive = YES;
    [self setAssignState];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrShop.count;
}
#pragma mark MKMapView Delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    if (m_txtSearch.text.length < 3) {
        
        
        [self searchShopByLocation];
        
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* ShopMapAnnotationIdentifier = @"ShopAnnotationIdentifier";
    
    MKAnnotationView* pinView =
    (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ShopMapAnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:ShopMapAnnotationIdentifier];
        
        [pinView setImage:[UIImage imageNamed:@"marker.png"]];
        
        pinView.canShowCallout = YES;
    }
    return pinView;
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    
    
    if (m_editShopState == DiveEditShopStateSearch) {
        
        MKPointAnnotation *annotation = view.annotation;
        int index = (int)[m_arrAnnotations indexOfObject:annotation];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [m_tableView scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:YES];
        
        
        
    }
    
}



- (void) setAssignState{
    
    m_editShopState = DiveEditShopStateAssign;
    
    [m_mapViewShop removeAnnotations:m_mapViewShop.annotations];

    
    [m_viewCurrentShop setHidden:NO];
    [m_viewShopSearch setHidden:YES];
    
    if (m_DiveInformation.diveShop) {
        
        m_lblCurrentName.text = m_DiveInformation.diveShop.name;
        
        if (([m_DiveInformation.diveShop.lat floatValue] == 0) && ([m_DiveInformation.diveShop.lng floatValue] == 0)) {
            // coordinate value is empty
            m_lblCurrentGPS.text = @"";
            
        }
        else {
            // coordinate value is exist
            m_lblCurrentGPS.text = [NSString stringWithFormat:@"%.4f°N,  %.4f°E", [m_DiveInformation.diveShop.lat floatValue], [m_DiveInformation.diveShop.lng floatValue]];
        }
        
        ;
        
        CLLocationCoordinate2D spotLocation;
        spotLocation = CLLocationCoordinate2DMake([m_DiveInformation.diveShop.lat doubleValue], [m_DiveInformation.diveShop.lng doubleValue]);
        
        [m_mapViewShop removeAnnotations:m_mapViewShop.annotations];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setTitle:m_DiveInformation.diveShop.name];
        [annotation setCoordinate:spotLocation];
        [m_mapViewShop addAnnotation:annotation];
        
        [m_mapViewShop setCenterCoordinate:spotLocation zoomLevel:10 animated:NO];
        
        
    }
    
    [self.view endEditing:YES];
    
}

- (void) setSearchState{
    
    m_DiveInformation.diveShop = [[DiveShop alloc] initWithDictionary:nil];
    m_editShopState = DiveEditShopStateSearch;
    [m_mapViewShop removeAnnotations:m_mapViewShop.annotations];

    [m_viewShopSearch setHidden:NO];
    [m_viewCurrentShop setHidden:YES];
    [self.view endEditing:YES];
    
    [self searchShopByLocation];
    
}

#pragma mark - Search Shop

-(void) searchShopByLocation{
    
    if (m_editShopState == DiveEditShopStateAssign) {
        return;
    }
    
    CLLocationCoordinate2D SWCoordinate = [m_mapViewShop convertPoint:CGPointMake(0, m_mapViewShop.frame.size.height) toCoordinateFromView:m_mapViewShop];
    
    CLLocationCoordinate2D NECoordinate = [m_mapViewShop convertPoint:CGPointMake(m_mapViewShop.frame.size.width, 0) toCoordinateFromView:m_mapViewShop];
    
    
    
    NSDictionary *params = @{@"lat": [NSNumber numberWithDouble:m_mapViewShop.centerCoordinate.latitude],
                             @"lng": [NSNumber numberWithDouble:m_mapViewShop.centerCoordinate.longitude],
                             @"latSW":[NSNumber numberWithDouble:SWCoordinate.latitude],
                             @"lngSW":[NSNumber numberWithDouble:SWCoordinate.longitude],
                             @"latNE":[NSNumber numberWithDouble:NECoordinate.latitude],
                             @"lngNE":[NSNumber numberWithDouble:NECoordinate.longitude],
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };
    
    
    [self searchShop:params];
    
}


- (void) searchShop:(NSDictionary*) params
{
    
    [m_mapViewShop removeAnnotations:m_mapViewShop.annotations];
    [m_arrShop removeAllObjects];
    [m_arrAnnotations removeAllObjects];
    [m_tableView reloadData];
    NSString *requestURLString = [NSString stringWithFormat:@"%@/api/search_shop_text", SERVER_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        if ([[data objectForKey:@"success"] boolValue]) {
            
            [m_arrShop addObjectsFromArray:(NSArray *)[data objectForKey:@"shops"]];
            for (int i = 0 ; i < m_arrShop.count; i++) {
                
                
                NSDictionary* shop = m_arrShop[i];
                CLLocationCoordinate2D shopLocation;
                
                shopLocation = CLLocationCoordinate2DMake(getDoubleValue([shop objectForKey:@"lat"]), getDoubleValue([shop objectForKey:@"lng"]));
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setTitle:[NSString stringWithFormat:@"%d: %@",i+1,getStringValue([shop objectForKey:@"name"])]];
                [annotation setCoordinate:shopLocation];
                
                [m_mapViewShop addAnnotation:annotation];
                [m_arrAnnotations addObject:annotation];
             
                
            }
            
            [m_tableView reloadData];
            [SVProgressHUD dismiss];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)doneWithNumberPad{
    
    
    [self.view endEditing:YES];
    [self searchBarSearchButtonClicked:m_txtSearch];
}
- (void)cancelWithNumberPad{
    
    [self.view endEditing:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    NSDictionary *params = @{@"term": m_txtSearch.text,
                             @"lat": [NSNumber numberWithDouble:m_mapViewShop.centerCoordinate.latitude],
                             @"lng": [NSNumber numberWithDouble:m_mapViewShop.centerCoordinate.longitude],
                             @"apikey" : API_KEY,
                             @"auth_token" : [AppManager sharedManager].loginResult.token,
                             };
    
    [self searchShop:params];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    m_currentEditView = searchBar;
    
}

-(void)onZoomIn:(id)sender{
    
    float zoomLevel = m_mapViewShop.zoomLevel+1;
    
    [m_mapViewShop setCenterCoordinate:m_mapViewShop.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
}
-(void)onZoomOut:(id)sender{
    
    float zoomLevel = m_mapViewShop.zoomLevel-1;
    
    [m_mapViewShop setCenterCoordinate:m_mapViewShop.centerCoordinate zoomLevel:zoomLevel animated:YES];
    
}
-(void)onSetCurrentLocation:(id)sender{
    
    
    [m_mapViewShop setCenterCoordinate:[AppManager sharedManager].currentLocation.coordinate zoomLevel:10 animated:NO];
    
}
-(void)onChangeMapType:(id)sender{
    
    if (m_mapViewShop.mapType == MKMapTypeStandard) {
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_map_view.png"] forState:UIControlStateNormal];
        [m_mapViewShop setMapType:MKMapTypeSatellite];
        
    }else{
        
        [m_btnMapType setBackgroundImage:[UIImage imageNamed:@"btn_earth_view.png"] forState:UIControlStateNormal];
        [m_mapViewShop setMapType:MKMapTypeStandard];
        
    }
    
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
