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

@property (readonly) NSMutableDictionary *checkoffs;
@property (readonly) BooleanCalendar *focusCalendarObj;
@end

@implementation ViewController

@synthesize focusCalendar=_focusCalendar;

@synthesize checkoffs=_checkoffs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.checkoffs.count) {
        [self.checkoffs setObject:[BooleanCalendar new] forKey:@"[name me]"];
        self.focusCalendar = @"[name me]";
    }
    
    calendarView.delegate = self;
    calendarView.focusDate = [NSDate date];
    calendarView.focusCalendar = self.focusCalendarObj;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return landscapeList ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (landscapeList) {
        portraitList.hidden =
        landscapeList.hidden = NO;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (landscapeList) {
        landscapeList.hidden = UIInterfaceOrientationIsLandscape(fromInterfaceOrientation);
        portraitList.hidden = !landscapeList.hidden;
    }
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

- (NSMutableDictionary *)checkoffs
{
    return _checkoffs ? _checkoffs : (_checkoffs = [NSMutableDictionary new]);
}

- (BooleanCalendar *)focusCalendarObj
{
    return _focusCalendar ? [self.checkoffs objectForKey:_focusCalendar] : nil;
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
