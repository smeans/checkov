//
//  UICheckovTableViewCell.m
//  checkov
//
//  Created by Scott Means on 6/29/13.
//  Copyright (c) 2013 Scott Means. All rights reserved.
//

#import "CheckovTableViewCell.h"
#import "EllipseView.h"

@interface CheckovTableViewCell ()

@property (strong) UITextField *text;

@end

@implementation CheckovTableViewCell

@synthesize item=_item;
@synthesize text=_text;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat h = self.bounds.size.height - 5;
        
        self.accessoryView = [[EllipseView alloc] initWithFrame:CGRectMake(0, 0, h, h)];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return self;
}

- (IBAction)longPress:(id)sender
{
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self addGestureRecognizer:gr];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    UITableView *tv = (UITableView *)self.superview;
    CheckovTableViewCell *tvc = (CheckovTableViewCell *)[tv cellForRowAtIndexPath:[tv indexPathForSelectedRow]];
    
    if (t.view == self.accessoryView && !_item.isDefault) {
        if (t.tapCount == 1) {
            UITableView *tv = (UITableView *)self.superview;
            [tv.delegate tableView:tv accessoryButtonTappedForRowWithIndexPath:[tv indexPathForCell:self]];
        }
    } else if (t.tapCount == 1 && (_item.isDefault || tvc.item == self.item)) {
        [self startEditing];
    }
}

CheckovTableViewCell *editingCell;

- (void)startEditing
{
    if (_text) {
        return;
    }
    
    _text = [[UITextField alloc] initWithFrame:self.textLabel.frame];
    _text.text = self.textLabel.text;
    _text.font = self.textLabel.font;
    _text.textColor = [UIColor whiteColor];
    _text.clearsOnBeginEditing = _item.isDefault;
    [_text setReturnKeyType:UIReturnKeyDone];
    
    _text.delegate = self;
    
    [self addSubview:_text];
    self.textLabel.hidden = YES;
    [_text becomeFirstResponder];
    
    editingCell = self;
    
    UITableView *tv = (UITableView *)self.superview;
    
    [tv scrollToRowAtIndexPath:[tv indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)stopEditing
{
    if (!_text) {
        return;
    }
    
    if ([self.text.text length]) {
        _item.name =
        self.textLabel.text = _text.text;

        [[NSNotificationCenter defaultCenter] postNotificationName:CHECKOV_CHANGED object:self.item];
    }
    
    [_text removeFromSuperview];
    _text = nil;
    
    self.textLabel.hidden = NO;
    editingCell = nil;
}

+ (void)stopEditing
{
    [editingCell stopEditing];
}

+ (bool)isEditing
{
    return (bool)editingCell;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self stopEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_text resignFirstResponder];
    
    return YES;
}
@end
