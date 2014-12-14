//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@end

@implementation NIDropDown
    @synthesize table;
    @synthesize btnSender;
    @synthesize list;
    @synthesize delegate;
    @synthesize animationDirection;
    @synthesize m_containerView;

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSString *)direction {
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-1, -1);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-1, 1);
        }
        
        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8;
//        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        
        if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
            [table setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
            [table setLayoutMargins:UIEdgeInsetsZero];
        }

        table.delegate = self;
        table.dataSource = self;
//        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}


- (id)showDropDown:(UIButton *)b inView:(UIView*)containerView :(CGFloat *)height :(NSArray *)arr :(NSString *)direction {
    
    
    btnSender = b;
    animationDirection = direction;
    m_containerView = containerView;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];


        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        
        if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
            [table setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
            [table setLayoutMargins:UIEdgeInsetsZero];
        }
        
        table.delegate = self;
        table.dataSource = self;
        //        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        
        
        
        CGPoint p = [btnSender.superview convertPoint:btnSender.frame.origin toView:containerView];
        
        
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(p.x, p.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-1, -1);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(p.x, p.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-1, 1);
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(p.x, p.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(p.x, p.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);

        [UIView commitAnimations];
        self.layer.masksToBounds = NO;
        //        self.layer.cornerRadius = 8;
        //        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;

        [self addSubview:table];
        [containerView addSubview:self];
    }
    return self;
}



-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    UIView* containerView;
    
    if (m_containerView) {
        containerView = m_containerView;
    }else{
        
        containerView = b.superview;
        
    }
    
    CGPoint p = [btnSender.superview convertPoint:btnSender.frame.origin toView:containerView];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(p.x, p.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(p.x, p.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* lblTitle ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        lblTitle = [[UILabel alloc] init];
        [lblTitle setTag:100];
        [lblTitle setFont:[UIFont fontWithName:kDefaultFontName size:13.0f]];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setTextColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]];
        
        [lblTitle setFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        [cell.contentView addSubview:lblTitle];
        
    }else{
        
        lblTitle = (UILabel*)[cell.contentView viewWithTag:100];
        
    }

    [lblTitle setText:[list objectAtIndex:indexPath.row]];
    
    
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:[list objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    imgView.image = c.imageView.image;
    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
    imgView.frame = CGRectMake(5, 5, 25, 25);
    [btnSender addSubview:imgView];
    [self myDelegate : (int)indexPath.row];
}

- (void) myDelegate : (int)selectedRow {
    
    [self.delegate niDropDownDelegateMethod:selectedRow :self];
    
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
