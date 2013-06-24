//
//  NSCalendar+Display.m
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "NSCalendar+Display.h"

@implementation NSCalendar (Display)

- (NSDate *)firstOfMonth:(NSDate *)date
{
    NSDateComponents *dc = [self components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    dc.day = 1;
    
    return [self dateFromComponents:dc];
}

- (NSDate *)lastOfMonth:(NSDate *)date
{
    NSDateComponents *dc = [self components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    
    NSRange dim = [self rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    dc.day = dim.length;
    
    return [self dateFromComponents:dc];
}

- (NSDate *)minMonthDay:(NSDate *)date
{
    NSDate *fom = [self firstOfMonth:date];
    
    NSDateComponents *dc = [self components:NSYearForWeekOfYearCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate: fom];
    
    dc.weekday = self.firstWeekday;
    
    return [self dateFromComponents:dc];
}

- (NSDate *)maxMonthDay:(NSDate *)date
{
    NSDate *lom = [self lastOfMonth:date];
    
    NSDateComponents *dc = [self components:NSYearForWeekOfYearCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate: lom];
    
    int fw = self.firstWeekday - 1;
    int lw = (fw + 6) % 7;
    int d = dc.weekday-1;
    int cd = d < lw ? lw - d : (6-d)+(lw-1);
    dc = [NSDateComponents new];
    dc.weekday = cd;
    
    return [self dateByAddingComponents:dc toDate:lom options:0];
}

- (NSDate *)addDays:(int)days toDate:(NSDate *)date
{
    NSDateComponents *dc = [NSDateComponents new];
    dc.day = days;
    
    return [self dateByAddingComponents:dc toDate:date options:0];
}

- (NSDate *)addMonths:(int)months toDate:(NSDate *)date
{
    NSDateComponents *dc = [NSDateComponents new];
    dc.month = months;
    
    return [self dateByAddingComponents:dc toDate:date options:0];
}

@end
