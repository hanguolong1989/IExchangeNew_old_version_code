//
//  CTNetworkClient.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/14.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTNetworkClient.h"
#import "JDCacheManager.h"
#import "CTDictionary+NSDictionary.h"
#import "CTData+NSData.h"
#import "UserData.h"

#define KEY_CHANNEL @"epapp"
#define KEY_SKEY @"pBuDsJhnkm26jC8TkgRG"

@implementation CTNetworkClient

+ (AFHTTPRequestOperation *)post:(NSString *)tmpUrlString parameters:(NSDictionary *)parameters blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure {
    
    if (tmpUrlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    NSMutableDictionary *headerField = [NSMutableDictionary dictionary];
    
    UserData *user = [UserData instance];
    if (nil != user) {
        NSString *session = user.sessionId;
        if (session.length > 0) {
            NSString *cookie = [NSString stringWithFormat:@"%@=%@", @"Session-Token", session];
            [headerField setObject:cookie forKey:@"Cookie"];
        }
    }
    
    //数字签名
    NSMutableDictionary *signParameters = [NSMutableDictionary dictionary];
    UInt64 timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    [signParameters setObject:KEY_CHANNEL forKey:@"channel"];
    [signParameters setObject:@(timestamp) forKey:@"timestamp"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithDictionary:signParameters];
    [signParameters addEntriesFromDictionary:parameters];
    
    //第一步加密
    NSString *sign = [self signWithRawparameters:signParameters needKey:YES];
    [queryParameters setObject:sign forKey:@"sign"];
    
    //组成URL参数
    NSString *queryString = [queryParameters dictionaryToQueryString];
    
    NSMutableString *queryStringUrl = [NSMutableString stringWithFormat:@"%@?%@", tmpUrlString, queryString];
    NSString *urlString = [queryStringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"发出请求:%@", queryStringUrl);
    NSLog(@"请求参数:%@", parameters);
    NSLog(@"请求头:%@", headerField);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    
    for (NSString *key in headerField.allKeys) {
        [manager.requestSerializer setValue:[headerField objectForKey:key] forHTTPHeaderField:key];

    }
    
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != success) {
                success(operation, dict);
            }
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
        
    }];
    
    return operation;
}


+ (AFHTTPRequestOperation *)postJSON:(NSString *)tmpUrlString rawParameters:(NSDictionary *)parameters
                    blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure {
    
    if (tmpUrlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    
    //数字签名
    NSMutableDictionary *signParameters = [NSMutableDictionary dictionary];
    UInt64 timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    [signParameters setObject:KEY_CHANNEL forKey:@"channel"];
    [signParameters setObject:@(timestamp) forKey:@"timestamp"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithDictionary:signParameters];
    [signParameters addEntriesFromDictionary:parameters];
    
    //第一步加密
    NSString *sign = [self signWithRawparameters:signParameters needKey:YES];
    [queryParameters setObject:sign forKey:@"sign"];
    
    //组成URL参数
    NSString *queryString = [queryParameters dictionaryToQueryString];
    
    NSString *postString = [parameters JSONStringCT];
    
    
    NSMutableString *queryStringUrl = [NSMutableString stringWithFormat:@"%@?%@", tmpUrlString, queryString];
    
    NSLog(@"发出请求:%@", queryStringUrl);
    NSLog(@"请求参数:%@", postString);

    NSURL *url = [NSURL URLWithString:[queryStringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [self requestAddSession:request];
    
    if (postString.length > 0) {
        NSData *postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postBody];

        [request setValue:[NSString stringWithFormat:@"application/json"]  forHTTPHeaderField:@"Content-Type"];
    }
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"今日要闻：%@",dict);
            if (nil != success) {
                success(operation, dict);
            }
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                failure(operation, nil, error);
            }
        }
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return operation;
}

