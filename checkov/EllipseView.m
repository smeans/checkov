//
//  EllipseView.m
//  checkov
//
//  Created by Scott Means on 6/29/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "EllipseView.h"

@implementation EllipseView

@synthesize ellipseColor=_ellipseColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float h = rect.size.width*.7;
    
    CGRect r = CGRectMake(0, rect.size.height/2-h/2, rect.size.width, h);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(c, _ellipseColor.CGColor);
    CGContextFillEllipseInRect(c, r);
}

- (UIColor *)ellipseColor
{
    return _ellipseColor;
}

- (void)setEllipseColor:(UIColor *)ellipseColor
{
    _ellipseColor = ellipseColor;
    
    [self setNeedsDisplay];
}

@end
