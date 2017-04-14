//
//  JDCacheModel.m
//  MusicApp
//
//  Created by Hind on 16/3/10.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "JDCacheModel.h"
#import "JDCacheManager.h"

@interface JDCacheModel()

@property (nonatomic, strong) NSData *data;

@end

@implementation JDCacheModel

- (id) initWithDictionary:(NSDictionary *) dict
{
    if ((self = [super init]) != nil) {
        self.date = [[dict objectForKey:@"_date"] intValue];
        self.contentLength = [[dict objectForKey:@"_content_length"] intValue];
        self.maxAge = [[dict objectForKey:@"_max_age"] intValue];
        self.path = [dict objectForKey:@"_path"];
        self.policy = [[dict objectForKey:@"_policy"] intValue];
        self.uri = [dict objectForKey:@"_uri"];
        
        if ([[dict objectForKey:@"_modifyDate"] isKindOfClass:[NSNull class]]) {
            self.modifyDate = [NSDate currentTimeInterval];
        }else
        {
            self.modifyDate = [[dict objectForKey:@"_modifyDate"] intValue];
        }
        
        if ([[dict objectForKey:@"_lastModified"] isKindOfClass:[NSString class]]) {
            self.lastModified = [dict objectForKey:@"_lastModified"];
        }else
        {
            self.lastModified = @"";
        }
    }
    return self;
}

- (void)dealloc
{
    self.path = nil;
    self.uri = nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"PCHttpCache:\nuri: %@\ndate: %@\nmax-age: %@\npath: %@\ncontent-length: %@",
            _uri, [NSDate headerWithHttpDate:_date], @(_maxAge), _path, @(_contentLength)];
}


- (BOOL)cacheValid {
    //缓存是否过期
    BOOL stale = [NSDate currentTimeInterval] > (self.date + self.maxAge);

    return !stale;
}


- (NSData *)data {
//    if (!self.cacheValid) {
//        return nil;
//    }
    if (nil == _data) {
        NSString *cachePath = [JDCacheManager cachePath:self.path];
        NSError *err;
        NSData *data = [[NSData alloc] initWithContentsOfFile:cachePath options:NSDataReadingUncached error:&err];
        if (err) {
            NSLog(@"读取缓存失败: %@",err);
        }
        _data = data;
    }
    return _data;
}

@end
