//
//  BooleanCalendar.m
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
        [self compactYears];
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
    
    [self compactYears];
}

- (void)exportToCSV:(NSString *)path
{
    NSArray *ka = [_years.allKeys sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *dc = [NSDateComponents new];
    
    NSMutableString *s = [NSMutableString new];
    
    for (NSString *year in ka) {
        dc.year = [year integerValue];
        dc.day = 0;
        
        NSMutableData *data = [_years objectForKey:year];
        const unsigned char *pb = [data bytes];
        
        for (int i = 0; i < data.length; i++) {
            unsigned char b = pb[i];
            
            if (b) {
                for (int j = 0; j < 8;j++) {
                    dc.day++;
                    b >>= 1;
                    
                    if (b & 0x01) {
                        NSDate *d = [[NSCalendar currentCalendar] dateFromComponents:dc];
                        
                        [s appendFormat:@"%@\n", [df stringFromDate:d]];
                    }
                }
            } else {
                dc.day += 8;
            }
        }
    }
    
    [s writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
    
    if (i >= data.length) {
        return nil;
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
    NSString *hy;
    
    for (NSString *year in _years.keyEnumerator) {
        if (!hy || [year compare:hy] > 0) {
            hy = year;
        }
    }
    
    NSDateComponents *dc = [NSDateComponents new];
    dc.year = [hy intValue];
    
    NSMutableData *data = [_years objectForKey:hy];
    const unsigned char *pb = [data bytes];
    
    int i = data.length-1;
    while (i >= 0 && !pb[i]) {
        i--;
    }
    
    if (i < 0) {
        return nil;
    }
    
    dc.day = (i + 1) * 8 - 1;
    
    unsigned char b = pb[i];
    while (!(b & 0x80)) {
        dc.day--;
        b <<= 1;
    }
    
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

- (int)dateCount
{
    int dc = 0;
    
    for (NSString *year in _years.keyEnumerator) {
        NSMutableData *data = [_years objectForKey:year];
        const unsigned char *pb = [data bytes];
        
        for (int i = 0; i < data.length; i++) {
            unsigned char b = pb[i];
            
            while (b) {
                if (b & 0x01) {
                    dc++;
                }
                
                b >>= 1;
            }
        }
    }
    
    return dc;
}
@end
