//
//  CheckoffCalendarView.h
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

#import "CalendarView.h"
#import "BooleanCalendar.h"
@interface CheckoffCalendarView : CalendarView

@property (strong) BooleanCalendar *focusCalendar;
@property (strong) UIColor *trueColor;

@end

#define PB(b) ((float)(b)/255.0)

#define DEAD_COLOR          [UIColor colorWithWhite:.8 alpha:.8]
#define FALSE_COLOR         [UIColor colorWithRed:PB(186) green:PB(234) blue:PB(255) alpha:.8]
#define TRUE_COLOR          [UIColor colorWithRed:PB(255) green:PB(115) blue:PB(26) alpha:.8]
#define TEXT_COLOR          [UIColor blackColor]
#define TODAY_TEXT_COLOR    [UIColor orangeColor]