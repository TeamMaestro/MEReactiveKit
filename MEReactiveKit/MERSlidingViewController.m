//
//  MERSlidingViewController.m
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

#import "MERSlidingViewController.h"
#import <MEFoundation/MEDebugging.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

@interface MERSlidingViewController () <UIGestureRecognizerDelegate>
@property (readwrite,assign,nonatomic) MERSlidingViewControllerTopViewControllerState topViewControllerState;

@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

- (CGRect)_topViewControllerFrameForTopViewControllerState:(MERSlidingViewControllerTopViewControllerState)state;
- (CGRect)_leftViewControllerFrameForTopViewControllerState:(MERSlidingViewControllerTopViewControllerState)state;
- (CGRect)_rightViewControllerFrameForTopViewControllerState:(MERSlidingViewControllerTopViewControllerState)state;

+ (NSTimeInterval)_defaultTopViewControllerAnchorAnimationDuration;
+ (NSTimeInterval)_defaultTopViewControllerResetAnimationDuration;
@end

@implementation MERSlidingViewController
#pragma mark *** Subclass Overrides ***
- (id)init {
    if (!(self = [super init]))
        return nil;
    
    _topViewControllerAnchorAnimationDuration = [self.class _defaultTopViewControllerAnchorAnimationDuration];
    _topViewControllerResetAnimationDuration = [self.class _defaultTopViewControllerResetAnimationDuration];
    
    @weakify(self);
    
    [[[[RACObserve(self, tapGestureRecognizer)
        distinctUntilChanged]
       deliverOn:[RACScheduler mainThreadScheduler]]
      combinePreviousWithStart:nil reduce:^id(id previous, id current) {
          return RACTuplePack(previous,current);
      }] subscribeNext:^(RACTuple *value) {
          @strongify(self);
          
          RACTupleUnpack(UITapGestureRecognizer *previous, UITapGestureRecognizer *current) = value;
          
          if (previous) {
              [previous.view removeGestureRecognizer:previous];
          }
          
          if (current) {
              [current setNumberOfTouchesRequired:1];
              [current setNumberOfTapsRequired:1];
              [current setDelegate:self];
              
              [[current rac_gestureSignal] subscribeNext:^(id x) {
                  @strongify(self);
                  
                  [self resetTopViewControllerAnimated:YES];
              }];
              
              [self.view addGestureRecognizer:current];
          }
      }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MEAssert(self.topViewController,@"%@ cannot be nil!",NSStringFromSelector(@selector(topViewController)));
    
    [self.view addSubview:self.topViewController.view];
    [self.view addSubview:self.leftViewController.view];
    [self.view addSubview:self.rightViewController.view];
}
- (void)viewWillLayoutSubviews {
    [self.view bringSubviewToFront:self.topViewController.view];
}
- (void)viewDidLayoutSubviews {
    if (!self.view.isUserInteractionEnabled)
        return;
    
    [self.topViewController.view setFrame:[self _topViewControllerFrameForTopViewControllerState:self.topViewControllerState]];
    [self.leftViewController.view setFrame:[self _leftViewControllerFrameForTopViewControllerState:self.topViewControllerState]];
    [self.rightViewController.view setFrame:[self _rightViewControllerFrameForTopViewControllerState:self.topViewControllerState]];
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return CGRectContainsPoint(self.topViewController.view.bounds, [touch locationInView:self.topViewController.view]);
}
#pragma mark *** Public Methods ***
- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated; {
    [self toggleTopViewControllerToRightAnimated:animated animations:nil completion:nil];
}
- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion; {
    if (self.topViewControllerState == MERSlidingViewControllerTopViewControllerStateCenter)
        [self anchorTopViewControllerToRightAnimated:animated animations:animations completion:completion];
    else
        [self resetTopViewControllerAnimated:animated animations:animations completion:completion];
}

- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated; {
    [self anchorTopViewControllerToRightAnimated:animated animations:nil completion:nil];
}
- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion; {
    if (self.topViewControllerState == MERSlidingViewControllerTopViewControllerStateRight)
        return;
    
    @weakify(self);
    
    [self.view setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:(animated) ? self.topViewControllerAnchorAnimationDuration : 0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        
        [self.topViewController.view setFrame:[self _topViewControllerFrameForTopViewControllerState:MERSlidingViewControllerTopViewControllerStateRight]];
        
        if (animations)
            animations();
        
    } completion:^(BOOL finished) {
        @strongify(self);
        
        if (finished) {
            [self setTopViewControllerState:MERSlidingViewControllerTopViewControllerStateRight];
        
            if ((self.anchorGestureOptions & MERSlidingViewControllerAnchorGestureOptionTap) != 0)
                [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
            
            [self.view setUserInteractionEnabled:YES];
            
            if (completion)
                completion();
        }
    }];
}

- (void)resetTopViewControllerAnimated:(BOOL)animated; {
    [self resetTopViewControllerAnimated:animated animations:nil completion:nil];
}
- (void)resetTopViewControllerAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion; {
    if (self.topViewControllerState == MERSlidingViewControllerTopViewControllerStateCenter)
        return;
    
    @weakify(self);
    
    [self.view setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:(animated) ? self.topViewControllerResetAnimationDuration : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        
        [self.topViewController.view setFrame:[self _topViewControllerFrameForTopViewControllerState:MERSlidingViewControllerTopViewControllerStateCenter]];
        
        if (animations)
            animations();
    } completion:^(BOOL finished) {
        @strongify(self);
        
        if (finished) {
            [self setTopViewControllerState:MERSlidingViewControllerTopViewControllerStateCenter];
            [self setTapGestureRecognizer:nil];
            
            [self.view setUserInteractionEnabled:YES];
            
            if (completion)
                completion();
        }
    }];
}
#pragma mark Properties
- (void)setTopViewController:(UIViewController *)topViewController {
    [_topViewController willMoveToParentViewController:nil];
    [_topViewController.view removeFromSuperview];
    [_topViewController removeFromParentViewController];
    
    _topViewController = topViewController;
    
    if (self.topViewController) {
        [self addChildViewController:self.topViewController];
        if (self.isViewLoaded) {
            [self.view addSubview:self.topViewController.view];
            [self.view layoutIfNeeded];
        }
        [self.topViewController didMoveToParentViewController:self];
    }
}
- (void)setLeftViewController:(UIViewController *)leftViewController {
    [_leftViewController willMoveToParentViewController:nil];
    [_leftViewController.view removeFromSuperview];
    [_leftViewController removeFromParentViewController];
    
    _leftViewController = leftViewController;
    
    if (self.leftViewController) {
        [self addChildViewController:self.leftViewController];
        if (self.isViewLoaded) {
            [self.view addSubview:self.leftViewController.view];
            [self.view layoutIfNeeded];
        }
        [self.leftViewController didMoveToParentViewController:self];
    }
}

