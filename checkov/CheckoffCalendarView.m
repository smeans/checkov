//
//  CheckoffCalendarView.m
//  checkov
//
//  Created by Scott Means on 6/26/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "CheckoffCalendarView.h"

@implementation CheckoffCalendarView

@synthesize trueColor=_trueColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.trueColor = TRUE_COLOR;
    }
    
    return self;
}

- (CGFloat)dayHeightForWidth:(CGFloat)width
{
    return width*.7;
}

- (UIColor *)getDayColor:(NSDate *)date
{
    return [_focusCalendar getDate:date] ? TRUE_COLOR : [self isDead:date] ? DEAD_COLOR : FALSE_COLOR;
}

- (void)drawDay:(NSDate *)date inRect:(CGRect)rect
{
    UIColor *dfc = [self getDayColor:date];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(c, dfc.CGColor);
    CGContextFillEllipseInRect(c, rect);
    
    rect = CGRectInset(rect, 5, 5);

    NSDateComponents *dc = [self.calendar components:NSDayCalendarUnit fromDate:date];
    
    NSString *s = [NSString stringWithFormat:@"%d", dc.day];
    CGFloat fs;
    CGSize ts = [@"00" sizeWithFont:[UIFont systemFontOfSize:144.0] minFontSize:8.0 actualFontSize:&fs forWidth:rect.size.width*.7 lineBreakMode:NSLineBreakByClipping];
    UIFont *f = [UIFont systemFontOfSize:fs];
    ts = [s sizeWithFont:f];
    
    rect = CGRectInset(rect, (rect.size.width-ts.width)/2, (rect.size.height-ts.height)/2);
    
    CGContextSetFillColorWithColor(c, TEXT_COLOR.CGColor);
    [s drawInRect:rect withFont:[UIFont systemFontOfSize:fs]];
}

- (void)dayTouched:(NSDate *)date
{
    if (![self.focusCalendar getDate:date]) {
        [self.focusCalendar setDate:date];
    } else {
        [self.focusCalendar resetDate:date];
    }
    
    [self setNeedsDisplay];
}

@end
