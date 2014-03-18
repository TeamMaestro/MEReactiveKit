//
//  MERPaginatedScrollingViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/17/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERPaginatedScrollingViewController.h"
#import <MEReactiveKit/MEReactiveKit.h>

@interface MERPaginatedScrollingViewController ()
@property (copy,nonatomic) NSArray *rows;
@end

@implementation MERPaginatedScrollingViewController

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<10; i++)
        [temp addObject:[NSNull null]];
    
    [self setRows:temp];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(_menuItemAction:)];
    
    [self.navigationItem setLeftBarButtonItems:@[menuItem]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    
    [self.tableView MER_addPaginatedScrollingViewWithBlock:^(MERPaginatedScrollingCompletionBlock completion) {
        __strong typeof(wself) sself = wself;
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSMutableArray *temp = [sself.rows mutableCopy];
            
            [temp addObject:[NSNull null]];
            
            [sself setRows:temp];
            
            [sself.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:temp.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            completion();
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"section %@, row %@",@(indexPath.section),@(indexPath.row)]];
    
    return cell;
}

- (IBAction)_menuItemAction:(id)sender {
    [self.MER_slidingViewController toggleTopViewControllerToRightAnimated:YES];
    [self.MER_splitViewController toggleMasterViewControllerAnimated:YES];
}

@end
