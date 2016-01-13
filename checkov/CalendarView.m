//
//  CalendarView.m
//  checkov
//
//  Created by Scott Means on 6/24/13.
//
// The MIT License (MIT)
// 
// Copyright (c) 2016 W. Scott Means
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "CalendarView.h"
#import "NSCalendar+Display.h"

@interface CalendarView ()

@end

@implementation CalendarView

@synthesize viewType = _viewType;
@synthesize calendar = _calendar;
@synthesize focusDate = _focusDate;

- (void)initCalendar
{
    self.focusDate = [NSDate date];
    
    UISwipeGestureRecognizer *sr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    sr.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:sr];
    
    sr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    sr.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:sr];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCalendar];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCalendar];
    }
    
    return self;
}

- (CVTypes)viewType
{
    return _viewType;
}

- (void)setViewType:(CVTypes)viewType
{
    _viewType = viewType;
    
    [self.delegate calendarView:self focusDateChanged:_focusDate];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    switch (_viewType) {
        case month: {
            [self drawMonth:rect];
        } break;
            
        case year: {
            [self drawYear:rect];
        } break;
    }
}

- (void)setCalendar:(NSCalendar *)calendar
{
    _calendar = calendar;
    
    [self setNeedsDisplay];
}

- (NSCalendar *)calendar
{
    return _calendar ? _calendar : [NSCalendar currentCalendar];
}

- (void)setFocusDate:(NSDate *)focusDate
{
    _focusDate = focusDate;
    [self.delegate calendarView:self focusDateChanged:_focusDate];
    
    [self setNeedsDisplay];
}

- (NSDate *)focusDate
{
    return _focusDate ? _focusDate : [NSDate date];
}

- (void)drawMonth:(CGRect)rect
{
    int wc = [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.focusDate].length;
    
    CGFloat dw = rect.size.width/7;
    CGFloat dh = [self dayHeightForWidth:dw];
    dh = MIN(rect.size.height/wc, dh);
    
    int dow = [self.calendar firstWeekday];
    
    CGRect dr = CGRectMake(0, 0, dw, dh);
    
    for (int d = 0; d < 7; d++, dow++) {
        if (dow > 7) {
            dow = 1;
        }
        
        [self drawWeekdayLabel:dow inRect:dr];

        dr = CGRectOffset(dr, dw, 0);
    }
    
    NSDate *dd = [self.calendar minMonthDay:self.focusDate];
    NSDateComponents *dc = [NSDateComponents new];
    dc.day = 1;
    
    for (int w = 1; w <= wc; w++) {
        CGRect dr = CGRectMake(0, w*dh, dw, dh);
        
        for (int d = 0; d < 7; d++) {
            [self drawDay:dd inRect:dr];
            dr = CGRectOffset(dr, dw, 0);
            dd = [self.calendar addDays:1 toDate:dd];
        }
    }
}

- (void)drawYear:(CGRect)rect
{
    NSDate *oldFocus = _focusDate;
    
    CGFloat mw = rect.size.width/4;
    CGFloat mh = [self monthHeightForWidth:mw];

    _focusDate = [self.calendar firstOfYear:self.focusDate];
    NSDateComponents *dc = [NSDateComponents new];
    dc.day = 1;
    
    NSDateFormatter *df = [NSDateFormatter new];
    NSArray *months = [df monthSymbols];
    
    CGFloat fs;
    CGSize ts = [@"M" sizeWithFont:[UIFont systemFontOfSize:144.0] minFontSize:8.0 actualFontSize:&fs forWidth:mw/7 lineBreakMode:NSLineBreakByClipping];
    UIFont *f = [UIFont systemFontOfSize:fs];
    
    for (int m = 0; m < 12; m++) {
        CGRect mr = CGRectMake(m%4*mw, m/4*mh, mw, mh);
        
        NSString *mn = [months objectAtIndex:m];
        ts = [mn sizeWithFont:f];
        
        CGRect mlr = CGRectInset(mr, mr.size.width/2-ts.width/2, 0);
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
        [mn drawInRect:mlr withFont:f];
        
        CGFloat dw = mw/7;
        CGFloat dh = [self dayHeightForWidth:dw];
        
        NSDate *dd = [self.calendar minMonthDay:_focusDate];
        int wc = [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:_focusDate].length;
        
        for (int w = 0; w < wc ; w++) {
            CGRect dr = CGRectMake(mr.origin.x, mr.origin.y+w*dh+ts.height, dw, dh);
            
            for (int d = 0; d < 7; d++) {
                if (![self isDead:dd]) {
                    [self drawDay:dd inRect:dr];
                }
                
                dr = CGRectOffset(dr, dw, 0);
                dd = [self.calendar addDays:1 toDate:dd];
            }
        }
        
        _focusDate = [self.calendar addMonths:1 toDate:_focusDate];
    }
    
    _focusDate = oldFocus;
}

