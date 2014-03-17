//
//  UIScrollView+MERPaginatedScrollingExtensions.h
//  MEReactiveKit
//
//  Created by William Towe on 3/11/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "MERPaginatedScrolling.h"

typedef NS_ENUM(NSInteger, MERPaginatedScrollingState) {
    MERPaginatedScrollingStateNone,
    MERPaginatedScrollingStateWillPaginate,
    MERPaginatedScrollingStatePaginating
};

typedef void(^MERPaginatedScrollingCompletionBlock)(void);

@interface UIScrollView (MERPaginatedScrollingExtensions)

@property (readonly,strong,nonatomic) UIView<MERPaginatedScrolling> *MER_paginatedScrollingView;
@property (assign,nonatomic) BOOL MER_paginatedScrollingEnabled;
@property (readonly,assign,nonatomic) MERPaginatedScrollingState MER_paginatedScrollingState;

- (void)MER_addPaginatedScrollingViewWithBlock:(void (^)(MERPaginatedScrollingCompletionBlock completion))block;
- (void)MER_addPaginatedScrollingView:(UIView<MERPaginatedScrolling> *)view block:(void (^)(MERPaginatedScrollingCompletionBlock completion))block;

- (void)MER_removePaginatedScrollingView;

@end
