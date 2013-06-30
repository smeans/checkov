//
//  CheckoffItem.m
//  checkov
//
//  Created by Scott Means on 6/29/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "CheckovItem.h"

@implementation CheckovItem

@synthesize name=_name;
@synthesize color=_color;
@synthesize calendar=_calendar;

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        _name = [decoder decodeObjectForKey:@"name"];
        _color = [decoder decodeObjectForKey:@"color"];
        _calendar = [decoder decodeObjectForKey:@"calendar"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_color forKey:@"color"];
    [encoder encodeObject:_calendar forKey:@"calendar"];
}

- (bool)isDefault
{
    return [_name isEqualToString:DEFAULT_CHECKOV];
}
@end