- (NSDate *)hittestDay:(CGPoint)pt
{
    CGRect rect = self.bounds;
    
    int wc = [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.focusDate].length;
    
    CGFloat dw = rect.size.width/7;
    CGFloat dh = [self dayHeightForWidth:dw];
    dh = MIN(rect.size.height/wc, dh);
    
    NSDate *dd = [self.calendar minMonthDay:self.focusDate];
    
    int w = ((int)pt.y/(int)dh);
    
    if (w > wc || w < 1) {
        return nil;
    }
    
    w--;
    
    return [self.calendar addDays:(int)pt.x/(int)dw + w*7 toDate:dd];
}

- (NSDate *)hittestMonth:(CGPoint)pt
{
    CGFloat mw = self.bounds.size.width/4;
    CGFloat mh = [self monthHeightForWidth:mw];
    
    int m = (int)pt.x/(int)mw + ((int)pt.y/(int)mh*4);
    if (m >= 12) {
        return nil;
    }
    
    NSDate *dd = [self.calendar firstOfYear:_focusDate];
    return [self.calendar addMonths:m toDate:dd];
}

- (void)pageLeft
{
    switch (_viewType) {
        case month: {
            self.focusDate = [self.calendar addMonths:-1 toDate:self.focusDate];
        } break;
            
        case year: {
            self.focusDate = [self.calendar addYears:-1 toDate:self.focusDate];
        } break;
    }
}

- (void)pageRight
{
    switch (_viewType) {
        case month: {
            self.focusDate = [self.calendar addMonths:1 toDate:self.focusDate];
        } break;
            
        case year: {
            self.focusDate = [self.calendar addYears:1 toDate:self.focusDate];
        } break;
    }
}

- (void)swipedRight:(UISwipeGestureRecognizer *)recognizer
{
    [self pageLeft];
}

- (void)swipedLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self pageRight];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    CGPoint pt = [t locationInView:self];
    
    switch (_viewType) {
        case month: {
            NSDate *td = [self hittestDay:pt];
            
            if (td) {
                [self dayTouched:td];
            }
        } break;
            
        case year: {
            NSDate *td = [self hittestMonth:pt];
            
            if (td) {
                [self monthTouched:td];
            }
        } break;
    }
}

- (bool)isDate:(NSDate *)date deadTo:(NSDate *)monthDate
{
    NSDateComponents *dcd = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    NSDateComponents *fcd = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:monthDate];
    
    return dcd.year != fcd.year || dcd.month != fcd.month;
}

- (bool)isDead:(NSDate *)date
{
    return [self isDate:date deadTo:self.focusDate];
}

#pragma mark Display-specific subclassable methods
- (CGFloat)dayHeightForWidth:(CGFloat)width
{
    return width;
}

- (void)drawWeekdayLabel:(int)weekday inRect:(CGRect)rect
{
    rect = CGRectInset(rect, 5, 5);
    
    NSDateFormatter *df = [NSDateFormatter new];
    
    NSArray *wd = [df shortWeekdaySymbols];
    
    NSString *s = [wd objectAtIndex:weekday-1];
    
    CGFloat fs;
    CGSize ts = [@"MMM" sizeWithFont:[UIFont systemFontOfSize:144.0] minFontSize:8.0 actualFontSize:&fs forWidth:rect.size.width lineBreakMode:NSLineBreakByClipping];
    UIFont *f = [UIFont systemFontOfSize:fs];
    ts = [s sizeWithFont:f];
    
    rect = CGRectInset(rect, (rect.size.width-ts.width)/2, (rect.size.height-ts.height)/2);
    
    [s drawInRect:rect withFont:[UIFont systemFontOfSize:fs]];
}

- (void)drawDay:(NSDate *)date inRect:(CGRect)rect
{
    rect = CGRectInset(rect, 5, 5);
    NSDateComponents *dc = [self.calendar components:NSDayCalendarUnit fromDate:date];
    
    NSString *s = [NSString stringWithFormat:@"%d", dc.day];
    CGFloat fs;
    CGSize ts = [@"00" sizeWithFont:[UIFont systemFontOfSize:144.0] minFontSize:8.0 actualFontSize:&fs forWidth:rect.size.width lineBreakMode:NSLineBreakByClipping];
    UIFont *f = [UIFont systemFontOfSize:fs];
    ts = [s sizeWithFont:f];
    
    rect = CGRectInset(rect, (rect.size.width-ts.width)/2, (rect.size.height-ts.height)/2);
    
    [s drawInRect:rect withFont:[UIFont systemFontOfSize:fs]];
}

- (void)dayTouched:(NSDate *)date {}

- (CGFloat)monthHeightForWidth:(CGFloat)width
{
    CGFloat fs;
    CGSize ts = [@"M" sizeWithFont:[UIFont systemFontOfSize:144.0] minFontSize:8.0 actualFontSize:&fs forWidth:width/7 lineBreakMode:NSLineBreakByClipping];
    UIFont *f = [UIFont systemFontOfSize:fs];
    ts = [@"M" sizeWithFont:f];
    
    return [self dayHeightForWidth:width/7]*6 + ts.height;
}

- (void)monthTouched:(NSDate *)date {}
@end
