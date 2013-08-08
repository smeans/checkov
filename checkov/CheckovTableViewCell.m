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
@property (strong) UITapGestureRecognizer *tgr;

@end

@implementation CheckovTableViewCell

@synthesize item=_item;
@synthesize tableView=_tableView;
@synthesize text=_text;
@synthesize tgr=_tgr;

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
    UILongPressGestureRecognizer *gr = (UILongPressGestureRecognizer *)sender;
    
    if (CGRectContainsPoint(self.accessoryView.bounds, [gr locationInView:self.accessoryView])
            && !_item.isDefault) {
        [_tableView.delegate tableView:_tableView accessoryButtonTappedForRowWithIndexPath:[_tableView indexPathForCell:self]];
    } else {
        CheckovTableViewCell *tvc = (CheckovTableViewCell *)[_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
        
        if (_item.isDefault || tvc.item == self.item) {
            [self startEditing];
        }
    }
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
    CheckovTableViewCell *tvc = (CheckovTableViewCell *)[_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    
    if (t.view == self.accessoryView && !_item.isDefault) {
        if (t.tapCount == 1) {
            [_tableView.delegate tableView:_tableView accessoryButtonTappedForRowWithIndexPath:[_tableView indexPathForCell:self]];
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
    
    [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapDetected:)];
    
    UIView *sv = (UIView *)[self.window.subviews objectAtIndex:0];
    [sv addGestureRecognizer:_tgr];
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

    UIView *sv = (UIView *)[self.window.subviews objectAtIndex:0];
    [sv removeGestureRecognizer:_tgr];
}

+ (void)stopEditing
{
    [editingCell stopEditing];
}

+ (bool)isEditing
{
    return (bool)editingCell;
}

- (IBAction)editTapDetected:(id)sender
{
    UITapGestureRecognizer *tgr = (UITapGestureRecognizer *)sender;
    
    if (tgr.view != self) {
        [CheckovTableViewCell stopEditing];
    } else {
        tgr.cancelsTouchesInView = NO;
    }
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
