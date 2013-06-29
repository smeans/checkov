//
//  ViewController.m
//  checkov
//
//  Created by Scott Means on 6/24/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "ViewController.h"
#import "NSCalendar+Display.h"
#import "CheckovTableViewCell.h"

@interface ViewController ()

@property (readonly) NSMutableArray *checkoffs;
@property (readonly) CheckovItem *focusItem;

- (void)checkMakeBlankItem;
- (UIColor *)getNextColor;

@end

@implementation ViewController

@synthesize focusItemIndex=_focusItemIndex;
@synthesize focusItem=_focusItem;

@synthesize checkoffs=_checkoffs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkMakeBlankItem];
    
    self.focusItemIndex = (int)[[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"focusItem"];
    
    calendarView.delegate = self;
    calendarView.focusDate = [NSDate date];
    calendarView.focusCalendar = self.focusItem.calendar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkovChanged:) name:CHECKOV_CHANGED object:nil];
}

- (void)checkMakeBlankItem
{
    if (self.checkoffs.count && [((CheckovItem *)self.checkoffs.lastObject).name isEqualToString:DEFAULT_CHECKOV]) {
        return;
    }
    
    CheckovItem *item = [CheckovItem new];
    item.name = DEFAULT_CHECKOV;
    item.calendar = [BooleanCalendar new];
    item.color = [self getNextColor];
    [self.checkoffs addObject:item];
    
    [portraitList reloadData];
    [landscapeList reloadData];
}

- (void)checkovChanged:(NSNotification *)notification
{
    [self checkMakeBlankItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [portraitList selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [landscapeList selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionBottom];
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
    [calendarView pageLeft];
}

- (IBAction)plusClicked:(id)sender
{
    [calendarView pageRight];
}

- (NSMutableArray *)checkoffs
{
    return _checkoffs ? _checkoffs : (_checkoffs = [NSMutableArray new]);
}

- (int)focusItemIndex
{
    return _focusItemIndex;
}

- (void)setFocusItemIndex:(int)focusItemIndex
{
    _focusItemIndex = focusItemIndex;
    
    calendarView.focusCalendar = self.focusItem.calendar;
    calendarView.trueColor = self.focusItem.color;
    
    [[NSUbiquitousKeyValueStore defaultStore] setLongLong:_focusItemIndex forKey:@"focusItem"];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}
- (CheckovItem *)focusItem
{
    return [self.checkoffs objectAtIndex:_focusItemIndex];
}

- (UIColor *)getNextColor
{
    int nc = (int)[[NSUbiquitousKeyValueStore defaultStore] longLongForKey:@"nextColor"];
    NSLog(@"%d", nc);
    
    CGFloat r = sinf((float)nc*1.666)/2 + .5;
    CGFloat g = sinf((float)nc*2.666+2)/2 + .5;
    CGFloat b = sinf((float)nc*3.666+4)/2 +.5;
    
    [[NSUbiquitousKeyValueStore defaultStore] setLongLong:nc+1 forKey:@"nextColor"];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:.8];
}

#pragma mark CalendarView delegate
- (void)calendarView:(CalendarView *)calendar focusDateChanged:(NSDate *)date
{
    NSDateFormatter *df = [NSDateFormatter new];
    NSArray *ms = [df monthSymbols];
    
    NSDateComponents *dc = [calendar.calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    dateLabel.text = [NSString stringWithFormat:@"%@ - %d", [ms objectAtIndex:dc.month-1], dc.year];
}

- (UIFont *)cellFont
{
    return dateLabel.font;
}

#pragma mark Checkov table view data delegate
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _checkoffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CheckovTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckovCell"];
                             
    if (!cell) {
        cell = [[CheckovTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckovCell"];
        cell.textLabel.font = [self cellFont];
    }
    
    CheckovItem *item = [_checkoffs objectAtIndex:indexPath.row];
    
    cell.item = item;
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark Checkov table view data delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [@"M" sizeWithFont:[self cellFont]].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.focusItemIndex = indexPath.row;
}

@end
