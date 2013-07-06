//
//  CheckovViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "CheckovViewController.h"

@interface CheckovViewController ()

@end

@implementation CheckovViewController

@synthesize checkovCell=_checkovCell;
@synthesize viewController=_viewController;

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

- (IBAction)closeClicked:(id)sender
{
}

- (IBAction)deleteClicked:(id)sender
{
    UITableView *tv = (UITableView *)self.checkovCell.superview;
    
    [self.viewController deleteCheckoff:[tv indexPathForCell:self.checkovCell].row];
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
