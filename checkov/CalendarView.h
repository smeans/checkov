//
//  CalendarView.h
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

@class CalendarView;

@protocol CalendarViewDelegate <NSObject>

- (void)calendarView:(CalendarView *)calendar focusDateChanged:(NSDate *)date;

@end

#import <UIKit/UIKit.h>

typedef enum _CVTypes {month, year} CVTypes;

@interface CalendarView : UIView

@property (strong) id<CalendarViewDelegate> delegate;
@property (assign) CVTypes viewType;
@property (strong) NSCalendar *calendar;
@property (strong) NSDate *focusDate;

- (bool)isDead:(NSDate *)date;

#pragma mark Display-specific subclassable methods
- (CGFloat)dayHeightForWidth:(CGFloat)width;
- (void)drawDay:(NSDate *)date inRect:(CGRect)rect;
- (void)dayTouched:(NSDate *)date;

- (void)pageLeft;
- (void)pageRight;

@end
