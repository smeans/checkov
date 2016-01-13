//
//  UICheckovTableViewCell.m
//  checkov
//
//  Created by Scott Means on 6/29/13.
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

#import "CheckovTableViewCell.h"
#import "EllipseView.h"

@interface CheckovTableViewCell ()

@property (strong) UITextField *text;
@property (strong) UITapGestureRecognizer *tgr;

@end

@implementation CheckovTableViewCell

@synthesize item=_item;
@synthesize localTableView=_localTableView;
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
        [_localTableView.delegate tableView:_localTableView accessoryButtonTappedForRowWithIndexPath:[_localTableView indexPathForCell:self]];
    } else {
        CheckovTableViewCell *tvc = (CheckovTableViewCell *)[_localTableView cellForRowAtIndexPath:[_localTableView indexPathForSelectedRow]];
        
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
    CheckovTableViewCell *tvc = (CheckovTableViewCell *)[_localTableView cellForRowAtIndexPath:[_localTableView indexPathForSelectedRow]];
    
    if (t.view == self.accessoryView && !_item.isDefault) {
        if (t.tapCount == 1) {
            [_localTableView.delegate tableView:_localTableView accessoryButtonTappedForRowWithIndexPath:[_localTableView indexPathForCell:self]];
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
    
    [_localTableView scrollToRowAtIndexPath:[_localTableView indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
