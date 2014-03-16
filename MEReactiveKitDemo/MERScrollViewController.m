//
//  MERScrollViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/16/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

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
