//
//  UserData.h
//  IExchangeNew-Salesman
//
//  Created by Hind on 16/8/1.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userNo;

@property (nonatomic, copy) NSString *acctBranchCode;//	开户行行号
@property (nonatomic, copy) NSString *acctName;//	银行卡户名
@property (nonatomic, copy) NSString *acctNo;//	银行卡卡号
@property (nonatomic, copy) NSString *userAddress;//	用户地址
@property (nonatomic, copy) NSString *userIdentityNo;//	用户身份证号
@property (nonatomic, copy) NSString *identifyImage;//	身份证正面照片URL
@property (nonatomic, copy) NSString *identityBackImage;//	身份证反面照片URL

+ (UserData *)instance;

- (void)setUserLoginData:(NSDictionary *)responeData;
- (BOOL)isLogin;


@end
