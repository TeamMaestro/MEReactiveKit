//
//  MERButton.h
//  MEReactiveKit
//
//  Created by William Towe on 11/17/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface MERButton : UIControl

@property (assign,nonatomic) UIControlContentHorizontalAlignment imageHorizontalAlignment;
@property (assign,nonatomic) UIControlContentVerticalAlignment imageVerticalAlignment;

@property (assign,nonatomic) UIControlContentHorizontalAlignment titleHorizontalAlignment;
@property (assign,nonatomic) UIControlContentVerticalAlignment titleVerticalAlignment;

@property (assign,nonatomic) BOOL adjustsImageWhenHighlighted;
@property (assign,nonatomic) BOOL adjustsImageWhenDisabled;

@property (assign,nonatomic) UIEdgeInsets contentEdgeInsets UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) UIEdgeInsets titleEdgeInsets UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) UIEdgeInsets imageEdgeInsets UI_APPEARANCE_SELECTOR;

@property (strong,nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;

- (NSString *)titleForState:(UIControlState)state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIColor *)titleColorForState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIImage *)imageForState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIImage *)backgroundImageForState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@end

@class RACCommand;

@interface MERButton (RACCommandSupport)

@property (nonatomic, strong) RACCommand *rac_command;

@end
