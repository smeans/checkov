//
//  CalendarView.m
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
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

- (void)drawRect:(CGRect)rect
{
    switch (_viewType) {
        case month: {
            [self drawMonth:rect];
        } break;
            
        case year: {
            
        } break;
            
        case decade: {
            
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

- (NSDate *)hittestDate:(CGPoint)pt
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

- (void)pageLeft
{
    self.focusDate = [self.calendar addMonths:-1 toDate:self.focusDate];
}

- (void)pageRight
{
    self.focusDate = [self.calendar addMonths:1 toDate:self.focusDate];
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
    NSDate *td = [self hittestDate:pt];
    
    if (td) {
        [self dayTouched:td];
    }
}

- (bool)isDead:(NSDate *)date
{
    NSDateComponents *dcd = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    NSDateComponents *fcd = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self.focusDate];
    
    return dcd.year != fcd.year || dcd.month != fcd.month;
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

@end
