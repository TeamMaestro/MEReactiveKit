//
//  MERRootViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/16/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERRootSlidingViewController.h"
#import "MERDetailScrollViewController.h"
#import "MERLeftViewController.h"
#import "MERDetailWebViewController.h"
#import "MERPaginatedScrollingViewController.h"
#import "MERDetailTextViewController.h"
#import "MERControlsViewController.h"

@interface MERRootSlidingViewController ()

@end

@implementation MERRootSlidingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setAnchorGestureOptions:MERSlidingViewControllerAnchorGestureOptionAll];
    [self setPeekAmount:44];
    [self setTopViewController:[[UINavigationController alloc] initWithRootViewController:[[MERDetailScrollViewController alloc] init]]];
    [self setLeftViewController:[[MERLeftViewController alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeTag:) name:MERLeftViewControllerNotificationDidChangeTag object:nil];
    
    return self;
}

- (void)_didChangeTag:(NSNotification *)note {
    MERLeftViewControllerTag tag = [note.userInfo[MERLeftViewControllerUserInfoKeyTag] integerValue];
    UIViewController *viewController = nil;
    
    switch (tag) {
        case MERLeftViewControllerTagWebView:
            viewController = [[MERDetailWebViewController alloc] init];
            break;
        case MERLeftViewControllerTagScrollView:
            viewController = [[MERDetailScrollViewController alloc] init];
            break;
        case MERLeftViewControllerTagPaginatedScrolling:
            viewController = [[MERPaginatedScrollingViewController alloc] init];
            break;
        case MERLeftViewControllerTagTextView:
            viewController = [[MERDetailTextViewController alloc] init];
            break;
        case MERLeftViewControllerTagControls:
            viewController = [[MERControlsViewController alloc] init];
            break;
        default:
            break;
    }
    
    if (viewController) {
        [self setTopViewController:[[UINavigationController alloc] initWithRootViewController:viewController]];
    }
    
    [self resetTopViewControllerAnimated:YES];
}

@end
