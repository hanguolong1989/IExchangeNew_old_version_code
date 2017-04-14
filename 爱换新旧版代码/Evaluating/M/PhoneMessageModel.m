//
//  PhoneMessageModel.m
//  IExchangeNew
//
//  Created by Hind on 16/7/12.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "PhoneMessageModel.h"


@implementation PhoneMessageModel


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.imageName = [decoder decodeObjectForKey:@"imageName"];
        self.key = [decoder decodeObjectForKey:@"key"];
        self.rowData = [decoder decodeObjectForKey:@"rowData"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_imageName forKey:@"imageName"];
    [encoder encodeObject:_key forKey:@"key"];
    [encoder encodeObject:_rowData forKey:@"rowData"];
    
}

- (NSData *)archiver
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (PhoneMessageModel *)unarchiver:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


+ (PhoneMessageModel *)modelFromUserDefaultWithKey:(NSString *)key {
    
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

- (instancetype)initWithKey:(NSString *)key name:(NSString *)name imageName:(NSString *)imageName rowData:(NSArray *)rowData
{
    self = [super init];
    if (self) {
        self.key = key;
        self.name = name;
        self.imageName = imageName;
        self.rowData = rowData;
    }
    return self;
}

@end
