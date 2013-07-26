//
//  CheckovViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "CheckovViewController.h"

@interface CheckovViewController ()
@property (strong) UIDocumentInteractionController *dic;
@end

@implementation CheckovViewController

@synthesize checkovCell=_checkovCell;
@synthesize viewController=_viewController;
@synthesize dic=_dic;

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

- (NSString *)exportCalendar
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fn = [NSString stringWithFormat:@"Checkov-%@-%@.csv", _checkovCell.item.name, [df stringFromDate:[NSDate date]]];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fn];
    [_checkovCell.item.calendar exportToCSV:path];
    
    return path;
}

- (IBAction)exportClicked:(id)sender
{
    NSString *path = [self exportCalendar];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    _dic = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    [_dic presentOptionsMenuFromRect:exportButton.frame inView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshUI];
}

- (CheckovTableViewCell *)checkovCell
{
    return _checkovCell;
}

- (void)refreshUI
{
    ellipseView.ellipseColor = _checkovCell.item.color;
    nameView.text = _checkovCell.item.name;
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterNoStyle;
    [df setDoesRelativeDateFormatting:YES];
    
    firstDateView.text = [df stringFromDate:_checkovCell.item.calendar.firstDate];
    lastDateView.text = [df stringFromDate:_checkovCell.item.calendar.lastDate];
    totalDaysView.text = [NSString stringWithFormat:@"%d", _checkovCell.item.calendar.dateCount];
}

- (void)setCheckovCell:(CheckovTableViewCell *)checkovCell
{
    _checkovCell = checkovCell;
    
    [self refreshUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
