//
//  MERControlsViewController.m
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

#import "MERControlsViewController.h"
#import <MEReactiveKit/MEReactiveKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEGeometry.h>

#import <QuartzCore/QuartzCore.h>

@interface MERControlsViewController () <MERPickerViewButtonDataSource>
@property (strong,nonatomic) MERTextField *textField;
@property (strong,nonatomic) MERPickerViewButton *pickerViewButton;
@property (strong,nonatomic) MERDatePickerViewButton *datePickerViewButton;

@property (strong,nonatomic) NSArray *pickerViewRows;
@end

@implementation MERControlsViewController

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setPickerViewRows:@[@"Red",@"Green",@"Blue",@"Yellow"]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTextField:[[MERTextField alloc] initWithFrame:CGRectZero]];
    [self.textField.layer setBorderColor:self.view.tintColor.CGColor];
    [self.textField setPlaceholder:@"Type here…"];
    [self.textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.textField setTextEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.view addSubview:self.textField];
    
    [self setPickerViewButton:[[MERPickerViewButton alloc] initWithFrame:CGRectZero]];
    [self.pickerViewButton.layer setBorderColor:self.view.tintColor.CGColor];
    [self.pickerViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pickerViewButton setDataSource:self];
    [self.view addSubview:self.pickerViewButton];
    
    [self setDatePickerViewButton:[[MERDatePickerViewButton alloc] initWithFrame:CGRectZero]];
    [self.datePickerViewButton.layer setBorderColor:self.view.tintColor.CGColor];
    [self.datePickerViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.datePickerViewButton];
    
    [[[RACSignal merge:@[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil],
                         [[NSNotificationCenter defaultCenter] rac_addObserverForName:MERDatePickerViewButtonNotificationDidBecomeFirstResponder object:nil],
                         [[NSNotificationCenter defaultCenter] rac_addObserverForName:MERPickerViewButtonNotificationDidBecomeFirstResponder object:nil]]]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *note) {
         UIView *view = note.object;
         
         [view.layer setBorderWidth:1];
    }];
    
    [[[RACSignal merge:@[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidEndEditingNotification object:nil],
                         [[NSNotificationCenter defaultCenter] rac_addObserverForName:MERDatePickerViewButtonNotificationDidResignFirstResponder object:nil],
                         [[NSNotificationCenter defaultCenter] rac_addObserverForName:MERPickerViewButtonNotificationDidResignFirstResponder object:nil]]]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *note) {
         UIView *view = note.object;
         
         [view.layer setBorderWidth:0];
     }];
}
- (void)viewDidLayoutSubviews {
    [self.textField setFrame:ME_CGRectCenterX(CGRectMake(0, 20, CGRectGetWidth(self.view.bounds) - 40, 44), self.view.bounds)];
    [self.pickerViewButton setFrame:ME_CGRectCenterX(CGRectMake(0, CGRectGetMaxY(self.textField.frame) + 20, CGRectGetWidth(self.view.bounds) - 40, 44), self.view.bounds)];
    [self.datePickerViewButton setFrame:ME_CGRectCenterX(CGRectMake(0, CGRectGetMaxY(self.pickerViewButton.frame) + 20, CGRectGetWidth(self.pickerViewButton.frame), 44), self.view.bounds)];
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

#pragma mark MERPickerViewButtonDataSource
- (NSInteger)numberOfRowsInPickerViewButton:(MERPickerViewButton *)button {
    return self.pickerViewRows.count;
}
- (NSString *)pickerViewButton:(MERPickerViewButton *)button titleForRowAtIndex:(NSInteger)index {
    return self.pickerViewRows[index];
}

@end
