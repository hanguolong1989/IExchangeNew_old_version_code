//
//  CTDate.h
//  GZCT
//
//  Created by NewMBP1 on 15/6/9.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(CTDate)

- (NSString *)dateStringWithFormat:(NSString *)formatString;
+ (NSDate *)dateWithFormatString:(NSString *)formatString dateString:(NSString *)dateString;

+ (NSString *)transformDateTime:(NSTimeInterval)time withFormate:(NSString *)formate;
/**
 *  返回当前时间戳
 *
 *  @return 当前时间戳
 */
+ (NSTimeInterval)currentTimeInterval;

@end


@interface NSDate(HTTP)

+ (NSString *)headerWithHttpDate:(NSUInteger)httpDate;

+ (NSUInteger)httpDateWithHeader:(NSString *)header;

@end