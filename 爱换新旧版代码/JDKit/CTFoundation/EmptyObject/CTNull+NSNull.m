//
//  CTNull+NSNull.m
//  GZCT
//
//  Created by Hind on 16/5/16.
//  Copyright © 2016年 PC. All rights reserved.
//

#import "CTNull+NSNull.h"

@implementation NSNull(PCNull)

- (NSString *)stringForKey:(id)aKey {
    return @"";
}

- (NSInteger)integerForKey:(id)aKey {
    return 0;
}

- (int)intForKey:(id)aKey {
    return 0;
}

- (id)objectForKey:(NSString *)anAttribute {
    return nil;
}

- (id)objectAtIndex:(NSUInteger)index {
    return nil;
}

- (id)objectAtIndexCT:(NSUInteger)index {
    return nil;
}

- (NSUInteger)count {
    return 0;
}

- (NSUInteger)length {
    return 0;
}

- (double) doubleValue {
    return 0;
}

- (float) floatValue{
    return 0;
}

- (int) intValue{
    return 0;
}

- (NSInteger) integerValue{
    return 0;
}

- (long long) longLongValue{
    return 0;
}

- (BOOL) boolValue{
    return NO;
}

- (BOOL)isEqualToString:(NSString *)aString {
    if ([aString isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet {
    NSRange range;
    range.length = 0;
    range.location = 0;
    return range;
}


- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary<NSString *, id> *)attributes context:(nullable NSStringDrawingContext *)context {
    return CGRectZero;
}

@end