- (void)setTopViewControllerAnchorAnimationDuration:(NSTimeInterval)topViewControllerAnchorAnimationDuration {
    _topViewControllerAnchorAnimationDuration = (topViewControllerAnchorAnimationDuration <= 0.0) ? [self.class _defaultTopViewControllerAnchorAnimationDuration] : topViewControllerAnchorAnimationDuration;
}
- (void)setTopViewControllerResetAnimationDuration:(NSTimeInterval)topViewControllerResetAnimationDuration {
    _topViewControllerResetAnimationDuration = (topViewControllerResetAnimationDuration <= 0.0) ? [self.class _defaultTopViewControllerResetAnimationDuration] : topViewControllerResetAnimationDuration;
}
#pragma mark *** Private Methods ***
- (CGRect)_topViewControllerFrameForTopViewControllerState:(MERSlidingViewControllerTopViewControllerState)state; {
    switch (state) {
        case MERSlidingViewControllerTopViewControllerStateCenter:
            return self.view.bounds;
        case MERSlidingViewControllerTopViewControllerStateLeft:
            return CGRectMake(-CGRectGetWidth(self.view.bounds) + self.peekAmount, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        case MERSlidingViewControllerTopViewControllerStateRight:
            return CGRectMake(CGRectGetWidth(self.view.bounds) - self.peekAmount, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        default:
            return CGRectZero;
    }
}
- (CGRect)_leftViewControllerFrameForTopViewControllerState:(MERSlidingViewControllerTopViewControllerState)state; {
    switch (state) {
        case MERSlidingViewControllerTopViewControllerStateCenter:
        case MERSlidingViewControllerTopViewControllerStateLeft:
        case MERSlidingViewControllerTopViewControllerStateRight:
            return CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - self.peekAmount, CGRectGetHeight(self.view.bounds));
        default:
            return CGRectZero;
    }
}
- (CGRect)_rightViewControllerFrameForTopViewControllerState:(MERSlidingViewControllerTopViewControllerState)state; {
    switch (state) {
        case MERSlidingViewControllerTopViewControllerStateCenter:
        case MERSlidingViewControllerTopViewControllerStateLeft:
        case MERSlidingViewControllerTopViewControllerStateRight:
            return CGRectMake(self.peekAmount, 0, CGRectGetWidth(self.view.bounds) - self.peekAmount, CGRectGetHeight(self.view.bounds));
        default:
            return CGRectZero;
    }
}

+ (NSTimeInterval)_defaultTopViewControllerAnchorAnimationDuration {
    return 0.5;
}
+ (NSTimeInterval)_defaultTopViewControllerResetAnimationDuration {
    return 0.33;
}

@end

@implementation UIViewController (MERSlidingViewControllerExtensions)

- (MERSlidingViewController *)MER_slidingViewController {
    UIViewController *viewController = self.parentViewController ? self.parentViewController : self.presentingViewController;
    
    while (!(viewController == nil || [viewController isKindOfClass:[MERSlidingViewController class]])) {
        viewController = viewController.parentViewController ? viewController.parentViewController : viewController.presentingViewController;
    }
    
    return (MERSlidingViewController *)viewController;
}

@end
