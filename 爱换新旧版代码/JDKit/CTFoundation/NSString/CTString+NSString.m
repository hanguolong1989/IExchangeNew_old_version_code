//
//  CTString+NSString.m
//  GZCT
//
//  Created by NewMBP1 on 15/6/30.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTString+NSString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(CTString)

- (NSString *)trim
{
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef) mStr);
    NSString *result = [mStr copy];
    return result;
}

- (NSInteger)lengthOfGBKBytes
{
    NSInteger len = 0;
    
    for (NSInteger i = 0, c = [self length]; i < c; ++i) {
        unichar ch = [self characterAtIndex:i];
        if (ch < 256) {
            ++ len;
        } else {
            len += 2;
        }
    }
    
    return len;
}


- (NSString *)noEmojiAndTrim
{
    __block NSMutableString *mutableString = [[self trim] copy];
    [mutableString enumerateSubstringsInRange:NSMakeRange(0, [mutableString length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                if ([NSString stringContainsEmoji:substring])
                                {
                                    mutableString = [[mutableString stringByReplacingOccurrencesOfString:substring withString:@""] copy];
                                }
                            }];
    return [mutableString copy];
    
}

//判断是否是 emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
        __block BOOL returnValue = NO;
        [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
              ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                       
                      const unichar hs = [substring characterAtIndex:0];
                      // surrogate pair
                      if (0xd800 <= hs && hs <= 0xdbff) {
                              if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                              returnValue = YES;
                                          }
                                  }
                          } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                          returnValue = YES;
                                      }
                                   
                              } else {
                                      // non surrogate
                                      if (0x2100 <= hs && hs <= 0x27ff) {
                                              returnValue = YES;
                                          } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                                  returnValue = YES;
                                              } else if (0x2934 <= hs && hs <= 0x2935) {
                                                      returnValue = YES;
                                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                                          returnValue = YES;
                                                      } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                                              returnValue = YES;
                                                          }
                                  }
                  }];
     
        return returnValue;
}

- (NSDictionary *)JOSNObject {
    NSError *parseError = nil;

    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length > 0) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (nil == parseError) {
            return dict;
        }
    }
    return [NSDictionary dictionary];
}


- (NSString *)md5 {
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, [@(strlen(cStr)) unsignedIntValue], result );
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]];
}

- (NSMutableDictionary*)queryStringToDictionary {
    NSMutableArray *elements = [NSMutableArray arrayWithArray:[self componentsSeparatedByString:@"&"]];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
    for(NSString *e in elements) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        if ([pair objectAtIndex:0] != nil && [pair objectAtIndex:1] != nil) {
            [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
        }
    }
    return retval;
}




@end
