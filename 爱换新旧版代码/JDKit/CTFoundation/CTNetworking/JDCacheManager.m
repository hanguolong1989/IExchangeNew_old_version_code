//
//  JDCacheManager.m
//  MusicApp
//
//  Created by Hind on 16/3/10.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "JDCacheManager.h"


@implementation JDCacheManager

+ (JDCacheManager *)instance
{
    static JDCacheManager *_instance;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[JDCacheManager alloc] init];
        
        [JDSQLManager executeUpdate:@"CREATE TABLE IF NOT EXISTS pc_http_cache(_uri text PRIMARY KEY,_path text, _content_length integer, _policy integer, _date integer,_max_age integer, _modifyDate integer, _lastModified text)"];

    });
    return _instance;
}

- (dispatch_queue_t )getCacheOperatorQueue{
    //新建一个队列，专门负责异步缓存读写
    static dispatch_queue_t  _cacheOperatorQueue;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _cacheOperatorQueue = dispatch_queue_create([@"cn.com.hind.cacheOperatorQueue" UTF8String], NULL);
    });
    return _cacheOperatorQueue;
}


#pragma mark - 缓存路径
+ (NSString *)cachePath {
    NSArray  *paths2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths2 objectAtIndex:0] stringByAppendingString:@"/http_cache/"];

}

+ (NSString *)cachePath:(NSString *)relaPath
{
    // nil 安全判断，否则crash：by limingjiu
    if (relaPath != nil) {
        return [[self cachePath] stringByAppendingString:relaPath];
    }
    return nil;
}

+ (NSString *)tmpPath_YearMonth_DayHourMin:(NSString *)file
{
    time_t _time;
    time(&_time);
    struct tm _tm;
    localtime_r(&_time, &_tm);
    return [NSString stringWithFormat:@"%d%02d/%02d%02d/%@",
            _tm.tm_year + 1900, _tm.tm_mon + 1,
            _tm.tm_mday, _tm.tm_hour, file];
    //    return [NSString stringWithFormat:@"%d%02d/%02d%02d%02d/%@",
    //            _tm.tm_year + 1900, _tm.tm_mon + 1,
    //            _tm.tm_mday, _tm.tm_hour, _tm.tm_min, file];
}


+ (NSCache *)getMemoryCache{
    static NSCache *_memCache;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _memCache = [[NSCache alloc] init];
        _memCache.totalCostLimit = 1024*1024*10;//设置10兆的内存缓存作为二级缓存，先读内存，内存没用再读文件
    });
    return _memCache;
}

#pragma mark - 读写缓存
- (JDCacheModel *)getCacheWithLikeUri:(NSString *) url
{
    NSString *sql = [NSString stringWithFormat:@"select * from pc_http_cache where _uri like '%%%@%%';", url];
    
    NSArray *dictList = [JDSQLManager listForQuerySql:sql];
    
    NSDictionary *dict = [dictList firstObject];
    
    if (dict == nil) {
        return nil;
    }
    
    JDCacheModel *meta = [[JDCacheModel alloc] initWithDictionary:dict];
    NSString *cachePath = [JDCacheManager cachePath:meta.path];
    if (cachePath == nil) {
        return nil;
    }
    
    // read file
    //如果读取不到数据，那就把缓存删除
    if (!meta.data) {
        [JDSQLManager executeUpdate:@"delete from pc_http_cache where _uri = ?", meta.uri];
        return nil;
    } else
    {
        //更新使用缓存的时间
        [JDSQLManager executeUpdate:@"update pc_http_cache set _modifyDate = ? where _uri = ?",
         @([NSDate currentTimeInterval]), meta.uri];
    }
    
    return meta;
}


