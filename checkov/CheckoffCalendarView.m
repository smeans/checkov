//
//  CheckoffCalendarView.m
//  checkov
//
//  Created by Scott Means on 6/26/13.
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

#import "CheckoffCalendarView.h"
#import "CheckovItem.h"

@implementation CheckoffCalendarView

@synthesize focusCalendar=_focusCalendar;
@synthesize trueColor=_trueColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.trueColor = TRUE_COLOR;
    }
    
    return self;
}

- (BooleanCalendar *)focusCalendar
{
    return _focusCalendar;
}

- (void)setFocusCalendar:(BooleanCalendar *)focusCalendar
{
    _focusCalendar = focusCalendar;
    [self setNeedsDisplay];
}

- (CGFloat)dayHeightForWidth:(CGFloat)width
{
    return width*.7;
}

- (UIColor *)getDayColor:(NSDate *)date
{
    return [_focusCalendar getDate:date] ? _trueColor : [self isDead:date] ? DEAD_COLOR : FALSE_COLOR;
}

- (void)drawDay:(NSDate *)date inRect:(CGRect)rect
{
    UIColor *dfc = [self getDayColor:date];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(c, dfc.CGColor);
    CGContextFillEllipseInRect(c, rect);
    
    if (self.viewType == month) {
        rect = CGRectInset(rect, 5, 5);
        
        NSDateComponents *dc = [self.calendar components:NSDayCalendarUnit fromDate:date];
        
        NSString *s = [NSString stringWithFormat:@"%d", dc.day];
        CGFloat fs;
        CGSize ts = [@"00" sizeWithFont:[UIFont systemFontOfSize:144.0] minFontSize:8.0 actualFontSize:&fs forWidth:rect.size.width*.7 lineBreakMode:NSLineBreakByClipping];
        
        UIFont *f = [UIFont systemFontOfSize:fs];
        ts = [s sizeWithFont:f];
        
        rect = CGRectInset(rect, (rect.size.width-ts.width)/2, (rect.size.height-ts.height)/2);
        
        bool isToday = [[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle] isEqualToString:[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle]];
        
        CGContextSetFillColorWithColor(c, (isToday ? TODAY_TEXT_COLOR : TEXT_COLOR).CGColor);
        [s drawInRect:rect withFont:[UIFont systemFontOfSize:fs]];
    }
}

- (void)dayTouched:(NSDate *)date
{
    if (![self.focusCalendar getDate:date]) {
        [self.focusCalendar setDate:date];
    } else {
        [self.focusCalendar resetDate:date];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECKOV_CHANGED object:nil];
    
    [self setNeedsDisplay];
}

- (void)monthTouched:(NSDate *)date
{
    self.viewType = month;
    self.focusDate = date;
}


@end
