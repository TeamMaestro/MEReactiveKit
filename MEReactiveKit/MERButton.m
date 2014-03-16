//
//  MERButton.m
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

#import "MERButton.h"
#import "NSMutableDictionary+MERExtensionsPrivate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <libextobjc/EXTKeyPathCoding.h>
#import <MEFoundation/MEGeometry.h>
#import <MEFoundation/MEMacros.h>
#import "NSString+MERExtensionsPrivate.h"
#import "NSAttributedString+MERExtensionsPrivate.h"
#import "UIImage+MERExtensionsPrivate.h"
#import <MEFoundation/MEDebugging.h>

#import <objc/runtime.h>

@interface MERButton ()
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) NSMutableDictionary *controlStatesToTitles;
@property (strong,nonatomic) NSMutableDictionary *controlStatesToTitleColors;
@property (strong,nonatomic) NSMutableDictionary *controlStatesToImages;
@property (strong,nonatomic) NSMutableDictionary *controlStatesToBackgroundImages;

- (void)_MERButton_init;

+ (UIFont *)_defaultTitleFont;
@end

@implementation MERButton
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERButton_init];
    
    return self;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERButton_init];
    
    return self;
}

- (void)layoutSubviews {
    [self.backgroundImageView setFrame:self.bounds];
    
    CGSize const kTitleLabelSize = [[self titleForState:self.state] MER_sizeWithAttributes:@{NSFontAttributeName: self.titleFont}];
    CGRect titleLabelFrame = CGRectMake(0, 0, kTitleLabelSize.width, kTitleLabelSize.height);
    CGSize const kImageViewSize = [[self imageForState:self.state] MER_size];
    CGRect imageViewFrame = CGRectMake(0, 0, kImageViewSize.width, kImageViewSize.height);
    
    switch (self.titleHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentCenter:
            titleLabelFrame.origin.x = floor((CGRectGetWidth(self.bounds) * 0.5) - (kTitleLabelSize.width * 0.5));
            break;
        case UIControlContentHorizontalAlignmentLeft:
            titleLabelFrame.origin.x = self.contentEdgeInsets.left + self.titleEdgeInsets.left;
            break;
        case UIControlContentHorizontalAlignmentRight:
            titleLabelFrame.origin.x = CGRectGetWidth(self.bounds) - kTitleLabelSize.width - self.contentEdgeInsets.right - self.titleEdgeInsets.right;
            break;
        case UIControlContentHorizontalAlignmentFill:
            titleLabelFrame.size.width = CGRectGetWidth(self.bounds);
            break;
        default:
            NSAssert(NO, @"invalid title horizontal alignment %@",@(self.titleHorizontalAlignment));
            break;
    }
    
    switch (self.titleVerticalAlignment) {
        case UIControlContentVerticalAlignmentCenter:
            titleLabelFrame.origin.y = floor((CGRectGetHeight(self.bounds) * 0.5) - (kTitleLabelSize.height * 0.5));
            break;
        case UIControlContentVerticalAlignmentTop:
            titleLabelFrame.origin.y = self.contentEdgeInsets.top + self.titleEdgeInsets.top;
            break;
        case UIControlContentVerticalAlignmentBottom:
            titleLabelFrame.origin.y = CGRectGetHeight(self.bounds) - kTitleLabelSize.height - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom;
            break;
        case UIControlContentVerticalAlignmentFill:
            titleLabelFrame.size.height = CGRectGetHeight(self.bounds);
            break;
        default:
            NSAssert(NO, @"invalid title vertical alignment %@",@(self.titleVerticalAlignment));
            break;
    }
    
    switch (self.imageHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentCenter:
            imageViewFrame.origin.x = floor((CGRectGetWidth(self.bounds) * 0.5) - (kImageViewSize.width * 0.5));
            break;
        case UIControlContentHorizontalAlignmentLeft:
            imageViewFrame.origin.x = self.contentEdgeInsets.left + self.imageEdgeInsets.left;
            break;
        case UIControlContentHorizontalAlignmentRight:
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - kImageViewSize.width - self.contentEdgeInsets.right - self.imageEdgeInsets.right;
            break;
        case UIControlContentHorizontalAlignmentFill:
            imageViewFrame.size.width = CGRectGetWidth(self.bounds);
            break;
        default:
            NSAssert(NO, @"invalid image horizontal alignment %@",@(self.imageHorizontalAlignment));
            break;
    }
    
    switch (self.imageVerticalAlignment) {
        case UIControlContentVerticalAlignmentCenter:
            imageViewFrame.origin.y = floor((CGRectGetHeight(self.bounds) * 0.5) - (kImageViewSize.height * 0.5));
            break;
        case UIControlContentVerticalAlignmentTop:
            imageViewFrame.origin.y = self.contentEdgeInsets.top + self.imageEdgeInsets.top;
            break;
        case UIControlContentVerticalAlignmentBottom:
            imageViewFrame.origin.y = CGRectGetHeight(self.bounds) - kImageViewSize.height - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom;
            break;
        case UIControlContentVerticalAlignmentFill:
            imageViewFrame.size.height = CGRectGetHeight(self.bounds);
            break;
        default:
            NSAssert(NO, @"invalid image vertical alignment %@",@(self.imageVerticalAlignment));
            break;
    }
    
    if (self.titleHorizontalAlignment == UIControlContentHorizontalAlignmentCenter &&
        self.imageHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) {
        
        imageViewFrame.origin.x = floor((CGRectGetWidth(self.bounds) * 0.5) - ((kTitleLabelSize.width + kImageViewSize.width + self.imageEdgeInsets.right + self.titleEdgeInsets.left) * 0.5));
        titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + self.imageEdgeInsets.right + self.titleEdgeInsets.left;
    }
    
    [self.titleLabel setFrame:titleLabelFrame];
    [self.imageView setFrame:imageViewFrame];
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeZero;
    CGSize const kTitleSize = [[self titleForState:UIControlStateNormal] MER_sizeWithAttributes:@{NSFontAttributeName: self.titleFont}];
    CGSize const kImageSize = [[self imageForState:UIControlStateNormal] MER_size];
    CGSize const kBackgroundImageSize = [[self backgroundImageForState:UIControlStateNormal] MER_size];
    CGSize const kContentSize = CGSizeMake(kTitleSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right + kImageSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right + self.contentEdgeInsets.left + self.contentEdgeInsets.right, MAX(kTitleSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom, kImageSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom) + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    
    retval.width = MAX(kBackgroundImageSize.width, kContentSize.width);
    retval.height = MAX(kBackgroundImageSize.height, kContentSize.height);
    
    return CGSizeMake(MAX(retval.width, size.width), MAX(retval.height, size.height));
}
#pragma mark *** Public Methods ***
#pragma mark Appearance
- (NSString *)titleForState:(UIControlState)state {
    return [self.controlStatesToTitles MER_objectForState:state];
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self.controlStatesToTitles MER_setObject:title forState:state];
    
    if (self.state == state) {
        [self.titleLabel setText:[self titleForState:self.state]];
        
        [self setNeedsLayout];
    }
}

