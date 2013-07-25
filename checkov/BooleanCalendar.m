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


- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _years = [decoder decodeObjectForKey:@"years"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_years forKey:@"years"];
}

- (bool)getDate:(NSDate *)date
{
    if (![self yearExists:date]) {
        return false;
    }
    
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
    
    int i = 0;
    while (i < d.length && !pb[i]) {
        i++;
    }
    
    [self compactYears];
}

- (NSMutableDictionary *)years
{
    return _years ? _years : (_years = [NSMutableDictionary new]);
}

- (bool)yearExists:(NSDate *)date
{
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
    
    NSString *yk = [NSString stringWithFormat:@"%d", dc.year];
    return (bool)[self.years objectForKey:yk];
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

- (void)compactYears
{
    NSArray *ka = _years.allKeys;
    
    for (NSString *key in ka) {
        NSMutableData *data = [_years objectForKey:key];
        
        int i = 0;
        const unsigned char *pb = data.bytes;
        while (i < data.length && !pb[i]) {
            i++;
        }
        
        if (i >= data.length) {
            [_years removeObjectForKey:key];
        }
    }
}

#pragma mark statistics
- (NSDate *)firstDate
{
    NSString *ly;
    
    for (NSString *year in _years.keyEnumerator) {
        if (!ly || [year compare:ly] < 0) {
            ly = year;
        }
    }
    
    NSDateComponents *dc = [NSDateComponents new];
    dc.year = [ly intValue];
    
    NSMutableData *data = [_years objectForKey:ly];
    const unsigned char *pb = [data bytes];
    
    int i = 0;
    while (i < data.length && !pb[i]) {
        i++;
    }
    dc.day = i * 8;
    
    unsigned char b = pb[i];
    while (!(b & 0x01)) {
        dc.day++;
        b >>= 1;
    }
    
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

- (NSDate *)lastDate
{
    NSString *ly;
    
    for (NSString *year in _years.keyEnumerator) {
        if (!ly || [year compare:ly] > 0) {
            ly = year;
        }
    }
    
    NSDateComponents *dc = [NSDateComponents new];
    dc.year = [ly intValue];
    
    NSMutableData *data = [_years objectForKey:ly];
    const unsigned char *pb = [data bytes];
    
    int i = data.length-1;
    while (i >= 0 && !pb[i]) {
        i--;
    }
    dc.day = (i + 1) * 8 - 1;
    
    unsigned char b = pb[i];
    while (!(b & 0x80)) {
        dc.day--;
        b <<= 1;
    }
    
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

@end
