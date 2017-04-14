//
//  CTArray+NSArray.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 CT. All rights reserved.
//

#import "CTArray+NSArray.h"

@implementation NSArray(CTArray)

- (id)nextObjectAtIndexCT:(NSUInteger)index
{
    if (index + 2 > [self count])
    {
        return nil;
    }else
    {
        return [self objectAtIndex:index + 1];
    }
}

- (id)lastObjectAtIndexCT:(NSUInteger)index
{
    if (index < 1 || index >= [self count])
    {
        return nil;
    }else
    {
        return [self objectAtIndex:index - 1];
    }
}

- (id)firstObjectAtIndexCT:(NSUInteger)index
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:0];
    }
    return nil;
}

- (id)objectAtIndexCT:(NSUInteger)index
{
    if ([self count] > index)
    {
        return [self objectAtIndex:index];
    }
    return nil;
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


@end
