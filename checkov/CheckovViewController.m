//
//  CheckovViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
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

- (IBAction)deleteClicked:(id)sender
{
    
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
