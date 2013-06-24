//
//  ViewController.h
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"

@interface ViewController : UIViewController <CalendarViewDelegate> {
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *minusButton;
    IBOutlet UIButton *plusButton;
    IBOutlet UILabel *dateLabel;
    
    IBOutlet CalendarView *calendarView;
}
@end
