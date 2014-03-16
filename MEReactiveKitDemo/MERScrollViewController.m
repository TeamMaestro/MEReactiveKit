//
//  MERScrollViewController.m
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

#import "MERScrollViewController.h"
#import <MEReactiveKit/MEReactiveKit.h>

@interface MERScrollViewController ()
@property (strong,nonatomic) MERScrollView *scrollView;
@property (strong,nonatomic) UIView *contentView;
@end

@implementation MERScrollViewController

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (NSString *)title {
    return @"Scroll View";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setScrollView:[[MERScrollView alloc] initWithFrame:CGRectZero]];
    [self.scrollView setTopGradientPercentage:0.05];
    [self.scrollView setBottomGradientPercentage:0.05];
    [self.view addSubview:self.scrollView];
    
    [self setContentView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:self.contentView];
}
- (void)viewDidLayoutSubviews {
    [self.scrollView setFrame:CGRectInset(self.view.bounds, 20, 20)];
    
    [self.contentView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds) * 2)];
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.contentView.frame))];
}

@end
