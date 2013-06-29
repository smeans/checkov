//
//  CheckoffItem.h
//  checkov
//
//  Created by Scott Means on 6/29/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BooleanCalendar.h"

@interface CheckovItem : NSObject

@property (strong) NSString *name;
@property (strong) UIColor *color;
@property (strong) BooleanCalendar *calendar;
@property (readonly) bool isDefault;

@end

#define DEFAULT_CHECKOV     @"[new checkoff]"
#define CHECKOV_CHANGED     @"checkovChanged"