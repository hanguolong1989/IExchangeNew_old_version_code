//
//  CTString+NSString.h
//  GZCT
//
//  Created by NewMBP1 on 15/6/30.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(CTString)

- (NSString *)trim;

- (NSInteger)lengthOfGBKBytes;

//判断是否是 emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;
- (NSString *)noEmojiAndTrim;

- (NSDictionary *)JOSNObject;

- (NSString *)md5;

- (NSMutableDictionary*)queryStringToDictionary;

@end
