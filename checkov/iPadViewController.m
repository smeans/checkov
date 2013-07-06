//
//  iPadViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "iPadViewController.h"
#import "CheckovTableViewCell.h"
#import "CheckovViewController.h"

@interface iPadViewController ()

@end

@implementation iPadViewController

@synthesize checkovPopover=_checkovPopover;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideDetail
{
    [_checkovPopover dismissPopoverAnimated:YES];
    
    _checkovPopover = nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self hideDetail];
    
    CheckovViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkovDetail"];
    
    _checkovPopover = [[UIPopoverController alloc] initWithContentViewController:cvc];
    
    CheckovTableViewCell *ctvc = (CheckovTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CGRect rc = ctvc.accessoryView.frame;
    
    rc = [self.view convertRect:rc fromView:ctvc];
    
    cvc.checkovCell = ctvc;
    cvc.viewController = self;
    
    [_checkovPopover presentPopoverFromRect:rc inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)deleteCheckoff:(int)checkoff
{
    [super deleteCheckoff:checkoff];
    
    [self hideDetail];
}

@end
