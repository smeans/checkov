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

@property (readonly) NSDate *firstDate;
@property (readonly) NSDate *lastDate;

@end
