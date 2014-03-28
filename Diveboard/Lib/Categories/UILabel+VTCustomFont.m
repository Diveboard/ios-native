//
//  UILabel+VTCustomFont.m
//  ValetTAB
//
//  Created by Abid Khan on 09/01/14.
//  Copyright (c) 2013 ValetTAB LLC. All rights reserved.
//

#import "UILabel+VTCustomFont.h"

@implementation UILabel (VTCustomFont)

- (NSString *)fontName
{
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName
{
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
