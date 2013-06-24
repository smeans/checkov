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

typedef enum _CVTypes {month, year, decade} CVTypes;

@interface CalendarView : UIView

@property (strong) id<CalendarViewDelegate> delegate;
@property (assign) CVTypes viewType;
@property (assign) NSCalendar *calendar;
@property (assign) NSDate *focusDate;

- (CGFloat)dayHeightForWidth:(CGFloat)width;
- (void)drawDay:(NSDate *)date inRect:(CGRect)rect;

@end
