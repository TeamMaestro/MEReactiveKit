//
//  MERSwitch.h
//  MEReactiveKit
//
//  Created by William Towe on 11/16/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

extern NSTimeInterval const MERSwitchAnimationDuration;

/**
 An API compatible replacement for `UISwitch`.
 */
@interface MERSwitch : UIControl

@property (assign,nonatomic,getter = isOn) BOOL on;
- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)setOn:(BOOL)on animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setOn:(BOOL)on animated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

@property (strong,nonatomic) NSString *onTitle;
@property (strong,nonatomic) NSString *offTitle;

@property (strong,nonatomic) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIImage *highlightedBackgroundImage UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIImage *switchImage UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIImage *highlightedSwitchImage UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) UIEdgeInsets switchImageEdgeInsets UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIFont *onOffFont UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *onOffTextColor UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *onOffHighlightedTextColor UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *onOffShadowColor UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) CGSize onOffShadowOffset UI_APPEARANCE_SELECTOR;

@end
