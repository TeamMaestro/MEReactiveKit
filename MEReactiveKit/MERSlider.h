//
//  MERSlider.h
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

extern NSTimeInterval const MERSliderAnimationDuration;

/**
 An API compatible replacement for `UISlider`.
 */
@interface MERSlider : UIControl

@property (assign,nonatomic,getter = isContinuous) BOOL continuous;

@property (assign,nonatomic) CGFloat value;
- (void)setValue:(CGFloat)value animated:(BOOL)animated;
- (void)setValue:(CGFloat)value animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setValue:(CGFloat)value animated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

@property (assign,nonatomic) CGFloat minimumValue;
@property (assign,nonatomic) CGFloat maximumValue;

@property (strong,nonatomic) UIImage *minimumValueImage UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIImage *maximumValueImage UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) UIEdgeInsets minimumMaximumValueImageEdgeInsets UI_APPEARANCE_SELECTOR;

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds;
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds;
- (CGRect)maximumTrackRectForBounds:(CGRect)bounds;
- (CGRect)minimumTrackRectForBounds:(CGRect)bounds;
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)trackRect value:(CGFloat)value;

- (UIImage *)maximumTrackImageForState:(UIControlState)state;
- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIImage *)minimumTrackImageForState:(UIControlState)state;
- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIImage *)thumbImageForState:(UIControlState)state;
- (void)setThumbImage:(UIImage *)thumbImage forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@end
