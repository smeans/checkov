//
//  iPhoneViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "iPhoneViewController.h"
#import "CheckovViewController.h"

@interface iPhoneViewController ()

@end

@implementation iPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)calendarView:(CalendarView *)calendar focusDateChanged:(NSDate *)date
{
    NSDateComponents *dc = [calendar.calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    if (calendar.viewType == month) {
        NSDateFormatter *df = [NSDateFormatter new];
        NSArray *ms = [df shortMonthSymbols];
        
        dateLabel.text = [NSString stringWithFormat:@"%@ - %d", [ms objectAtIndex:dc.month-1], dc.year];
    } else {
        dateLabel.text = [NSString stringWithFormat:@"%d", dc.year];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CheckovViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkovDetail"];
    
    CheckovTableViewCell *ctvc = (CheckovTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    cvc.checkovCell = ctvc;
    cvc.viewController = self;
    
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
