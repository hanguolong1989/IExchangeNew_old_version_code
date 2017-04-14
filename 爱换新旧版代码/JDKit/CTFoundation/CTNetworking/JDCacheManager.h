//
//  JDCacheManager.h
//  MusicApp
//
//  Created by Hind on 16/3/10.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "CTDataHelper.h"
#import "JDCacheModel.h"

typedef NS_ENUM(NSInteger, JDHttpClientCachePolicy)
{
    //所有请求都会保存缓存
    //不使用缓存，网络异常时，返回空值
    JDHttpClientCachePolicyNoCache     = 0,
    
    //有网络时返回网络，网络异常返回缓存数据
    JDHttpClientCachePolicyHttpFirst   = 1,
    
    //先返回一次缓存，然后请求网络，有数据时返回，无数据时返回为空,  同步请求，如果有缓存则不刷新数据
    JDHttpClientCachePolicyHttpCache   = 2,
    
    //有缓存时直接使用缓存并且不刷新，无缓存时请求网络,  同步请求与PCHttpClientCachePolicyCacheFirst一致
    JDHttpClientCachePolicyCacheFirst  = 3,
    
};


@interface JDCacheManager : CTDataHelper

+ (NSString *)cachePath:(NSString *)relaPath;
+ (JDCacheManager *)instance;

- (JDCacheModel *)getCacheWithLikeUri:(NSString *) url;
- (void)putCache:(AFHTTPRequestOperation *)httpResult withCachePolicy:(JDHttpClientCachePolicy)cachePolicy;

@end
