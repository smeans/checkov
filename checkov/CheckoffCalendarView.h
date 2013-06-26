//
//  CheckoffCalendarView.h
//  checkov
//
//  Created by Scott Means on 6/26/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "CalendarView.h"
#import "BooleanCalendar.h"
@interface CheckoffCalendarView : CalendarView

@property (strong) BooleanCalendar *focusCalendar;
@property (strong) UIColor *trueColor;

@end

#define PB(b) ((float)(b)/255.0)

#define DEAD_COLOR  [UIColor colorWithWhite:.8 alpha:.8]
#define FALSE_COLOR [UIColor colorWithRed:PB(186) green:PB(234) blue:PB(255) alpha:.8]
#define TRUE_COLOR [UIColor colorWithRed:PB(255) green:PB(115) blue:PB(26) alpha:.8]
#define TEXT_COLOR  [UIColor blackColor]

