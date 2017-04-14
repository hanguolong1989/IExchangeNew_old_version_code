//
//  JDSQLManager.h
//  MusicApp
//
//  Created by Hind on 16/3/1.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JDSQLManager : NSObject

/**
	执行查询SQL语句，如果有数据则返回一条数据，用NSDictionary封装key表示字段名称，value表示字段值，否则返回nil
	@param sql 查询SQL语句
	@returns 返回一条数据或nil
 */
+ (NSDictionary *) objectForQuerySql:(NSString *)sql, ...;

/**
	执行查询SQL语句，如果有数据则返回多条数据，用NSArray封装，每条数据再用NSDictionary封装，同上，否则返回nil
	@param sql 查询SQL语句
	@returns 返回多条数据或nil
 */
+ (NSArray *) listForQuerySql:(NSString *)sql, ...;

/**
	执行一条sql语句，执行成功返回YES，否则返回NO
	@param sql sql语句命令，delete，update等
	@returns YES or NO
 */
+ (BOOL)executeUpdate:(NSString*)sql, ...;


/** Return `int` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `int` value.
 */

+ (int)intForQuery:(NSString*)query, ...;

/** Return `long` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `long` value.
 */

+ (long)longForQuery:(NSString*)query, ...;

/** Return `BOOL` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `BOOL` value.
 */

+ (BOOL)boolForQuery:(NSString*)query, ...;

/** Return `double` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `double` value.
 */

+ (double)doubleForQuery:(NSString*)query, ...;

/** Return `NSString` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `NSString` value.
 */

+ (NSString*)stringForQuery:(NSString*)query, ...;

/** Return `NSData` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `NSData` value.
 */

+ (NSData*)dataForQuery:(NSString*)query, ...;

/** Return `NSDate` value for query
 
 @param query The SQL query to be performed.
 @param ... A list of parameters that will be bound to the `?` placeholders in the SQL query.
 
 @return `NSDate` value.
 */

+ (NSDate*)dateForQuery:(NSString*)query, ...;

@end
