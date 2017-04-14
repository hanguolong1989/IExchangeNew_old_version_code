//
//  PhoneOptionModel.h
//  IExchangeNew
//
//  Created by Hind on 16/7/13.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PhoneOptionStatusNotDetected = -1,
    PhoneOptionStatusNotAvailable = 0,
    PhoneOptionStatusAvailable = 1,
}PhoneOptionStatus;

@interface PhoneOptionModel : NSObject

@property (copy, nonatomic) NSNumber *optionId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *data;
@property (copy, nonatomic) NSArray *options;
@property (copy, nonatomic) NSDictionary *value;
@property (assign, nonatomic) PhoneOptionStatus status;



+ (PhoneOptionModel *)modelFromUserDefaultWithKey:(NSString *)key;
- (void)saveToUserDefault;

- (instancetype)initWithKey:(NSString *)key name:(NSString *)name options:(NSArray *)options optionId:(NSNumber *)optionId;

- (void)setNormal:(BOOL)isNormal;

@end
