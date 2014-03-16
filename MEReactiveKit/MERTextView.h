//
//  MERTextView.h
//  MEReactiveKit
//
//  Created by William Towe on 1/8/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface MERTextView : UITextView

/**
 Returns the amount to fade at the top of the receiver.
 
 The value should be between 0.0 and 1.0.
 */
@property (assign,nonatomic) CGFloat topGradientPercentage;
/**
 Returns the amount to fade at the bottom of the receiver.
 
 The value should be between 0.0 and 1.0.
 */
@property (assign,nonatomic) CGFloat bottomGradientPercentage;

/**
 Returns the placeholder assigned to the receiver.
 */
@property (strong,nonatomic) NSString *placeholder;
/**
 Returns the attributed placeholder assigned to the receiver.
 */
@property (strong,nonatomic) NSAttributedString *attributedPlaceholder;

/**
 Returns the edge insets assigned to the placeholder.
 
 The default value is `UIEdgeInsetsZero`.
 */
@property (assign,nonatomic) UIEdgeInsets placeholderEdgeInsets;
/**
 Returns the text alignment assigned to the placeholder.
 
 The default is `NSTextAlignmentCenter`.
 */
@property (assign,nonatomic) NSTextAlignment placeholderAlignment;
/**
 Returns the font assigned to the placeholder.
 
 The default is `[UIFont systemFontOfSize:17]`.
 */
@property (strong,nonatomic) UIFont *placeholderFont;
/**
 Returns the text color of the placeholder.
 
 The default value is `[UIColor blackColor]`.
 */
@property (strong,nonatomic) UIColor *placeholderTextColor;

@end
