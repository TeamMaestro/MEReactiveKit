//
//  NSMutableDictionary+MERExtensions.m
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

#import "NSMutableDictionary+MERKExtensions.h"

@implementation NSMutableDictionary (MERKExtensions)

- (id)MER_objectForState:(UIControlState)state; {
    id retval = self[@(state)];
    
    if (!retval) {
        if (state & UIControlStateDisabled)
            retval = self[@(UIControlStateDisabled)];
        
        if (!retval && (state & UIControlStateSelected))
            retval = self[@(UIControlStateSelected)];
        
        if (!retval && (state & UIControlStateHighlighted))
            retval = self[@(UIControlStateHighlighted)];
        
        if (!retval)
            retval = self[@(UIControlStateNormal)];
    }
    
    return retval;
}
- (void)MER_setObject:(id)object forState:(UIControlState)state; {
    if (object)
        [self setObject:object forKey:@(state)];
    else
        [self removeObjectForKey:@(state)];
}

@end