- (UIColor *)titleColorForState:(UIControlState)state {
    return [self.controlStatesToTitleColors MER_objectForState:state];
}
- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state {
    [self.controlStatesToTitleColors MER_setObject:titleColor forState:state];
}

- (UIImage *)imageForState:(UIControlState)state {
    return [self.controlStatesToImages MER_objectForState:state];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [self.controlStatesToImages MER_setObject:image forState:state];
}

- (UIImage *)backgroundImageForState:(UIControlState)state {
    return [self.controlStatesToBackgroundImages MER_objectForState:state];
}
- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state {
    [self.controlStatesToBackgroundImages MER_setObject:backgroundImage forState:state];
}
#pragma mark Properties
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = (titleFont) ?: [self.class _defaultTitleFont];
}
#pragma mark *** Private Methods ***
- (void)_MERButton_init; {
    _titleFont = [self.class _defaultTitleFont];
    
    [self setBackgroundImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.backgroundImageView];
    
    [self setImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.imageView];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setNumberOfLines:0];
    [self addSubview:self.titleLabel];
    
    [self setControlStatesToTitles:[[NSMutableDictionary alloc] init]];
    [self setControlStatesToTitleColors:[[NSMutableDictionary alloc] init]];
    [self setControlStatesToImages:[[NSMutableDictionary alloc] init]];
    [self setControlStatesToBackgroundImages:[[NSMutableDictionary alloc] init]];
    
    [self setAdjustsImageWhenHighlighted:YES];
    [self setAdjustsImageWhenDisabled:YES];
    
    RACChannelTo(self.titleLabel,font) = RACChannelTo(self,titleFont);
    
    @weakify(self);
    
    [[self rac_valuesAndChangesForKeyPath:@keypath(self,controlStatesToTitles) options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew observer:nil]
     subscribeNext:^(RACTuple *tuple) {
         MELogObject(tuple);
    }];
    
    [[[RACSignal combineLatest:@[[RACObserve(self, enabled) distinctUntilChanged],
                                 [RACObserve(self, highlighted) distinctUntilChanged],
                                 [RACObserve(self, selected) distinctUntilChanged]]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self);
         
         RACTupleUnpack(NSNumber *enabled, NSNumber *highlighted, __unused NSNumber *selected) = tuple;
         
         UIImage *backgroundImage = [self backgroundImageForState:self.state];
         
         if (backgroundImage) {
             if (highlighted.boolValue && self.adjustsImageWhenHighlighted && !self.controlStatesToBackgroundImages[@(self.state)])
                 backgroundImage = [backgroundImage MER_tintedImageWithColor:[UIColor colorWithWhite:0 alpha:0.33]];
             
             if (!enabled.boolValue && self.adjustsImageWhenDisabled && !self.controlStatesToBackgroundImages[@(self.state)])
                 backgroundImage = [backgroundImage MER_imageWithAlpha:0.5];
         }
         
         [self.backgroundImageView setImage:backgroundImage];
         
         UIImage *image = [self imageForState:self.state];
         
         if (image) {
             if (highlighted.boolValue && self.adjustsImageWhenHighlighted && !self.controlStatesToImages[@(self.state)])
                 image = [image MER_tintedImageWithColor:[UIColor colorWithWhite:0 alpha:0.33]];
             
             if (!enabled.boolValue && self.adjustsImageWhenDisabled && !self.controlStatesToImages[@(self.state)])
                 image = [image MER_imageWithAlpha:0.5];
         }
         
         [self.imageView setImage:image];
         
         [self.titleLabel setText:[self titleForState:self.state]];
         
         [self.titleLabel setTextColor:[self titleColorForState:self.state]];
    }];
    
    [[[RACSignal merge:@[[RACObserve(self, contentEdgeInsets) distinctUntilChanged],
                         [RACObserve(self, titleEdgeInsets) distinctUntilChanged],
                         [RACObserve(self, imageEdgeInsets) distinctUntilChanged],
                         [RACObserve(self, titleFont) distinctUntilChanged]]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
}

+ (UIFont *)_defaultTitleFont {
    return [UIFont systemFontOfSize:17];
}

@end

static void const *MERButtonRACCommandKey = &MERButtonRACCommandKey;
static void const *MERButtonEnabledDisposableKey = &MERButtonEnabledDisposableKey;

@implementation MERButton (RACCommandSupport)

- (RACCommand *)rac_command {
	return objc_getAssociatedObject(self, MERButtonRACCommandKey);
}

- (void)setRac_command:(RACCommand *)command {
	objc_setAssociatedObject(self, MERButtonRACCommandKey, command, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	// Check for stored signal in order to remove it and add a new one
	RACDisposable *disposable = objc_getAssociatedObject(self, MERButtonEnabledDisposableKey);
	[disposable dispose];
	
	if (command == nil) return;
	
	disposable = [command.enabled setKeyPath:@keypath(self.enabled) onObject:self];
	objc_setAssociatedObject(self, MERButtonEnabledDisposableKey, disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	[self rac_hijackActionAndTargetIfNeeded];
}

- (void)rac_hijackActionAndTargetIfNeeded {
	SEL hijackSelector = @selector(rac_commandPerformAction:);
	
	for (NSString *selector in [self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside]) {
		if (hijackSelector == NSSelectorFromString(selector)) {
			return;
		}
	}
	
	[self addTarget:self action:hijackSelector forControlEvents:UIControlEventTouchUpInside];
}

- (void)rac_commandPerformAction:(id)sender {
	[self.rac_command execute:sender];
}

@end
