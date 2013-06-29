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
        self.accessoryView = [[EllipseView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height,  self.bounds.size.height)];
    }
    
    return self;
}

- (IBAction)longPress:(id)sender
{
    [self startEditing];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self addGestureRecognizer:gr];
    
    EllipseView *ev = (EllipseView *)self.accessoryView;
    ev.ellipseColor = self.item.color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    
    if ((t.tapCount == 1 && _item.isDefault) || t.tapCount == 2) {
        [self startEditing];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)startEditing
{
    if (_text) {
        return;
    }
    
    _text = [[UITextField alloc] initWithFrame:self.textLabel.frame];
    _text.text = self.textLabel.text;
    _text.font = self.textLabel.font;
    _text.clearsOnBeginEditing = _item.isDefault;
    [_text setReturnKeyType:UIReturnKeyDone];
    
    _text.delegate = self;
    
    [self addSubview:_text];
    self.textLabel.hidden = YES;
    [_text becomeFirstResponder];
}

- (void)stopEditing
{
    if (!_text) {
        return;
    }
    
    _item.name =
    self.textLabel.text = _text.text;

    [[NSNotificationCenter defaultCenter] postNotificationName:CHECKOV_CHANGED object:self.item];
    
    [_text removeFromSuperview];
    _text = nil;
    
    self.textLabel.hidden = NO;
    
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
