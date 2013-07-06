//
//  ViewController.h
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoffCalendarView.h"
#import "BooleanCalendar.h"
#import "CheckovItem.h"

@interface ViewController : UIViewController <CalendarViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *portraitList;
    IBOutlet UITableView *landscapeList;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *minusButton;
    IBOutlet UIButton *plusButton;
    IBOutlet UILabel *dateLabel;
    
    IBOutlet CheckoffCalendarView *calendarView;
}

@property (assign) int focusItemIndex;
@property (readonly) NSMutableArray *checkoffs;
@property (readonly) CheckovItem *focusItem;

- (void)deleteCheckoff:(int)checkoff;
- (IBAction)upClicked:(id)sender;
- (IBAction)minusClicked:(id)sender;
- (IBAction)plusClicked:(id)sender;

@end
