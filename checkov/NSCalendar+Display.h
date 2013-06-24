//
//  NSCalendar+Display.h
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Display)

- (NSDate *)firstOfMonth:(NSDate *)date;
- (NSDate *)lastOfMonth:(NSDate *)date;

- (NSDate *)minMonthDay:(NSDate *)date;
- (NSDate *)maxMonthDay:(NSDate *)date;

- (NSDate *)addDays:(int)days toDate:(NSDate *)date;
- (NSDate *)addMonths:(int)months toDate:(NSDate *)date;

@end
