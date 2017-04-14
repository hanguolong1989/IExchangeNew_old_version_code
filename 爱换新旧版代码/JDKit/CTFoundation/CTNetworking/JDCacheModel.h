//
//  JDCacheModel.h
//  MusicApp
//
//  Created by Hind on 16/3/10.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDCacheModel : NSObject


//缓存创建时间
@property (nonatomic, assign) NSUInteger date;
//服务器头的Cache-Control:max-age=  或者Expires减去创建时间
@property (nonatomic, assign) NSInteger maxAge;
//服务器返回的data的长度
@property (nonatomic, assign) NSInteger contentLength;
//缓存协议
@property (nonatomic, assign) NSUInteger policy;
//最后一次使用缓存的时间
@property (nonatomic, assign) NSUInteger modifyDate;
//缓存是否过期
@property (nonatomic, readonly, assign) BOOL cacheValid;
//数据实体
@property (nonatomic, readonly) NSData *data;


/**
 该缓存的本地路径
 */
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *uri;
//服务器头的Last-Modified数据
@property (nonatomic, copy) NSString *lastModified;

- (id) initWithDictionary:(NSDictionary *) dict;


@end
