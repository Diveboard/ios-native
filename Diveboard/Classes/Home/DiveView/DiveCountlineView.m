//
//  DiveCountlineView.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/26/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DiveCountlineView.h"

#define rulerPixelWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 7.0f : 3.5f)
//#define rulerPixelWidth     3.5f
#define rulerPixelHeight    rulerPixelWidth * 4.7

@interface DiveCountlineView()
{
    CGSize   winSize;
    float    defaultRulerY;
    CGRect   rulersRect;
    int      rulerCount;
    float    distanceOFrulerVSruler;
    NSMutableArray *rulerPixels;
}

@end

@implementation DiveCountlineView

- (id)initWithFrame:(CGRect)frame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DiveCountlineView" owner:self options:Nil] objectAtIndex:0];
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30.0f)];
    } else {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DiveCountlineView-ipad" owner:self options:Nil] objectAtIndex:0];
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 60.0f)];
    }

    
    if (self) {
        
//        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30.0f)];

        self.backgroundColor = [UIColor clearColor];
        
        winSize = [UIScreen mainScreen].bounds.size;
        defaultRulerY = self.frame.size.height * 0.35;
        
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

- (void) setMaxValue:(int)value
{
    maxValue = value;
    [_lblMaxDiveNumb setText:[NSString stringWithFormat:@"%d", maxValue]];
}


- (void) setLayoutWithPortrate
{
    rulerCount = 25;
    [self setLayoutRuler];
}

- (void) setLayoutWithLandscape
{
    rulerCount = 45;
    [self setLayoutRuler];
}

- (void) setLayoutRuler
{
    if (rulerPixels) {
        [rulerPixels removeAllObjects];
        rulerPixels = nil;
    }
    rulerPixels = [[NSMutableArray alloc] init];
    
    float dt = 2.37f;
    float ox;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        ox = CGRectGetMaxX(_lblCurrentDiveNum.frame);
    } else {
        ox = CGRectGetMaxX(_lblCurrentDiveNum.frame) + rulerPixelWidth * 5;
    }
    

    if (maxValue < rulerCount)
    {
        ox += rulerPixelWidth * dt * (rulerCount - maxValue) / 2;
        rulerCount = maxValue;
    }
    
    for (int i = 0; i < rulerCount; i ++) {
        CGRect rect = CGRectMake(ox + rulerPixelWidth * dt * i,
                                 defaultRulerY,
                                 rulerPixelWidth, rulerPixelHeight);
        UIView *viewRuler = [[UIView alloc] initWithFrame:rect];
        viewRuler.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        [self addSubview:viewRuler];
        [rulerPixels addObject:viewRuler];
    }
    rulersRect = CGRectMake(ox, 0, rulerPixelWidth * dt * rulerCount - rulerPixelWidth * (dt - 1),
                            self.frame.size.height);

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    [self rulerTouch:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    [self rulerTouch:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    [self rulerTouch:point];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(diveCountlineView:Number:)]) {
            [self.delegate diveCountlineView:self Number:currentValue];
        }
    }
}

- (void) rulerTouch:(CGPoint)point
{
    if (CGRectContainsPoint(rulersRect, point)) {
        int index = 0;
        for (UIView *ruler in rulerPixels) {
            index++;
            CGRect rulerRect = CGRectInset(ruler.frame, -rulerPixelWidth * 1.37 * 0.5, -rulerPixelHeight * 0.6);
            //            CGRectMake(ruler.frame.origin.x, 0, distanceOFrulerVSruler , self.frame.size.height);
            [ruler setFrame:CGRectMake(ruler.frame.origin.x, defaultRulerY, ruler.frame.size.width, ruler.frame.size.height)];
            [ruler setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
            
            if (CGRectContainsPoint(rulerRect, point)) {
                [ruler setFrame:CGRectMake(ruler.frame.origin.x, 5, ruler.frame.size.width, ruler.frame.size.height)];
                [ruler setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
                
                if (maxValue > rulerCount) {
                    float dt = (rulersRect.size.width + rulerPixelWidth) / maxValue;
                    float xx = point.x - rulersRect.origin.x;
                    currentValue = (xx / dt + 1);
                    if (currentValue > maxValue) currentValue = maxValue;
                } else {
                    currentValue = index;
                }
            }
        }
        [_lblCurrentDiveNum setText:[NSString stringWithFormat:@"%d", currentValue]];
    }
    
}


- (void) setCurrentValue:(int)value
{
    currentValue = value;
    
    [self setRulerToCurrentValue];
    
}

- (void) setRulerToCurrentValue
{
    if (currentValue < 0)        currentValue = 0;
    if (currentValue > maxValue) currentValue = maxValue;

    for (UIView *ruler in rulerPixels) {
        [ruler setFrame:CGRectMake(ruler.frame.origin.x, defaultRulerY, ruler.frame.size.width, ruler.frame.size.height)];
        [ruler setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    }

    if (maxValue > rulerCount) {
        float dt = rulersRect.size.width / maxValue;
        float xx = (currentValue - 1) * dt + rulerPixelWidth;
        CGPoint point = CGPointMake(rulersRect.origin.x + xx, self.frame.size.height / 2);
        for (UIView *ruler in rulerPixels) {
            CGRect rulerRect = CGRectInset(ruler.frame, -rulerPixelWidth * 1.37 * 0.5, -rulerPixelHeight * 0.6);
            if (CGRectContainsPoint(rulerRect, point)) {
                [ruler setFrame:CGRectMake(ruler.frame.origin.x, 5, ruler.frame.size.width, ruler.frame.size.height)];
                [ruler setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
            }
        }
    } else {
        
        UIView *ruler = [rulerPixels objectAtIndex:(currentValue - 1)];
        [ruler setFrame:CGRectMake(ruler.frame.origin.x, 5, ruler.frame.size.width, ruler.frame.size.height)];
        [ruler setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
    }
    
    [_lblCurrentDiveNum setText:[NSString stringWithFormat:@"%d", (currentValue)]];
}


@end
