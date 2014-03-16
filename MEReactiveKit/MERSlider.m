//
//  MERSlider.m
//  MEReactiveKit
//
//  Created by William Towe on 11/17/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERSlider.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEGeometry.h>
#import <MEFoundation/MEMacros.h>
#import "NSMutableDictionary+MERExtensionsPrivate.h"

NSTimeInterval const MERSliderAnimationDuration = 0.33;

@interface MERSlider () <UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIImageView *maximumTrackImageView;
@property (strong,nonatomic) UIImageView *minimumTrackImageView;
@property (strong,nonatomic) UIImageView *thumbImageView;
@property (strong,nonatomic) UIImageView *minimumValueImageView;
@property (strong,nonatomic) UIImageView *maximumValueImageView;

@property (strong,nonatomic) NSMutableDictionary *controlStatesToMinimumTrackImages;
@property (strong,nonatomic) NSMutableDictionary *controlStatesToMaximumTrackImages;
@property (strong,nonatomic) NSMutableDictionary *controlStatesToThumbImages;

- (void)_MERSlider_init;
@end

@implementation MERSlider
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERSlider_init];
    
    return self;
}

- (void)layoutSubviews {
    [self.minimumValueImageView setFrame:[self minimumValueImageRectForBounds:self.bounds]];
    [self.maximumValueImageView setFrame:[self maximumValueImageRectForBounds:self.bounds]];
    [self.maximumTrackImageView setFrame:[self maximumTrackRectForBounds:self.bounds]];
    [self.minimumTrackImageView setFrame:[self minimumTrackRectForBounds:self.bounds]];
    [self.thumbImageView setFrame:[self thumbRectForBounds:self.bounds trackRect:[self maximumTrackRectForBounds:self.bounds] value:self.value]];
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIImage *const kMaximumTrackImage = [self maximumTrackImageForState:UIControlStateNormal];
    UIImage *const kMinimumTrackImage = [self minimumTrackImageForState:UIControlStateNormal];
    UIImage *const kThumbImage = [self thumbImageForState:UIControlStateNormal];
    CGFloat const kMinimumWidth = [[@[@(kMaximumTrackImage.size.width),@(kMinimumTrackImage.size.width),@(kThumbImage.size.width)].rac_sequence foldLeftWithStart:@0 reduce:^id(NSNumber *accumulator, NSNumber *value) {
        return @(MAX(accumulator.doubleValue, value.doubleValue));
    }] doubleValue] + self.minimumValueImage.size.width + self.maximumValueImage.size.width + self.minimumMaximumValueImageEdgeInsets.left + self.minimumMaximumValueImageEdgeInsets.right;
    CGFloat const kMinimumHeight = [[@[@(kMaximumTrackImage.size.height),@(kMinimumTrackImage.size.height),@(kThumbImage.size.height),@(self.minimumValueImage.size.height),@(self.maximumValueImage.size.height)].rac_sequence foldLeftWithStart:@0 reduce:^id(NSNumber *accumulator, NSNumber *value) {
        return @(MAX(accumulator.doubleValue, value.doubleValue));
    }] doubleValue];

    return CGSizeMake(MAX(kMinimumWidth, size.width), MAX(kMinimumHeight, size.height));
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERSlider_init];
    
    return self;
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
        return CGRectContainsPoint(self.thumbImageView.bounds, [gestureRecognizer locationInView:self.thumbImageView]);
    return (!CGRectContainsPoint(self.thumbImageView.bounds, [gestureRecognizer locationInView:self.thumbImageView]));
}
#pragma mark *** Public Methods ***
#pragma mark Layout
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds; {
    return ME_CGRectCenterY(CGRectMake(CGRectGetWidth(bounds) - self.maximumValueImage.size.width, 0, self.maximumValueImage.size.width, self.maximumValueImage.size.height), bounds);
}
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds; {
    return ME_CGRectCenterY(CGRectMake(0, 0, self.minimumValueImage.size.width, self.minimumValueImage.size.height), bounds);
}
- (CGRect)maximumTrackRectForBounds:(CGRect)bounds; {
    CGRect const kMinimumValueImageRect = [self minimumValueImageRectForBounds:bounds];
    CGRect const kMaximumValueImageRect = [self maximumValueImageRectForBounds:bounds];
    UIImage const *kMaximumTrackImage = [self maximumTrackImageForState:self.state];
    
    return ME_CGRectCenterY(CGRectMake(CGRectGetMaxX(kMinimumValueImageRect) + self.minimumMaximumValueImageEdgeInsets.left, 0, CGRectGetMinX(kMaximumValueImageRect) - CGRectGetMaxX(kMinimumValueImageRect) - self.minimumMaximumValueImageEdgeInsets.left - self.minimumMaximumValueImageEdgeInsets.right, kMaximumTrackImage.size.height), bounds);
}
- (CGRect)minimumTrackRectForBounds:(CGRect)bounds; {
    CGRect const kMaximumTrackRect = [self maximumTrackRectForBounds:bounds];
    CGRect const kThumbRect = [self thumbRectForBounds:bounds trackRect:kMaximumTrackRect value:self.value];
    UIImage const *kMinimumTrackImage = [self minimumTrackImageForState:self.state];
    
    return ME_CGRectCenterY(CGRectMake(CGRectGetMinX(kMaximumTrackRect), 0, CGRectGetMidX(kThumbRect) - CGRectGetMinX(kMaximumTrackRect), kMinimumTrackImage.size.height), bounds);
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)trackRect value:(CGFloat)value; {
    UIImage const *kThumbImage = [self thumbImageForState:self.state];
    CGFloat const kNormalizedValue = (value / (self.maximumValue - self.minimumValue));
    
    return ME_CGRectCenterY(CGRectMake(MEBoundedValue(floor(kNormalizedValue * CGRectGetWidth(trackRect) - kThumbImage.size.width * 0.5), CGRectGetMinX(trackRect), CGRectGetMaxX(trackRect) - kThumbImage.size.width), 0, kThumbImage.size.width, kThumbImage.size.height), bounds);
}
#pragma mark Appearance
- (UIImage *)maximumTrackImageForState:(UIControlState)state {
    return [self.controlStatesToMaximumTrackImages MER_objectForState:state];
}
- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage forState:(UIControlState)state {
    [self.controlStatesToMaximumTrackImages MER_setObject:maximumTrackImage forState:state];
}

