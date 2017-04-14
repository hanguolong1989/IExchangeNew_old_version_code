//
//  CTArray+NSArray.h
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(CTArray)

- (id)nextObjectAtIndexCT:(NSUInteger)index;

- (id)lastObjectAtIndexCT:(NSUInteger)index;

- (id)firstObjectAtIndexCT:(NSUInteger)index;

- (id)objectAtIndexCT:(NSUInteger)index;

- (NSString *)JSONStringCT;

@end
