//
//  MERLeftViewController.m
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

#import "MERLeftViewController.h"

NSString *const MERLeftViewControllerNotificationDidChangeTag = @"MERLeftViewControllerNotificationDidChangeTag";
NSString *const MERLeftViewControllerUserInfoKeyTag = @"MERLeftViewControllerUserInfoKeyTag";

@interface MERLeftViewController ()
@property (strong,nonatomic) NSArray *tags;

- (NSString *)_titleForTag:(MERLeftViewControllerTag)tag;
@end

@implementation MERLeftViewController

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setTags:@[@(MERLeftViewControllerTagWebView),@(MERLeftViewControllerTagScrollView),@(MERLeftViewControllerTagPaginatedScrolling),@(MERLeftViewControllerTagTextView)]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setText:[self _titleForTag:[self.tags[indexPath.row] integerValue]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:MERLeftViewControllerNotificationDidChangeTag object:self userInfo:@{MERLeftViewControllerUserInfoKeyTag: self.tags[indexPath.row]}];
}

- (NSString *)_titleForTag:(MERLeftViewControllerTag)tag; {
    switch (tag) {
        case MERLeftViewControllerTagScrollView:
            return @"Gradient Scroll View";
        case MERLeftViewControllerTagWebView:
            return @"Web View";
        case MERLeftViewControllerTagPaginatedScrolling:
            return @"Paginated Scrolling";
        case MERLeftViewControllerTagTextView:
            return @"Gradient Text View";
        default:
            break;
    }
}

@end