- (void)putCache:(AFHTTPRequestOperation *)httpResult withCachePolicy:(JDHttpClientCachePolicy)cachePolicy
{
    
    dispatch_async([self getCacheOperatorQueue], ^(){//异步写缓存 框架v2.0新增异步
        if (![@"GET" isEqualToString:[httpResult.request HTTPMethod]]) {
            return;
        }
        
        NSString *uri = httpResult.request.URL.absoluteString;
        NSString *lastModified = [self lastModifiedWithOperation:httpResult];
        NSInteger maxAge = [self getMaxAgeWithOperation:httpResult];

        [self saveMemoryCache:httpResult];//保存一下内存缓存
        NSDictionary *dict = [JDSQLManager objectForQuerySql:@"select * from pc_http_cache where _uri = ?", uri];
        NSString *path = nil;
        if (dict) {
            //本来已经有存在缓存的，更新缓存数据
            int _cachePolicy = [[dict objectForKey:@"_policy"] intValue];
            
            [JDSQLManager executeUpdate:@"update pc_http_cache set _date = ?, _max_age = ?, _content_length = ?, _policy = ?, _modifyDate = ?, _lastModified = ? where _uri = ?",
             @([NSDate currentTimeInterval]),
             @(maxAge),
             @(httpResult.responseData.length),
             @(_cachePolicy),
             @([NSDate currentTimeInterval]),
             lastModified,
             uri];
            path = [dict objectForKey:@"_path"];
            
        }else
        {
            //没有缓存过的，新建缓存数据
            path = [JDCacheManager tmpPath_YearMonth_DayHourMin:[uri md5]];
            [JDSQLManager executeUpdate:@"insert into pc_http_cache(_uri, _path,_max_age, _date , _content_length, _policy,_modifyDate,_lastModified) values (?,?,?,?,?,?,?,?) ",
             uri,
             path,
             @(maxAge),
             @([NSDate currentTimeInterval]),
             @(httpResult.responseData.length),
             @(cachePolicy),
             @([NSDate currentTimeInterval]),
             lastModified];
        }
        
        //建立对应的缓存数据文件
        NSString *fullPath = [JDCacheManager cachePath:path];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dir = [fullPath stringByDeletingLastPathComponent];
        BOOL isDir = NO;
        if (![fileManager fileExistsAtPath:dir isDirectory:&isDir] || !isDir) {
            [fileManager createDirectoryAtPath:dir
                   withIntermediateDirectories:true
                                    attributes:nil
                                         error:nil];
        }
        
        //    [_lock lock];//在串行队列里执行就不用加锁了
        BOOL writeOk = [httpResult.responseData writeToFile:fullPath
                                                 atomically:YES];
        //    [_lock unlock];
        //如果写入文件失败，则删除对应的缓存数据
        if (!writeOk && ![fileManager fileExistsAtPath:fullPath]) {
            [JDSQLManager executeUpdate:@"delete from pc_http_cache where _uri = ?", uri];
        }
    });
}


//将数据写入内存缓存
- (void)saveMemoryCache:(AFHTTPRequestOperation *)pcHttpRequestResult
{
    NSString *uri = pcHttpRequestResult.request.URL.absoluteString;
    if (pcHttpRequestResult==nil ||uri==nil){
        return;
    }
    
    if (pcHttpRequestResult.responseData.length >1024*1024*1){//大于一兆的数据就不要放进内存缓存了,不然内存紧张会崩溃)
        return;
    }
    NSString *contentType = [pcHttpRequestResult.response.allHeaderFields objectForKey:@"Content-Type"];
    NSCache *memCache = [JDCacheManager getMemoryCache];
    
    if([[contentType lowercaseString] rangeOfString:@"image"].location != NSNotFound) {
        //对于jpg,png图片，将data转为uiimage再存到内存缓存，不用每次获时再执行imageWithData这个非常耗时的操作。
        if (pcHttpRequestResult.responseData != nil){
            @try {
                UIImage *image = [UIImage imageWithData:pcHttpRequestResult.responseData];
                NSInteger dataSize = image.size.width*image.size.height*image.scale;
                [memCache setObject:image forKey:uri cost:dataSize];
            }
            @catch (NSException *exception) {
                NSLog(@"exception=%@",exception);
            }
        }
    }else{
        NSInteger dataSize = pcHttpRequestResult.responseData.length;
        [memCache setObject:pcHttpRequestResult forKey:uri cost:dataSize];
    }
}


- (NSInteger)getMaxAgeWithOperation:(AFHTTPRequestOperation *)operation
{
    if (operation.response == nil) {
        return -1;
    }
    NSDictionary *headers = [operation.response allHeaderFields];
    
    NSUInteger _date;
    NSInteger _maxAge = 0;
    
    NSString *date = [headers objectForKey:@"Date"];
    if (date) {
        // use Date header
        _date = [NSDate httpDateWithHeader:date];
        
    } else {
        // set now
        _date = [NSDate currentTimeInterval];
    }
    
    NSString *cacheControl = [headers objectForKey:@"Cache-Control"];
    
    if (cacheControl && [cacheControl hasPrefix:@"max-age="]) {
        // use Cache-Control: max-age=seconds header
        _maxAge = [[cacheControl substringFromIndex:8] intValue];
    } else {
        // use Expires header
        NSString * expires = [headers objectForKey:@"Expires"];
        if (expires) {
            NSUInteger exp = [NSDate httpDateWithHeader:expires];
            _maxAge = exp - _date;
        }
    }
    return _maxAge;
}

- (NSString *)lastModifiedWithOperation:(AFHTTPRequestOperation *)operation
{
    NSDictionary *headers = [operation.response allHeaderFields];
    NSString *lastModified = [headers objectForKey:@"Last-Modified"];
    return lastModified;
}


@end
