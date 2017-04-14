//
//  PhoneOptionModel.m
//  IExchangeNew
//
//  Created by Hind on 16/7/13.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "PhoneOptionModel.h"

@implementation PhoneOptionModel


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.key = [decoder decodeObjectForKey:@"key"];
        self.data = [decoder decodeObjectForKey:@"data"];
        self.status = [decoder decodeIntForKey:@"status"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_data forKey:@"data"];
    [encoder encodeObject:_key forKey:@"key"];
    [encoder encodeInt:_status forKey:@"status"];
}

- (NSData *)archiver
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (PhoneOptionModel *)unarchiver:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


+ (PhoneOptionModel *)modelFromUserDefaultWithKey:(NSString *)key {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nil == data) {
        return nil;
    } else {
        return nil;
        //return [self unarchiver:data];
    }
}

- (void)saveToUserDefault {
    NSData *data = [self archiver];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:self.key];
}

- (instancetype)initWithKey:(NSString *)key name:(NSString *)name options:(NSArray *)options optionId:(NSNumber *)optionId
{
    self = [super init];
    if (self) {
        self.value = nil;
        self.key = key;
        self.name = name;
        self.data = @"";
        self.optionId = optionId;
        if (options.count > 0) {
            self.options = options;
        } else {
            self.options = [NSArray array];
        }
        
        self.status = PhoneOptionStatusNotDetected;
    }
    return self;
}

- (void)setNormal:(BOOL)isNormal {
    NSString *key = @"不正常";

    if (isNormal) {
        key = @"正常";
        self.status = PhoneOptionStatusAvailable;
    } else {
        self.status = PhoneOptionStatusNotAvailable;
    }
    
    for (NSDictionary *tmpOption in self.options) {
        NSString *subTitle = [tmpOption stringForKey:@"subTitle"];
        NSNumber *subId = [tmpOption objectForKey:@"subId"];
        if ([subTitle isEqualToString:key]) {
            self.value = [NSDictionary dictionaryWithObjectsAndKeys:subId, self.optionId, nil];
            break;
        }
    }

}


@end
