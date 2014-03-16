//
//  MERRootViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/16/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERRootViewController.h"
#import <MEReactiveKit/MEReactiveKit.h>
#import <MEReactiveFoundation/MEReactiveFoundation.h>

@interface MERRootViewController ()

@end

@implementation MERRootViewController

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    MERWebViewController *webViewController = [[MERWebViewController alloc] init];
    
    [webViewController loadURLString:@"http://arstechnica.com"];
    [webViewController setTabBarItem:<#(UITabBarItem *)#>
    
    return self;
}

@end
