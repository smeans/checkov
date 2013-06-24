//
//  ViewController.m
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "ViewController.h"
#import "NSCalendar+Display.h"

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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    portraitList.hidden =
    landscapeList.hidden = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    landscapeList.hidden = UIInterfaceOrientationIsLandscape(fromInterfaceOrientation);
    portraitList.hidden = !landscapeList.hidden;
}

- (IBAction)upClicked:(id)sender
{
    
}

- (IBAction)minusClicked:(id)sender
{
    calendarView.focusDate = [calendarView.calendar addMonths:-1 toDate:calendarView.focusDate];
}

- (IBAction)plusClicked:(id)sender
{
    calendarView.focusDate = [calendarView.calendar addMonths:1 toDate:calendarView.focusDate];
}

#pragma mark CalendarView delegate
- (void)calendarView:(CalendarView *)calendar focusDateChanged:(NSDate *)date
{
    NSDateFormatter *df = [NSDateFormatter new];
    NSArray *ms = [df monthSymbols];
    
    NSDateComponents *dc = [calendar.calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    dateLabel.text = [NSString stringWithFormat:@"%@ - %d", [ms objectAtIndex:dc.month-1], dc.year];
}

@end
