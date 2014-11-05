//
//  JPTabViewController.m
//  JPTabViewController
//
//  Created by Jean-Philippe DESCAMPS on 19/03/2014.
//  Copyright (c) 2014 Jean-Philippe. All rights reserved.
//

#import "JPTabViewController.h"

@interface JPTabViewController ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIScrollView *tabScrollView;

@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, strong) NSMutableArray *tabs;

//@property (nonatomic) float statusHeight;

@property (nonatomic) float topMargin;

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation JPTabViewController

- (id)initWithControllers:(NSArray *)controllers
{
    if(self = [self init])
    {
        _controllers = controllers;
        selectedTab = NSIntegerMax;
        _delegate = nil;
        _indicatorView = [[UIView alloc] init];
    }
    return self;
}
-(void)setControllers:(NSArray *)controllers{
    _controllers = controllers;
    selectedTab = NSIntegerMax;
    _delegate = nil;
    _indicatorView = [[UIView alloc] init];
    [self loadUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _indicatorView.backgroundColor= kMainDefaultColor;
//    _statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _topMargin = 64;

    if (_controllers != nil)
    {
        [self loadUI];
    }
}

-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,
                                          _topMargin,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height-_menuHeight-_topMargin);
    
    _tabScrollView.frame = CGRectMake(0, self.view.frame.size.height - _menuHeight, self.view.frame.size.width, _menuHeight);
    
    
    tabBarTopBorder.frame = CGRectMake(0.0f, self.view.frame.size.height - _menuHeight-1, self.view.frame.size.width, 1.0f);
    
    
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
    }

//    _contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
    [_contentScrollView setContentInset:UIEdgeInsetsZero];
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_controllers count], self.view.frame.size.height - _menuHeight - _topMargin)];

    
    float contentWidth = 0;
    
    for (UIButton* tab in _tabs) {
        
        CGRect frame =  tab.frame;
        frame.origin.x = contentWidth;
        frame.origin.y = 0;
        frame.size.height = _tabScrollView.frame.size.height;
        [tab setFrame:frame];
        contentWidth +=frame.size.width;
        
    }
    [_tabScrollView setContentSize:CGSizeMake(contentWidth, _tabScrollView.frame.size.height)];
    [_tabScrollView setContentOffset:CGPointMake(0, 0)];
    [self selectTabNum:selectedTab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadUI
{
    _menuHeight = 40.0;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,0,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - _menuHeight)];
    
    [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    [_contentScrollView setShowsVerticalScrollIndicator:NO];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setDelegate:self];
    _contentScrollView.bounces = NO;
    
    _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _menuHeight, self.view.frame.size.width, _menuHeight)];
    

    [_tabScrollView setShowsHorizontalScrollIndicator:NO];
    [_tabScrollView setShowsVerticalScrollIndicator:NO];
    

    _tabs = [[NSMutableArray alloc] init];
    float contentWidth = 0;
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];

        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
        [_contentScrollView addSubview:[controller view]];
        
        // Create button
        
        UIButton *tab = [UIButton buttonWithType:UIButtonTypeCustom];

        [tab setTitle:[NSString stringWithFormat:@"    %@    ",controller.title] forState:UIControlStateNormal];
        
        tab.titleLabel.font = [UIFont fontWithName:kDefaultFontNameBold size:13.0f];
        [tab setTitleColor:[UIColor colorWithRed:44.0/255.0 green:38.0/255.0 blue:5.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [tab setTitleColor:[UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        [tab sizeToFit];
        
        
        CGRect frame =  tab.frame;
        frame.origin.x = contentWidth;
        frame.origin.y = 0;
        frame.size.height = _tabScrollView.frame.size.height;
        [tab setFrame:frame];
        contentWidth +=frame.size.width;
        
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabScrollView addSubview:tab];
        [_tabs addObject:tab];

        // Add separator
        if( i>0 )
        {
            UIImageView* separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 1, frame.size.height-24)];
            [separator setBackgroundColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0]];
            [tab addSubview:separator];
        }
    }
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    selectedTab = 0;

    CGRect frame = tab.frame ;
    frame.origin.y = _tabScrollView.frame.size.height-5;
    frame.size.height= 5;
    
    _indicatorView.frame = frame;
    
    [_indicatorView setBackgroundColor:kMainDefaultColor];
    [_tabScrollView addSubview:_indicatorView];
    [_tabScrollView setContentSize:CGSizeMake(contentWidth, _tabScrollView.frame.size.height)];
    
    
    [self.view addSubview:_contentScrollView];
    [self.view addSubview:_tabScrollView];

    tabBarTopBorder = [[UIView alloc] init];
    
    tabBarTopBorder.frame = CGRectMake(0.0f, self.view.frame.size.height - _menuHeight-1, self.view.frame.size.width, 1.0f);
    tabBarTopBorder.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
    [self.view addSubview:tabBarTopBorder];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_scrollingLocked) return;
        
    if (scrollView != _contentScrollView) return;
    
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    [self deselectAllTabs];

    
    UIButton *tab = [_tabs objectAtIndex:page];
    selectedTab = page;
    [self adjustTabScrollViewContentX:tab];

    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = tab.frame ;
        frame.origin.y = _tabScrollView.frame.size.height-5;
        frame.size.height=5;
        [_indicatorView setFrame:frame];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            if(_delegate && [_delegate respondsToSelector:@selector(currentTabHasChanged:)] )
            {
                [_delegate currentTabHasChanged:page];

            }

        }
    }];

    [tab setSelected:YES];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration
{
    m_scrollingLocked = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation
{
    m_scrollingLocked = NO;
}

- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self deselectAllTabs];
    [sender setSelected:YES];
    [self adjustTabScrollViewContentX:sender];
    
//    if(_delegate && [_delegate respondsToSelector:@selector(currentTabHasChanged:)] )
//    {
//        [_delegate currentTabHasChanged:selectedTab];
//    }
}

- (void)adjustTabScrollViewContentX:(UIButton *)sender
{
    

    if (_tabScrollView.frame.size.width > _tabScrollView.contentSize.width) return;
    
    
    CGFloat posX = sender.frame.origin.x - 60;
    
    if (posX < 0) {
        
        posX = 0;
        
    }
    if (posX > _tabScrollView.contentSize.width - _tabScrollView.frame.size.width) {
        
        posX = _tabScrollView.contentSize.width - _tabScrollView.frame.size.width;
        
    }
    
    [_tabScrollView setContentOffset:CGPointMake(posX, 0)  animated:YES];
    
}



- (void)deselectAllTabs
{
    for (UIButton *tab in _tabs)
    {
        [tab setSelected:NO];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)selectTabNum:(NSInteger)index
{
    if(index<0 || index>=[_tabs count])
    {
        return;
    }
    UIButton *tab = [_tabs objectAtIndex:index];
    [self selectTab:tab];
}

- (NSInteger)selectedTab
{
    return selectedTab;
}

@end
