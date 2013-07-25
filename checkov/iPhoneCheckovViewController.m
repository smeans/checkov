//
//  iPhoneCheckovViewController.m
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "iPhoneCheckovViewController.h"

@interface iPhoneCheckovViewController ()

@end

@implementation iPhoneCheckovViewController

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

- (IBAction)doneClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteClicked:(id)sender
{
    [super deleteClicked:sender];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
