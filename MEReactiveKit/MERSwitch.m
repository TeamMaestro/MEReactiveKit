//
//  MERSwitch.m
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

#import "MERSwitch.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEGeometry.h>
#import <MEFoundation/MEDebugging.h>

NSTimeInterval const MERSwitchAnimationDuration = 0.33;

@interface MERSwitch ()
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UIImageView *switchImageView;
@property (strong,nonatomic) UILabel *onLabel;
@property (strong,nonatomic) UILabel *offLabel;

- (void)_MERSwitch_init;
- (CGSize)_onTitleSize;
- (CGSize)_offTitleSize;
@end

@implementation MERSwitch
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERSwitch_init];
    
    return self;
}

- (void)layoutSubviews {
    [self.backgroundImageView setFrame:ME_CGRectCenter(CGRectMake(0, 0, self.backgroundImage.size.width, self.backgroundImage.size.height), self.bounds)];
    
    CGRect const kSwitchImageViewFrame = (self.isOn) ? CGRectMake(CGRectGetMaxX(self.backgroundImageView.frame) - self.switchImage.size.width - self.switchImageEdgeInsets.right, 0, self.switchImage.size.width, self.switchImage.size.height) : CGRectMake(CGRectGetMinX(self.backgroundImageView.frame) + self.switchImageEdgeInsets.left, 0, self.switchImage.size.width, self.switchImage.size.height);
    
    [self.switchImageView setFrame:ME_CGRectCenterY(kSwitchImageViewFrame, self.backgroundImageView.frame)];
    
    CGSize const kOffTitleSize = [self _offTitleSize];
    
    [self.offLabel setFrame:ME_CGRectCenterY(CGRectMake(CGRectGetMinX(self.backgroundImageView.frame) - kOffTitleSize.width, 0, kOffTitleSize.width, kOffTitleSize.height), self.bounds)];
    
    CGSize const kOnTitleSize = [self _onTitleSize];
    
    [self.onLabel setFrame:ME_CGRectCenterY(CGRectMake(CGRectGetMaxX(self.backgroundImageView.frame), 0, kOnTitleSize.width, kOnTitleSize.height), self.bounds)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize const kOnTitleSize = [self _onTitleSize];
    CGSize const kOffTitleSize = [self _offTitleSize];
    
    return CGSizeMake(kOffTitleSize.width + MAX(self.backgroundImage.size.width, size.width) + kOnTitleSize.width, MAX(MAX(self.backgroundImage.size.height, kOffTitleSize.height), size.height));
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERSwitch_init];
    
    return self;
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO animations:nil completion:nil];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated; {
    [self setOn:on animated:animated animations:nil completion:nil];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated completion:(void (^)(void))completion; {
    [self setOn:on animated:animated animations:nil completion:completion];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion; {
    [self willChangeValueForKey:@"on"];
    _on = on;
    [self didChangeValueForKey:@"on"];
    
    @weakify(self);
    
    [self setNeedsLayout];
    
    [UIView animateWithDuration:(animated) ? MERSwitchAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
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

- (UIFont *)onOffFont {
    return (_onOffFont) ?: [UIFont systemFontOfSize:14];
}
- (UIColor *)onOffTextColor {
    return (_onOffTextColor) ?: [UIColor blackColor];
}
- (UIColor *)onOffHighlightedTextColor {
    return (_onOffHighlightedTextColor) ?: [UIColor darkGrayColor];
}
- (UIColor *)onOffShadowColor {
    return (_onOffShadowColor) ?: [UIColor lightGrayColor];
}
#pragma mark *** Private Methods ***
- (void)_MERSwitch_init; {
    [self setBackgroundImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.backgroundImageView];
    
    [self setSwitchImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.switchImageView];
    
    [self setOnLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.onLabel];
    
    [self setOffLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.offLabel];
    
    RACChannelTo(self.backgroundImageView,image) = RACChannelTo(self,backgroundImage);
    RACChannelTo(self.backgroundImageView,highlighted) = RACChannelTo(self,highlighted);
    RACChannelTo(self.backgroundImageView,highlightedImage) = RACChannelTo(self,highlightedBackgroundImage);
    
    RACChannelTo(self.switchImageView,image) = RACChannelTo(self,switchImage);
    RACChannelTo(self.switchImageView,highlighted) = RACChannelTo(self,highlighted);
    RACChannelTo(self.switchImageView,highlightedImage) = RACChannelTo(self,highlightedSwitchImage);
    
    RACChannelTo(self.onLabel,highlighted) = RACChannelTo(self, on);
    RACChannelTo(self.onLabel,font) = RACChannelTo(self,onOffFont);
    RACChannelTo(self.onLabel,textColor) = RACChannelTo(self,onOffTextColor);
    RACChannelTo(self.onLabel,highlightedTextColor) = RACChannelTo(self,onOffHighlightedTextColor);
    RACChannelTo(self.onLabel,shadowColor) = RACChannelTo(self,onOffShadowColor);
    RACChannelTo(self.onLabel,text) = RACChannelTo(self,onTitle);
    
    RAC(self.offLabel,highlighted) = [RACObserve(self, on) not];
    RACChannelTo(self.offLabel,font) = RACChannelTo(self,onOffFont);
    RACChannelTo(self.offLabel,textColor) = RACChannelTo(self,onOffTextColor);
    RACChannelTo(self.offLabel,highlightedTextColor) = RACChannelTo(self,onOffHighlightedTextColor);
    RACChannelTo(self.offLabel,shadowColor) = RACChannelTo(self,onOffShadowColor);
    RACChannelTo(self.offLabel,text) = RACChannelTo(self,offTitle);
    
    @weakify(self);
    
    [[[RACObserve(self, switchImageEdgeInsets)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
    
    [[[RACObserve(self, onOffFont)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
    
    [[[RACObserve(self, onTitle)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
    
    [[[RACObserve(self, offTitle)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
     }];
    
    [[[RACObserve(self, onOffShadowOffset)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSValue *value) {
         @strongify(self);
         
         [self.onLabel setShadowOffset:value.CGSizeValue];
         [self.offLabel setShadowOffset:value.CGSizeValue];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [[tapGestureRecognizer rac_gestureSignal]
     subscribeNext:^(UITapGestureRecognizer *gestureRecognizer) {
         @strongify(self);
         
         [self setOn:!self.isOn animated:YES completion:^{
             @strongify(self);
             
             [self sendActionsForControlEvents:UIControlEventValueChanged];
         }];
    }];
    
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (CGSize)_onTitleSize; {
    return ME_CGSizeIntegral([self.onTitle sizeWithAttributes:@{NSFontAttributeName: self.onOffFont}]);
}
- (CGSize)_offTitleSize; {
    return ME_CGSizeIntegral([self.offTitle sizeWithAttributes:@{NSFontAttributeName: self.onOffFont}]);
}

@end
