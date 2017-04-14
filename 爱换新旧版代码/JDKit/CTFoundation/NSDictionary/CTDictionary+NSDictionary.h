//
//  CTDictionary+NSDictionary.h
//  GZCT
//
//  Created by NewMBP1 on 15/6/30.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(CTDictionary)

- (NSString *)stringForKey:(id)aKey;

- (NSInteger)integerForKey:(id)aKey;

- (int)intForKey:(id)aKey;

- (double)doubleForKey:(id)aKey;

- (BOOL)boolForKey:(id)aKey;

+ (NSDictionary *)httpParametersWithUri:(NSString *)uri;

- (NSString *)JSONStringCT;

//如果key值是数字，转换成JSON字符串时会出错
- (NSDictionary *)changeKeyToString;

- (NSMutableString *)dictionaryToQueryString;

@end
