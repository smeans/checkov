//
//  iPadCheckovViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "iPadCheckovViewController.h"
#import "iPadViewController.h"

@interface iPadCheckovViewController ()

@end

@implementation iPadCheckovViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)deleteClicked:(id)sender
{
    if ([deleteButton.titleLabel.text isEqualToString:@"Confirm"]) {
        UITableView *tv = (UITableView *)self.checkovCell.tableView;
        
        [self.viewController deleteCheckoff:[tv indexPathForCell:self.checkovCell].row];
    } else {
        [deleteButton setTitle:@"Confirm" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
