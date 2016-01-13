//
//  NSCalendar+Display.m
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

#import "NSCalendar+Display.h"

@implementation NSCalendar (Display)

- (NSDate *)firstOfYear:(NSDate *)date
{
    NSDateComponents *dc = [self components:NSEraCalendarUnit | NSYearCalendarUnit fromDate:date];
    dc.month = 1;
    dc.day = 1;
    
    return [self dateFromComponents:dc];
}
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

- (NSDate *)addYears:(int)years toDate:(NSDate *)date
{
    NSDateComponents *dc = [NSDateComponents new];
    dc.year = years;
    
    return [self dateByAddingComponents:dc toDate:date options:0];
}
@end
