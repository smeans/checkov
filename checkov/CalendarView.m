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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.focusDate = [NSDate date];
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
    
    NSDate *dd = [self.calendar minMonthDay:self.focusDate];
    NSDateComponents *dc = [NSDateComponents new];
    dc.day = 1;
    
    for (int w = 0; w < wc; w++) {
        CGRect dr = CGRectMake(0, w*dh, dw, dh);
        
        for (int d = 0; d < 7; d++) {
            [self drawDay:dd inRect:dr];
            dr = CGRectOffset(dr, dw, 0);
            dd = [self.calendar addDays:1 toDate:dd];
        }
    }
}

#pragma mark Display-specific subclassable methods
- (CGFloat)dayHeightForWidth:(CGFloat)width
{
    return width;
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

@end
