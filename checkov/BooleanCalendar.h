//
//  BooleanCalendar.h
//  checkov
//
//  Created by Scott Means on 6/26/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooleanCalendar : NSObject

- (bool)getDate:(NSDate *)date;
- (void)setDate:(NSDate *)date;
- (void)resetDate:(NSDate *)date;

- (void)exportToCSV:(NSString *)path;

@property (readonly) NSDate *firstDate;
@property (readonly) NSDate *lastDate;
@property (readonly) int dateCount;

@end
