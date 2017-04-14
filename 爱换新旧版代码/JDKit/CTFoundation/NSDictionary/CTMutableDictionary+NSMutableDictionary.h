//
//  CTMutableDictionary+NSMutableDictionary.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/22.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(CTMutableDictionary)


- (NSString *)stringForKey:(id)aKey;

- (NSInteger)integerForKey:(id)aKey;

- (int)intForKey:(id)aKey;

- (double)doubleForKey:(id)aKey;

- (BOOL)boolForKey:(id)aKey;


@end
