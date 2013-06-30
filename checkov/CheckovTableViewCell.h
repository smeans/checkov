//
//  UICheckovTableViewCell.h
//  checkov
//
//  Created by Scott Means on 6/29/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckovItem.h"

@interface CheckovTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong) CheckovItem *item;

+ (void)stopEditing;
+ (bool)isEditing;

@end