+ (AFHTTPRequestOperation *)post:(NSString *)tmpUrlString rawParameters:(NSDictionary *)parameters blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure {
    
    if (tmpUrlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    
    //数字签名
    NSMutableDictionary *signParameters = [NSMutableDictionary dictionary];
    UInt64 timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    [signParameters setObject:KEY_CHANNEL forKey:@"channel"];
    [signParameters setObject:@(timestamp) forKey:@"timestamp"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithDictionary:signParameters];
    [signParameters addEntriesFromDictionary:parameters];
    
    //第一步加密
    NSString *sign = [self signWithRawparameters:signParameters needKey:YES];
    [queryParameters setObject:sign forKey:@"sign"];
    
    //组成URL参数
    NSString *queryString = [queryParameters dictionaryToQueryString];
    
    NSString *postString = [parameters JSONStringCT];
    
    
    NSMutableString *queryStringUrl = [NSMutableString stringWithFormat:@"%@?%@", tmpUrlString, queryString];
    
    NSLog(@"发出请求:%@", queryStringUrl);
    NSLog(@"请求参数:%@", postString);
    
    NSURL *url = [NSURL URLWithString:[queryStringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [self requestAddSession:request];
    
    if (postString.length > 0) {
        NSData *postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postBody];
        
        unsigned long long postLength = postBody.length;
        NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"CTHTTPMULTIPARTBOUNDARY"]  forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    }
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"今日要闻：%@",dict);
            if (nil != success) {
                success(operation, dict);
            }
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                failure(operation, nil, error);
            }
        }
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return operation;
}


+ (AFHTTPRequestOperation *)post:(NSString *)tmpUrlString images:(NSArray *)images parameter:(NSDictionary *)parameters blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure {
    
    if (tmpUrlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    
    //数字签名
    NSMutableDictionary *signParameters = [NSMutableDictionary dictionary];
    UInt64 timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    [signParameters setObject:KEY_CHANNEL forKey:@"channel"];
    [signParameters setObject:@(timestamp) forKey:@"timestamp"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithDictionary:signParameters];
    [signParameters addEntriesFromDictionary:parameters];
    
    //第一步加密
    NSString *sign = [self signWithRawparameters:signParameters needKey:YES];
    [queryParameters setObject:sign forKey:@"sign"];
    [queryParameters addEntriesFromDictionary:parameters];
    
    //组成URL参数
    NSString *queryString = [queryParameters dictionaryToQueryString];
    
    
    
    NSMutableString *queryStringUrl = [NSMutableString stringWithFormat:@"%@?%@", tmpUrlString, queryString];
    NSString *urlString = [queryStringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"发出请求:%@", queryStringUrl);
    NSLog(@"请求参数:%@", parameters);
    NSLog(@"上传图片:%@", images);
    
    NSMutableDictionary *headerField = [NSMutableDictionary dictionary];
    UserData *user = [UserData instance];
    if (nil != user) {
        NSString *session = user.sessionId;
        if (session.length > 0) {
            NSString *cookie = [NSString stringWithFormat:@"%@=%@", @"Session-Token", session];
            [headerField setObject:cookie forKey:@"Cookie"];
        }
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperationManager manager] POST:urlString parameters:parameters headerFields:headerField constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < images.count; i++) {
            UIImage *image = [images objectAtIndex:i];
            
            
            NSData *imageData = UIImageJPEGRepresentation(image, .6f);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", @([[NSDate date] timeIntervalSinceNow])];

            [formData appendPartWithFileData:imageData name:@"userImageData" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"今日要闻：%@",dict);
            if (nil != success) {
                success(operation, dict);
            }
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                failure(operation, nil, error);
            }
        }
    }];
    
    return operation;
}



+ (AFHTTPRequestOperation *)post2:(NSString *)urlString images:(NSArray *)images blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure {
    
    if (urlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    
    NSLog(@"发出请求:%@", urlString);
    NSLog(@"上传图片:%@", images);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [self requestAddSession:request];
    
    if (images.count > 0) {
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        for (UIImage *image in images) {
            NSData *imageData = UIImageJPEGRepresentation(image, .6f);
            [param setObject:imageData forKey:[NSDate date]];
        }
        NSData *postBody = [NSData structureMultipartHttpBodyForClub:param];
        [request setHTTPBody:postBody];
        
        unsigned long long postLength = postBody.length;
        NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"CTHTTPMULTIPARTBOUNDARY"]  forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    }
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"今日要闻：%@",dict);
            if (nil != success) {
                success(operation, dict);
            }
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                failure(operation, nil, error);
            }
        }
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return operation;
}

