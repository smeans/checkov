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

- (bool)isDefault
{
    return [_name isEqualToString:DEFAULT_CHECKOV];
}
@end

