//
//  CalendarView.h
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
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
