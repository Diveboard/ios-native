//
//  UIButton+VTCustomFont.m
//  ValetTAB
//
//  Created by Abid Khan on 09/01/14.
//  Copyright (c) 2013 ValetTAB LLC. All rights reserved.
//

#import "UIButton+VTCustomFont.h"

@implementation UIButton (VTCustomFont)

- (NSString *)fontName
{
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName
{
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end
