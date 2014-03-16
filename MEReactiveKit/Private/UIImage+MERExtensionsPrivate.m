//
//  UIImage+MERExtensions.m
//  MEReactiveKit
//
//  Created by William Towe on 11/18/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIImage+MERExtensionsPrivate.h"

@implementation UIImage (MERExtensionsPrivate)

- (CGSize)MER_size; {
    CGSize size = [self size];
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

+ (UIImage *)MER_imageByTintingImage:(UIImage *)image color:(UIColor *)color; {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [color setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, image.size.width, image.size.height), kCGBlendModeSourceAtop);
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIImage *)MER_tintedImageWithColor:(UIColor *)color; {
    return [self.class MER_imageByTintingImage:self color:color];
}

+ (UIImage *)MER_imageWithImage:(UIImage *)image alpha:(CGFloat)alpha; {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIImage *)MER_imageWithAlpha:(CGFloat)alpha; {
    return [self.class MER_imageWithImage:self alpha:alpha];
}

@end
