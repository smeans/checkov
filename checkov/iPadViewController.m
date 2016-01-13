//
//  iPadViewController.m
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self hideDetail];
}
- (void)deleteCheckoff:(int)checkoff
{
    [super deleteCheckoff:checkoff];
    
    [self hideDetail];
}

@end
