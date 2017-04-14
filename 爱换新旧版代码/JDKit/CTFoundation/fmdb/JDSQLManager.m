//
//  JDSQLManager.m
//  MusicApp
//
//  Created by Hind on 16/3/1.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "JDSQLManager.h"

@interface JDSQLManager ()

/**
 获取FMDatabase单例
 @returns 返回一个FMDatabase
 */
+ (FMDatabase *) getDB;


@end

@implementation JDSQLManager

+ (FMDatabase *) getDB
{
    static FMDatabase *_db;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"/jd.db"];
        NSLog(@"writableDBPath:%@",writableDBPath);
        _db = [FMDatabase databaseWithPath:writableDBPath];
        if (![_db openWithserializedMode]) {//使用多线程串行方式打开数据库，修改了第三方库fmdatabase的代码
            NSLog(@"Could not open db.");
        }
    });
    return _db;
}


#pragma mark Public static methods

+ (NSDictionary *) objectForQuerySql:(NSString *)sql, ...
{
    __block FMResultSet *rs;
    va_list args;
    va_start(args, sql);
    rs = [[self getDB] executeQuery:sql withVAList:args];
    va_end(args);
    if (rs && [rs next]) {
        NSDictionary *resultDic = [rs resultDictionary];
        [rs close];
        return resultDic;
    }
    return nil;
}

+ (NSArray *) listForQuerySql:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    __block FMResultSet *rs;
    rs = [[self getDB] executeQuery:sql withVAList:args];
    va_end(args);
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    while (rs && [rs next]) {
        NSDictionary *resultDic = [rs resultDictionary];
        [mArray addObject:resultDic];
    }
    [rs close];
    return mArray;
}

+ (BOOL)executeUpdate:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);
    __block BOOL result;
    result = [[self getDB] executeUpdate:sql withVAList:args];
    va_end(args);
    return result;
}



#pragma mark Simple Methods


#define RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(type, sel)             \
va_list args;                                                        \
va_start(args, query);                                               \
__block FMResultSet *resultSet;                                      \
resultSet = [[self getDB] executeQuery:query withVAList:args];       \
va_end(args);                                                        \
if (resultSet && ![resultSet next]) { return (type)0; }              \
type ret = [resultSet sel:0];                                        \
[resultSet close];                                                   \
[resultSet setParentDB:nil];                                         \
return ret;

+ (NSString*)stringForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSString *, stringForColumnIndex);
}

+ (int)intForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(int, intForColumnIndex);
}

+ (long)longForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(long, longForColumnIndex);
}

+ (BOOL)boolForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(BOOL, boolForColumnIndex);
}

+ (double)doubleForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(double, doubleForColumnIndex);
}

+ (NSData*)dataForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSData *, dataForColumnIndex);
}

+ (NSDate*)dateForQuery:(NSString*)query, ... {
    RETURN_RESULT_FOR_QUERY_WITH_SELECTOR(NSDate *, dateForColumnIndex);
}



@end
