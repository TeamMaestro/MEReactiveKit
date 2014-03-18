//
//  MERDetailTextViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/17/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERDetailTextViewController.h"
#import <MEReactiveKit/MEReactiveKit.h>

@interface MERDetailTextViewController ()
@property (strong,nonatomic) MERTextView *textView;
@end

@implementation MERDetailTextViewController

- (NSString *)title {
    return @"Gradient Text View";
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTextView:[[MERTextView alloc] initWithFrame:CGRectZero textContainer:nil]];
    [self.textView setEditable:NO];
    [self.textView setFont:[UIFont systemFontOfSize:17]];
    [self.textView setText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sed tristique magna, interdum euismod nulla. Praesent ut odio sit amet enim dapibus tempus. Nulla mollis, dui vitae bibendum iaculis, risus metus vulputate quam, ut commodo purus neque sed sapien. Curabitur malesuada aliquam erat in faucibus. Pellentesque convallis vulputate libero a consequat. Sed condimentum elit lacus, non faucibus lacus accumsan at. Nullam interdum blandit metus in sodales.\n\n"
     
@"Nullam vitae imperdiet erat. Curabitur at ullamcorper lectus, sed tincidunt eros. Nunc adipiscing, neque sed gravida lacinia, metus lorem egestas mauris, ac rutrum urna eros ac nisl. Proin volutpat varius est eu pharetra. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque dignissim pharetra dui eu pharetra. Integer nec neque a turpis fermentum pharetra ac nec ipsum. Praesent convallis, ante id auctor venenatis, sapien elit vehicula nisl, in pharetra libero lacus a massa. Duis ullamcorper erat sed enim pretium gravida. Cras vestibulum elit nisl, vitae molestie justo pellentesque quis. Ut in aliquet nisl. Proin sed massa ac neque iaculis euismod sit amet sed leo. Proin non arcu at sem dignissim vestibulum vel at eros.\n\n"
     
     @"In in facilisis sem. Phasellus aliquet varius posuere. Proin mauris lorem, sagittis ac velit eget, gravida scelerisque lacus. Morbi vitae urna vitae leo ornare gravida et a magna. Sed elementum ipsum felis, a eleifend quam feugiat quis. Ut fringilla at lorem at gravida. Quisque eget leo in lorem pharetra ultrices. Sed pellentesque aliquet odio. Aenean tincidunt lobortis ipsum nec dapibus. Curabitur bibendum est nunc, quis consectetur odio consequat sollicitudin. Pellentesque eu mollis elit, adipiscing pharetra tellus. Aenean congue elit vitae sapien faucibus elementum.\n\n"
     
     @"Donec id luctus tellus, quis laoreet ligula. Morbi sed velit libero. Donec fringilla imperdiet ultrices. Donec nec nisl molestie quam pellentesque sollicitudin. Phasellus elementum tempus ipsum, ac molestie sapien laoreet sit amet. Proin vehicula accumsan mollis. Integer tempus purus erat, vitae tincidunt massa blandit dignissim.\n\n"
     
     @"Etiam venenatis diam et ipsum hendrerit, in aliquam nulla dictum. Pellentesque tincidunt tempor fringilla. Integer congue cursus elementum. Sed tristique, arcu quis convallis accumsan, erat metus mattis eros, at rutrum metus libero eget ligula. Vestibulum ut fringilla urna. Morbi a nunc urna. Phasellus eleifend vel mauris quis bibendum.\n\n"];
    [self.textView setTopGradientPercentage:0.1];
    [self.textView setBottomGradientPercentage:0.1];
    [self.view addSubview:self.textView];
}
- (void)viewDidLayoutSubviews {
    [self.textView setFrame:CGRectInset(self.view.bounds, 20, 20)];
}

- (void)configureNavigationItem {
    [super configureNavigationItem];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(_menuItemAction:)];
    
    [self.navigationItem setLeftBarButtonItems:@[menuItem]];
}

- (IBAction)_menuItemAction:(id)sender {
    [self.MER_slidingViewController toggleTopViewControllerToRightAnimated:YES];
    [self.MER_splitViewController toggleMasterViewControllerAnimated:YES];
}

@end
