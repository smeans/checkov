//
//  CheckovViewController.h
//  checkov
//
//  Created by Scott Means on 7/6/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EllipseView.h"
#import "CheckovTableViewCell.h"
#import "ViewController.h"

@interface CheckovViewController : UIViewController {
    IBOutlet EllipseView *ellipseView;
    IBOutlet UILabel *nameView;
}

@property (strong) CheckovTableViewCell *checkovCell;
@property (strong) ViewController *viewController;

- (IBAction)closeClicked:(id)sender;
- (IBAction)deleteClicked:(id)sender;

@end
