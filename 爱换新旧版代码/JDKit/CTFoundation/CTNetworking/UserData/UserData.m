//
//  UserData.m
//  IExchangeNew-Salesman
//
//  Created by Hind on 16/8/1.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "UserData.h"

#define USERDEFAULT_USER_KEY @"USERDEFAULT_USER_KEY"

@implementation UserData

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.sessionId = [decoder decodeObjectForKey:@"sessionId"];
        self.name = [decoder decodeObjectForKey:@"userName"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.userNo = [decoder decodeObjectForKey:@"userNo"];
        
        self.acctBranchCode = [decoder decodeObjectForKey:@"acctBranchCode"];
        self.acctName = [decoder decodeObjectForKey:@"acctName"];
        self.acctNo = [decoder decodeObjectForKey:@"acctNo"];
        self.userAddress = [decoder decodeObjectForKey:@"userAddress"];
        self.userIdentityNo = [decoder decodeObjectForKey:@"userIdentityNo"];
        self.identifyImage = [decoder decodeObjectForKey:@"identifyImage"];
        self.identityBackImage = [decoder decodeObjectForKey:@"identityBackImage"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_sessionId forKey:@"sessionId"];
    [encoder encodeObject:_name forKey:@"userName"];
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_userNo forKey:@"userNo"];
    
    
    [encoder encodeObject:_acctBranchCode forKey:@"acctBranchCode"];
    [encoder encodeObject:_acctName forKey:@"acctName"];
    [encoder encodeObject:_acctNo forKey:@"acctNo"];
    [encoder encodeObject:_userAddress forKey:@"userAddress"];
    [encoder encodeObject:_userIdentityNo forKey:@"userIdentityNo"];
    [encoder encodeObject:_identifyImage forKey:@"identifyImage"];
    [encoder encodeObject:_identityBackImage forKey:@"identityBackImage"];
    
}

- (NSData *)archiver
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (UserData *)unarchiver:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)saveUser {
    [[NSUserDefaults standardUserDefaults] setObject:[self archiver] forKey:USERDEFAULT_USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UserData *)instance
{
    static UserData *_currentUserData;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_USER_KEY];
        if (nil == data) {
            _currentUserData = [[UserData alloc] init];
        } else {
            _currentUserData = [UserData unarchiver:data];
        }
    });
    
    return _currentUserData;
}

- (void)setUserLoginData:(NSDictionary *)responeData {
    NSString *sessionId = [responeData stringForKey:@"sessionId"];
    NSString *name = [responeData stringForKey:@"userName"];
    
    
    NSString *userId = [NSString stringWithFormat:@"%@", [responeData objectForKey:@"id"]];
    NSString *userNo = [NSString stringWithFormat:@"%@", [responeData objectForKey:@"userNo"]];

    if (sessionId.length > 0) {
        self.sessionId = sessionId;
    }
    self.name = name;
    self.userId = userId;
    self.userNo = userNo;
    
    
    self.acctBranchCode = [responeData stringForKey:@"acctBranchCode"];
    self.acctName = [responeData stringForKey:@"acctName"];
    self.acctNo = [responeData stringForKey:@"acctNo"];
    self.userAddress = [responeData stringForKey:@"userAddress"];
    self.userIdentityNo = [responeData stringForKey:@"userIdentityNo"];
    self.identifyImage = [responeData stringForKey:@"identifyImage"];
    self.identityBackImage = [responeData stringForKey:@"identityBackImage"];

    
    [self saveUser];
}

- (BOOL)isLogin {
    if (self.sessionId.length > 0 && self.userId.length > 0) {
        return YES;
    }
    return NO;
}


@end
