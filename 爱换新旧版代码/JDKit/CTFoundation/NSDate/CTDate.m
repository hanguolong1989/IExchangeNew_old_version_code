//
//  CTDate.m
//  GZCT
//
//  Created by NewMBP1 on 15/6/9.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTDate.h"

@implementation NSDate(CTDate)

- (NSString *)dateStringWithFormat:(NSString *)formatString {
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:formatString];
    return  [customDateFormatter stringFromDate:self];
}


+ (NSDate *)dateWithFormatString:(NSString *)formatString dateString:(NSString *)dateString {
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:formatString];
    return  [customDateFormatter dateFromString:dateString];
}

+ (NSString *)transformDateTime:(NSTimeInterval)time withFormate:(NSString *)formate
{
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeInterval dateDif = [now timeIntervalSinceDate:date];
    if (dateDif < 60)
    {
        return [NSString stringWithFormat:@"%d秒前", (int)fmaxf(dateDif, 0)];
    }
    else if (dateDif < 900) {
        int minute = dateDif / 60;
        return [NSString stringWithFormat:@"%d分钟前", minute];
    } else if (dateDif >= 900 && dateDif <= 1800) {
        return @"半小时前";
    } else if (dateDif > 1800 && dateDif <= 3600) {
        return @"1小时前";
    } else if (dateDif > 3600 && dateDif <= 3600*24) {
        int hour = dateDif / 3600;
        return [NSString stringWithFormat:@"%d小时前", hour];
    } else if (dateDif > 3600*24 && dateDif <= 3600*48) {
        return @"昨天";
    } else if (dateDif > 3600*48 && dateDif <= 3600*72) {
        return @"前天";
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:formate];
        NSString *formatterStr = [formatter stringFromDate:date];
        return formatterStr;
    }
}

+ (NSTimeInterval)currentTimeInterval
{
    return CFAbsoluteTimeGetCurrent();
}

@end



@implementation NSDate(HTTP)


const static NSUInteger SECONDS_YEAR1970_TO_YEAR_2001 = 978307200;
+ (NSString *)headerWithHttpDate:(NSUInteger)httpDate
{
    @synchronized(self){
        char str[32];
        struct tm *_tm;
        memset(&_tm, 0, sizeof(_tm));
        long _nowDate = httpDate + SECONDS_YEAR1970_TO_YEAR_2001;
        _tm = gmtime(&_nowDate);
        const char *formatString = "%a, %d %b %Y %H:%M:%S GMT";
        strftime(str, sizeof(str), formatString, _tm);
        return [NSString stringWithUTF8String:str];
    }
}

+ (NSUInteger)httpDateWithHeader:(NSString *)header
{
    @synchronized(self){
        if (!header) {
            return 0;
        }
        struct tm _tm;
        memset(&_tm, 0, sizeof(_tm));
        const char *formatString = "%a, %d %b %Y %H:%M:%S GMT";
        //strptime([header cStringUsingEncoding:NSASCIIStringEncoding], formatString, &_tm);
        if (!strptime([header UTF8String], formatString, &_tm)){
            return 0;
        }
        return timegm(&_tm) - SECONDS_YEAR1970_TO_YEAR_2001;
    }
}

@end


