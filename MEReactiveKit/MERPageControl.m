//
//  MERPageControl.m
//  MEReactiveKit
//
//  Created by William Towe on 11/16/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERPageControl.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEGeometry.h>
#import <MEFoundation/MEMacros.h>

@interface MERPageControl ()
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) NSArray *pageIndicatorImageViews;

- (void)_MERPageControl_init;
@end

@implementation MERPageControl
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERPageControl_init];
    
    return self;
}

- (void)layoutSubviews {
    [self.backgroundImageView setFrame:self.bounds];
    
    CGRect const kRect = ME_CGRectCenter(CGRectMake(0, 0, [self sizeForNumberOfPages:self.numberOfPages].width, MAX(self.pageIndicatorImage.size.height, self.currentPageIndicatorImage.size.height)), self.bounds);
    CGFloat frameX = CGRectGetMinX(kRect) + self.pageIndicatorSpacing;
    
    for (UIImageView *imageView in self.pageIndicatorImageViews) {
        CGSize const kImageViewSize = (imageView.isHighlighted) ? self.currentPageIndicatorImage.size : self.pageIndicatorImage.size;
        
        [imageView setFrame:CGRectMake(frameX, CGRectGetMinY(kRect), kImageViewSize.width, kImageViewSize.height)];
        
        frameX = CGRectGetMaxX(imageView.frame) + self.pageIndicatorSpacing;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize minimumSize = [self sizeForNumberOfPages:self.numberOfPages];

    return CGSizeMake(MAX(minimumSize.width, size.width), MAX(minimumSize.height, size.height));
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERPageControl_init];
    
    return self;
}
#pragma mark *** Public Methods ***
- (CGSize)sizeForNumberOfPages:(NSInteger)numberOfPages; {
    CGFloat width = (MAX(self.pageIndicatorImage.size.width, self.currentPageIndicatorImage.size.height) * numberOfPages) + (self.pageIndicatorSpacing * (numberOfPages - 1));
    CGFloat height = MAX(self.backgroundImage.size.height, MAX(self.pageIndicatorImage.size.height, self.currentPageIndicatorImage.size.height));
    
    if (self.backgroundImage)
        width += self.pageIndicatorSpacing * 2;
    
    return CGSizeMake(width, height);
}
#pragma mark Properties
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = MEBoundedValue(currentPage, 0, self.numberOfPages - 1);
}
#pragma mark *** Private Methods ***
- (void)_MERPageControl_init; {
    [self setBackgroundImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.backgroundImageView];
    
    [self setPageIndicatorImageViews:@[]];
    
    @weakify(self);
    
    RACChannelTo(self.backgroundImageView,image) = RACChannelTo(self,backgroundImage);
    
    RAC(self,pageIndicatorImageViews) = [RACObserve(self, numberOfPages) map:^id(NSNumber *value) {
        NSMutableArray *retval = [NSMutableArray arrayWithCapacity:0];
        NSInteger numberOfPages = value.integerValue;
        
        RACSignal *hiddenSignal = [RACSignal combineLatest:@[[RACObserve(self, hidesForSinglePage) distinctUntilChanged],[RACObserve(self, numberOfPages) distinctUntilChanged]] reduce:^id(NSNumber *hidesForSignalPage,NSNumber *numberOfPages){
            return @(hidesForSignalPage.boolValue && numberOfPages.integerValue <= 1);
        }];
        
        for (NSInteger pageNumber=0; pageNumber<numberOfPages; pageNumber++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            
            RAC(imageView,hidden) = hiddenSignal;
            RACChannelTo(imageView,image) = RACChannelTo(self,pageIndicatorImage);
            RACChannelTo(imageView,highlightedImage) = RACChannelTo(self,currentPageIndicatorImage);
            RAC(imageView,highlighted) = [[RACObserve(self, currentPage) distinctUntilChanged] map:^id(NSNumber *value) {
                return @(value.integerValue == pageNumber);
            }];
            
            [retval addObject:imageView];
        }
        
        return retval;
    }];
    
    [[[RACObserve(self, pageIndicatorImageViews)
      combinePreviousWithStart:nil reduce:^id(id previous, id current) {
          return RACTuplePack(previous,current);
    }] deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self);
         
         RACTupleUnpack(NSArray *previous, NSArray *current) = tuple;
         
         [previous makeObjectsPerformSelector:@selector(removeFromSuperview)];
         
         for (UIImageView *imageView in current)
             [self addSubview:imageView];
    }];
    
    [[[RACObserve(self, pageIndicatorSpacing)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [[tapGestureRecognizer rac_gestureSignal]
     subscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
         @strongify(self);
         
         if ([gestureRecognizer locationInView:self].x <= CGRectGetMidX(self.bounds))
             [self setCurrentPage:self.currentPage - 1];
         else
             [self setCurrentPage:self.currentPage + 1];
         
         [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
