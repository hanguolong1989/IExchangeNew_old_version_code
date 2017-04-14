//
//  CTMutableDictionary+NSMutableDictionary.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/22.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTMutableDictionary+NSMutableDictionary.h"

@implementation NSMutableDictionary(CTMutableDictionary)

- (NSString *)stringForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return @"";
}

- (NSInteger)integerForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }
    return 0;
}

- (int)intForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (double)doubleForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}



- (BOOL)boolForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}


@end
