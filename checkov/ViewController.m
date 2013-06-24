//
//  ViewController.m
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    calendarView.delegate = self;
    calendarView.focusDate = [NSDate date];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CalendarView delegate
- (void)calendarView:(CalendarView *)calendar focusDateChanged:(NSDate *)date
{
    NSDateFormatter *df = [NSDateFormatter new];
    NSArray *ms = [df monthSymbols];
    
    NSDateComponents *dc = [calendar.calendar components:NSMonthCalendarUnit fromDate:date];
    
    dateLabel.text = [ms objectAtIndex:dc.month-1];
}

@end