- (UIImage *)minimumTrackImageForState:(UIControlState)state {
    return [self.controlStatesToMinimumTrackImages MER_objectForState:state];
}
- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage forState:(UIControlState)state {
    [self.controlStatesToMinimumTrackImages MER_setObject:minimumTrackImage forState:state];
}

- (UIImage *)thumbImageForState:(UIControlState)state {
    return [self.controlStatesToThumbImages MER_objectForState:state];
}
- (void)setThumbImage:(UIImage *)thumbImage forState:(UIControlState)state {
    [self.controlStatesToThumbImages MER_setObject:thumbImage forState:state];
}
#pragma mark Properties
- (void)setValue:(CGFloat)value {
    [self setValue:value animated:NO animations:nil completion:nil];
}
- (void)setValue:(CGFloat)value animated:(BOOL)animated; {
    [self setValue:value animated:animated animations:nil completion:nil];
}
- (void)setValue:(CGFloat)value animated:(BOOL)animated completion:(void (^)(void))completion; {
    [self setValue:value animated:animated animations:nil completion:completion];
}
- (void)setValue:(CGFloat)value animated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion; {
    [self willChangeValueForKey:@"value"];
    _value = MEBoundedValue(value, self.minimumValue, self.maximumValue);
    [self didChangeValueForKey:@"value"];
    
    @weakify(self);
    
    [self setNeedsLayout];
    
    [UIView animateWithDuration:(animated) ? MERSliderAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        @strongify(self);
        
        [self layoutIfNeeded];
        
        if (animations)
            animations();
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion)
                completion();
        }
    }];
}
#pragma mark *** Private Methods ***
- (void)_MERSlider_init; {
    [self setControlStatesToMaximumTrackImages:[NSMutableDictionary dictionaryWithCapacity:0]];
    [self setControlStatesToMinimumTrackImages:[NSMutableDictionary dictionaryWithCapacity:0]];
    [self setControlStatesToThumbImages:[NSMutableDictionary dictionaryWithCapacity:0]];
    
    [self setMaximumTrackImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.maximumTrackImageView];
    
    [self setMinimumTrackImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.minimumTrackImageView];
    
    [self setThumbImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.thumbImageView];
    
    [self setMinimumValueImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.minimumValueImageView];
    
    [self setMaximumValueImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.maximumValueImageView];
    
    [self setMinimumValue:0.0];
    [self setMaximumValue:1.0];
    
    RACChannelTo(self.minimumValueImageView,image) = RACChannelTo(self,minimumValueImage);
    
    RACChannelTo(self.maximumValueImageView,image) = RACChannelTo(self,maximumValueImage);
    
    @weakify(self);
    
    [[[RACSignal combineLatest:@[[RACObserve(self, enabled) distinctUntilChanged],[RACObserve(self, highlighted) distinctUntilChanged],[RACObserve(self, selected) distinctUntilChanged]]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self.maximumTrackImageView setImage:[self maximumTrackImageForState:self.state]];
         [self.minimumTrackImageView setImage:[self minimumTrackImageForState:self.state]];
         [self.thumbImageView setImage:[self thumbImageForState:self.state]];
    }];
    
    [[[RACObserve(self, minimumValueImage)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
    
    [[[RACObserve(self, maximumValueImage)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
     }];
    
    [[[RACObserve(self, minimumMaximumValueImageEdgeInsets)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:NULL];
    __block CGPoint panGestureBeganPoint = CGPointZero;
    
    [panGestureRecognizer setCancelsTouchesInView:NO];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setDelegate:self];
    [[panGestureRecognizer rac_gestureSignal]
     subscribeNext:^(UIPanGestureRecognizer *gestureRecognizer) {
         @strongify(self);
         
         switch (gestureRecognizer.state) {
             case UIGestureRecognizerStateBegan:
                 panGestureBeganPoint = [gestureRecognizer locationInView:self];
                 break;
             case UIGestureRecognizerStateChanged: {
                 CGFloat const kPointX = panGestureBeganPoint.x + [gestureRecognizer translationInView:self].x;
                 
                 [self setValue:(kPointX / CGRectGetWidth(self.maximumTrackImageView.frame)) * self.maximumValue animated:NO completion:^{
                     @strongify(self);
                     
                     if (self.isContinuous)
                         [self sendActionsForControlEvents:UIControlEventValueChanged];
                 }];
             }
                 break;
             case UIGestureRecognizerStateCancelled:
             case UIGestureRecognizerStateEnded:
                 panGestureBeganPoint = CGPointZero;
                 break;
             default:
                 break;
         }
     }];
    
    [self addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [tapGestureRecognizer setDelegate:self];
    [[tapGestureRecognizer rac_gestureSignal]
     subscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
         @strongify(self);
         
         [self setValue:([gestureRecognizer locationInView:self].x / CGRectGetWidth(self.maximumTrackImageView.frame)) * self.maximumValue animated:YES completion:^{
             @strongify(self);
             
             [self sendActionsForControlEvents:UIControlEventValueChanged];
         }];
     }];
    
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
