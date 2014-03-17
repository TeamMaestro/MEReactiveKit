//
//  MERSlidingViewController.h
//  MEReactiveKit
//
//  Created by William Towe on 3/17/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERViewController.h"

typedef NS_ENUM(NSInteger, MERSlidingViewControllerTopViewControllerState) {
    MERSlidingViewControllerTopViewControllerStateCenter,
    MERSlidingViewControllerTopViewControllerStateLeft,
    MERSlidingViewControllerTopViewControllerStateRight
};

typedef NS_OPTIONS(NSInteger, MERSlidingViewControllerAnchorGestureOptions) {
    MERSlidingViewControllerAnchorGestureOptionNone = 0,
    MERSlidingViewControllerAnchorGestureOptionTap = 1 << 0
};

@interface MERSlidingViewController : MERViewController

@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) UIViewController *leftViewController;
@property (strong,nonatomic) UIViewController *rightViewController;

@property (readonly,assign,nonatomic) MERSlidingViewControllerTopViewControllerState topViewControllerState;

@property (assign,nonatomic) MERSlidingViewControllerAnchorGestureOptions anchorGestureOptions;

@property (assign,nonatomic) CGFloat peekAmount;

@property (assign,nonatomic) NSTimeInterval topViewControllerAnchorAnimationDuration UI_APPEARANCE_SELECTOR;
@property (assign,nonatomic) NSTimeInterval topViewControllerResetAnimationDuration UI_APPEARANCE_SELECTOR;

- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated;
- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated;
- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

- (void)resetTopViewControllerAnimated:(BOOL)animated;
- (void)resetTopViewControllerAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

@end

@interface UIViewController (MERSlidingViewControllerExtensions)

@property (readonly,nonatomic) MERSlidingViewController *MER_slidingViewController;

@end