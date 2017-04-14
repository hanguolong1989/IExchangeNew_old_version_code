//
//  CTNumber+NSNumber.m
//  GZCT
//
//  Created by Hind on 16/5/16.
//  Copyright © 2016年 PC. All rights reserved.
//

#import "CTNumber+NSNumber.h"



@implementation NSNumber(PCNULL)

- (BOOL)isEqualToString:(NSString *)aString {
    NSString *selfString = [NSString stringWithFormat:@"%@", self];
    return [selfString isEqualToString:aString];
}

- (NSUInteger)length {
    return [[self description] length];
}

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet {
    return [[self description] rangeOfCharacterFromSet:aSet];
}

- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context {
    return [[self description] boundingRectWithSize:size options:options attributes:attributes context:context];
}

- (void)drawWithRect:(CGRect)rect options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context {
    return [[self description] drawWithRect:rect options:options attributes:attributes context:context];
}

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


@end


@implementation NSString(PCNULL)

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

@end

@implementation NSArray(PCNULL)

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

@end

@implementation NSMutableArray(PCNULL)

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

@end


@implementation NSDictionary(PCNULL)

- (id)objectAtIndex:(NSUInteger)index {
    return nil;
}

- (id)objectAtIndexCT:(NSUInteger)index {
    return nil;
}

@end


@implementation NSMutableDictionary(PCNULL)

- (id)objectAtIndex:(NSUInteger)index {
    return nil;
}

- (id)objectAtIndexCT:(NSUInteger)index {
    return nil;
}

@end
