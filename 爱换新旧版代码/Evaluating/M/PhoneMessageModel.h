//
//  PhoneMessageModel.h
//  IExchangeNew
//
//  Created by Hind on 16/7/12.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneMessageModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSArray *rowData;


+ (PhoneMessageModel *)modelFromUserDefaultWithKey:(NSString *)key;
- (void)saveToUserDefault;

- (instancetype)initWithKey:(NSString *)key name:(NSString *)name imageName:(NSString *)imageName rowData:(NSArray *)rowData;

@end
