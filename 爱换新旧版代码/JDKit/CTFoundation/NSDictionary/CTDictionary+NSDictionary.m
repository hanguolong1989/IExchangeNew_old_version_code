//
//  CTDictionary+NSDictionary.m
//  GZCT
//
//  Created by NewMBP1 on 15/6/30.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTDictionary+NSDictionary.h"

@implementation NSDictionary(CTDictionary)

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

- (NSDictionary *)changeKeyToString {
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    for (NSString *tmpKey in self.allKeys) {
        NSString *value = [self objectForKey:tmpKey];
        NSString *key = [NSString stringWithFormat:@"%@", tmpKey];
        [newDictionary setObject:value forKey:key];
    }
    return newDictionary;
}

+ (NSDictionary *)httpParametersWithUri:(NSString *)uri
{
    NSRange pos = [uri rangeOfString:@"?"];
    if (pos.location == NSNotFound)
        return nil;
    
    return [NSDictionary httpParametersWithFormEncodedData:[uri substringFromIndex:pos.location + 1]];
}

+ (NSDictionary *)httpParametersWithFormEncodedData:(NSString *)formData
{
    NSArray *params = [formData componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString * param in params) {
        NSArray *pv = [param componentsSeparatedByString:@"="];
        NSString *v = @"";
        if ([pv count] == 2) {
            NSString *string = [pv objectAtIndex:1];
            v = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                      kCFAllocatorDefault,
                                                                                      (CFStringRef)string,
                                                                                      CFSTR(""),
                                                                                      kCFStringEncodingUTF8));
        }
        
        [result setObject:v forKey:[pv objectAtIndex:0]];
    }
    
    return result;
}


- (NSString *)JSONStringCT {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (nil == parseError) {
        NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
        return result;
    } else {
        return @"";
    }
}

- (NSMutableString *)dictionaryToQueryString {
    NSMutableString *queryString = [NSMutableString string];
    
    NSInteger count = self.allKeys.count;
    for (int i = 0; i < count; i++) {
        NSString *key = [self.allKeys objectAtIndex:i];
        NSObject *value = [self objectForKey:key];
        
        [queryString appendFormat:@"%@=%@", key, value];
        if (i + 1 < count) {
            [queryString appendFormat:@"&"];
        }
    }
    
    return queryString;
}

@end