+ (AFHTTPRequestOperation *)get:(NSString *)urlString blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure{
    if (urlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    
    
    NSLog(@"发出请求:%@", urlString);
    //读取缓存
    JDCacheModel *cacheModel = [[JDCacheManager instance] getCacheWithLikeUri:urlString];
    if (cacheModel.data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheModel.data options:0 error:nil];
        if (nil != success) {
            success(nil, dict);
        }
        return nil;
    }

    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self requestAddSession:request];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != success) {
                success(operation, dict);
            }
            //写入缓存
            [[JDCacheManager instance] putCache:operation withCachePolicy:JDHttpClientCachePolicyHttpCache];
            
        } else {
            if (nil != failure) {
                NSError *error = [[NSError alloc] initWithDomain:@"数据为空或者数据不为UTF8" code:0 userInfo:nil];
                failure(operation, nil, error);
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                failure(operation, nil, error);
            }
        }
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return operation;
}

+ (AFHTTPRequestOperation *)download:(NSString *)urlString downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadBlock blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure {
    if (urlString.length == 0) {
        failure(nil, nil, nil);
        NSLog(@"url 为空");
        return nil;
    }
    
    
    NSLog(@"发出请求:%@", urlString);
    //读取缓存
    JDCacheModel *cacheModel = [[JDCacheManager instance] getCacheWithLikeUri:urlString];
    if (cacheModel.data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheModel.data options:0 error:nil];
        if (nil != success) {
            success(nil, dict);
        }
        return nil;
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc ]init];
    //下载地址
    NSURL *url = [NSURL URLWithString:urlString];
    //保存路径
    NSString *rootPath = [self cacheFilePath];
    NSString *filePath = [rootPath stringByAppendingPathComponent:[urlString lastPathComponent]];
    NSLog(@"下载文件%@", filePath);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    // 根据下载量设置进度条的百分比
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        downloadBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        NSString *responseString = operation.responseString;
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (nil != success) {
            success(operation, dict);
        }
        //写入缓存
        [[JDCacheManager instance] putCache:operation withCachePolicy:JDHttpClientCachePolicyHttpCache];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败！%@",error);
        NSString *responseString = operation.responseString;
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (nil != failure) {
                failure(operation, dict, error);
            }
        } else {
            if (nil != failure) {
                failure(operation, nil, error);
            }
        }
    }];


    //开始下载
    [queue addOperation:operation];
    
    return operation;
}

+ (NSString *)cacheFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSMutableURLRequest *)requestAddSession:(NSMutableURLRequest *)request {
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        UserData *user = [UserData instance];
        if (0 < user.sessionId.length) {
            NSString *session = user.sessionId;
            if (session.length > 0) {
                NSString *cookie = [NSString stringWithFormat:@"%@=%@", @"Session-Token", session];
                [request setValue:cookie forHTTPHeaderField:@"Cookie"];
            }
        }
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setTimeoutInterval:20];
    NSLog(@"请求头:%@", request.allHTTPHeaderFields);
    return request;
}


+ (NSString *)signWithRawparameters:(NSDictionary *)parameters needKey:(BOOL)needKey {
    
    NSMutableString *sign = [NSMutableString string];
    NSString *skey = KEY_SKEY;
    
    NSArray *tmpAllKeys = [parameters allKeys];
    NSArray *allKeys = [tmpAllKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return ([obj1 compare:obj2] == NSOrderedDescending);
    }];
    
    for (NSString *key in allKeys) {
        NSArray *value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            [sign appendFormat:@"%@", key];

            for (NSDictionary *dic in value) {
                NSArray *tmpDicAllKeys = [dic allKeys];
                NSArray *dicAllKeys = [tmpDicAllKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return ([obj1 compare:obj2] == NSOrderedDescending);
                }];
                for (NSString *key in dicAllKeys) {
                    [sign appendFormat:@"%@%@", key, [dic objectForKey:key]];
                }
            }
        } else {
            [sign appendFormat:@"%@%@", key, [parameters objectForKey:key]];
        }
    }
    if (needKey) {
        [sign appendFormat:@"%@", skey];
    }
    
    
    NSString *result = [[sign md5] lowercaseString];
    
    NSLog(@"sign string = %@", sign);
    NSLog(@"sign = %@", result);
    
    return result;
}

@end
