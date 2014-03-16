//
//  MERViewController.h
//  MEReactiveKit
//
//  Created by William Towe on 11/18/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, MERViewControllerNavigationItemOptions) {
    MERViewControllerNavigationItemOptionNone = 0,
    MERViewControllerNavigationItemOptionInit = 1 << 0,
    MERViewControllerNavigationItemOptionViewDidLoad = 1 << 1,
    MERViewControllerNavigationItemOptionViewWillAppear = 1 << 2,
    MERViewControllerNavigationItemOptionWillAnimateRotationToInterfaceOrientation = 1 << 3,
    MERViewControllerNavigationItemOptionDidRotateFromInterfaceOrientation = 1 << 4
};

@class RACSignal;

@interface MERViewController : UIViewController

@property (readonly,assign,nonatomic) MERViewControllerNavigationItemOptions navigationItemOptions;

- (void)configureNavigationItem;

@property (readonly,assign,nonatomic,getter = isKeyboardVisible) BOOL keyboardVisible;
@property (readonly,assign,nonatomic) CGRect keyboardFrame;
@property (readonly,nonatomic) RACSignal *keyboardWillChangeFrameSignal;
@property (readonly,nonatomic) RACSignal *keyboardDidChangeFrameSignal;
@property (readonly,nonatomic) RACSignal *keyboardWillHideSignal;
@property (readonly,nonatomic) RACSignal *keyboardDidHideSignal;
@property (readonly,nonatomic) RACSignal *keyboardWillShowSignal;
@property (readonly,nonatomic) RACSignal *keyboardDidShowSignal;

@end
