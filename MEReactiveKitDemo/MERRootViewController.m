//
//  MERRootViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/16/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERRootViewController.h"
#import <MEReactiveKit/MEReactiveKit.h>
#import "MERScrollViewController.h"

@interface MERRootViewController ()

@end

@implementation MERRootViewController

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    MERWebViewController *webViewController = [[MERWebViewController alloc] init];
    
    [webViewController loadURLString:@"http://arstechnica.com"];
    
    UITabBarItem *webViewTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Web View" image:nil selectedImage:nil];
    
    [webViewController setTabBarItem:webViewTabBarItem];
    
    [self setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:webViewController],[[UINavigationController alloc] initWithRootViewController:[[MERScrollViewController alloc] init]]]];
    
    return self;
}

@end
