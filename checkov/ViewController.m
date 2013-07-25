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
#import "CheckovViewController.h"

@interface ViewController ()

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
    
    [self loadCheckoffs];
    
    [self checkMakeBlankItem];
    
    calendarView.delegate = self;
    calendarView.focusDate = [NSDate date];
    calendarView.focusCalendar = self.focusItem.calendar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkovChanged:) name:CHECKOV_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* kbi = [notification userInfo];
    NSValue* kbf = [kbi valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect rc = [kbf CGRectValue];
    
    landscapeList.contentInset = UIEdgeInsetsMake(0, 0, rc.size.height, 0);
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    landscapeList.contentInset = UIEdgeInsetsZero;
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

- (NSString *)checkoffPath
{
    NSString *dp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [dp stringByAppendingPathComponent:@"checkoffs.ka"];
}

- (void)saveCheckoffs
{
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:self.checkoffs];
    [d writeToFile:[self checkoffPath] atomically:YES];
}

- (void)loadCheckoffs
{
    NSData *d = [NSData dataWithContentsOfFile:[self checkoffPath]];
    
    _checkoffs = [NSKeyedUnarchiver unarchiveObjectWithData:d];
}

- (void)checkovChanged:(NSNotification *)notification
{
    [self saveCheckoffs];
    
    [self checkMakeBlankItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.focusItemIndex = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"focusItem"];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:self.focusItemIndex inSection:0];
    [portraitList selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [landscapeList selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:_focusItemIndex inSection:0];
        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [landscapeList selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        } else {
            [portraitList selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
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
    calendarView.viewType = year;
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
    
    [[NSUserDefaults standardUserDefaults] setInteger:_focusItemIndex forKey:@"focusItem"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CheckovItem *)focusItem
{
    return [self.checkoffs objectAtIndex:_focusItemIndex];
}

- (UIColor *)getNextColor
{
    int nc = _checkoffs.count;
    
    CGFloat r = sinf((float)nc*2.4)/2 + .5;
    CGFloat g = sinf((float)nc*2.4+2)/2 + .5;
    CGFloat b = sinf((float)nc*2.4+4)/2 +.5;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:.8];
}

#pragma mark CalendarView delegate
- (void)calendarView:(CalendarView *)calendar focusDateChanged:(NSDate *)date
{
    NSDateComponents *dc = [calendar.calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    if (calendar.viewType == month) {
        NSDateFormatter *df = [NSDateFormatter new];
        NSArray *ms = [df monthSymbols];
        
        dateLabel.text = [NSString stringWithFormat:@"%@ - %d", [ms objectAtIndex:dc.month-1], dc.year];
    } else {
        dateLabel.text = [NSString stringWithFormat:@"%d", dc.year];
    }
}


- (UIFont *)cellFont
{
    return dateLabel.font;
}

- (void)deleteCheckoff:(int)checkoff
{
    [self.checkoffs removeObjectAtIndex:checkoff];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:checkoff inSection:0];
    [portraitList deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    [landscapeList deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self saveCheckoffs];
    
    self.focusItemIndex = MIN(self.focusItemIndex, self.checkoffs.count-1);
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
    EllipseView *ev = (EllipseView *)cell.accessoryView;
    ev.ellipseColor = item.color;
    
    return cell;
}

#pragma mark Checkov table view data delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [@"M" sizeWithFont:[self cellFont]].height;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CheckovTableViewCell stopEditing];
    
    self.focusItemIndex = indexPath.row;
}

@end
