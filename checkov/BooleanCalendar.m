//
//  BooleanCalendar.m
//  checkov
//
//  Created by Scott Means on 6/26/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "BooleanCalendar.h"

@interface BooleanCalendar ()

@property (readonly)NSMutableDictionary *years;

- (NSMutableData *)getYear:(NSDate *)date;

@end

@implementation BooleanCalendar

@synthesize years=_years;

- (bool)getDate:(NSDate *)date
{
    NSUInteger doy = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
    
    NSMutableData *d = [self getYear:date];
    
    unsigned char *pb = [d mutableBytes];
    return !!(pb[doy/8] >> (doy%8) & 1);
}

- (void)setDate:(NSDate *)date
{
    NSUInteger doy = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
    
    NSMutableData *d = [self getYear:date];

    unsigned char *pb = [d mutableBytes];

    pb[doy/8] |= 1 << (doy%8);
}

- (void)resetDate:(NSDate *)date
{
    NSUInteger doy = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
    
    NSMutableData *d = [self getYear:date];
    
    unsigned char *pb = [d mutableBytes];
    
    pb[doy/8] &= ~(1 << (doy%8));
}


- (NSMutableDictionary *)years
{
    return _years ? _years : (_years = [NSMutableDictionary new]);
}

- (NSMutableData *)getYear:(NSDate *)date
{
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    
    NSString *yk = [NSString stringWithFormat:@"%d", dc.year];
    NSMutableData *d = [self.years objectForKey:yk];
    if (!d) {
        d = [NSMutableData dataWithLength:(366/8)+1];
        [self.years setObject:d forKey:yk];
    }
    
    return d;
}

@end
