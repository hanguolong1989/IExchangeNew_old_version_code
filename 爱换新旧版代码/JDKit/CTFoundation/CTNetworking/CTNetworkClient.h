//
//  CTNetworkClient.h
//  GZCT
//
//  Created by NewMBP1 on 15/5/14.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CTNetworkClient : NSObject

+ (AFHTTPRequestOperation *)post:(NSString *)urlString parameters:(NSDictionary *)parameters blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure;


+ (AFHTTPRequestOperation *)post:(NSString *)urlString rawParameters:(NSDictionary *)parameters blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure;

+ (AFHTTPRequestOperation *)postJSON:(NSString *)urlString rawParameters:(NSDictionary *)parameters
                    blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure;

+ (AFHTTPRequestOperation *)post:(NSString *)urlString images:(NSArray *)images parameter:(NSDictionary *)parameters blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
     failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure;


+ (AFHTTPRequestOperation *)get:(NSString *)urlString blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success
    failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure;


+ (AFHTTPRequestOperation *)download:(NSString *)urlString downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadBlock blockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responeData))success failure:(void (^)(AFHTTPRequestOperation *operation, id responeData, NSError *error))failure;

+ (NSString *)cacheFilePath;

@end
