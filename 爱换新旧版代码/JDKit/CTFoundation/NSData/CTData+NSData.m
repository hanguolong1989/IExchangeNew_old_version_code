//
//  CTData+NSData.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/3.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTData+NSData.h"

@implementation NSData(CTData)

+ (NSData *)bodyMultipartWithStringFields:(NSArray *)stringFields binaryFields:(NSArray *)binaryFields;
{
    NSMutableData *_data;
    _data = [[NSMutableData alloc] init];
    
    const char *boundary = [@"CTHTTPMULTIPARTBOUNDARY" cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger blen = [@"CTHTTPMULTIPARTBOUNDARY" length];
    for (NSInteger i = 0, c = [stringFields count]; i < c; i += 2) {
        [_data appendBytes:"--" length:2];
        [_data appendBytes:boundary length:blen];
        [_data appendBytes:"\r\n" length:2];
        [_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", [stringFields objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [_data appendData:[@"Content-Type: text/plain; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_data appendData:[@"Content-Transfer-Encoding: 8bit\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_data appendData:[[NSString stringWithFormat:@"\r\n%@\r\n", [stringFields objectAtIndex:i + 1]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    for (NSInteger i = 0, c = [binaryFields count]; i < c; i += 3) {
        [_data appendBytes:"--" length:2];
        [_data appendBytes:boundary length:blen];
        [_data appendBytes:"\r\n" length:2];
        [_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [binaryFields objectAtIndex:i], [binaryFields objectAtIndex:i + 1]] dataUsingEncoding:NSUTF8StringEncoding]];
        [_data appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_data appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_data appendData:[NSData dataWithData:[binaryFields objectAtIndex:i + 2]]];
        [_data appendBytes:"\r\n" length:2];
    }
    [_data appendBytes:"--" length:2];
    [_data appendBytes:boundary length:blen];
    [_data appendBytes:"--\r\n" length:4];
    
    return _data;
}

+ (NSData *)structureMultipartHttpBodyForClub:(NSDictionary *)dic {
    NSMutableData *_data = [[NSMutableData alloc] init];
    const char *boundary = [@"CTHTTPMULTIPARTBOUNDARY" cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger blen = [@"CTHTTPMULTIPARTBOUNDARY" length];
    
    for (NSString *key in [dic allKeys]) {
        NSObject *obj = [dic objectForKey:key];
        if ([obj isKindOfClass:[NSString class]]||[obj isKindOfClass:[NSNumber class]]){
            [_data appendBytes:"--" length:2];
            [_data appendBytes:boundary length:blen];
            [_data appendBytes:"\r\n" length:2];
            [_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [_data appendData:[@"Content-Type: text/plain; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [_data appendData:[@"Content-Transfer-Encoding: 8bit\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [_data appendData:[[NSString stringWithFormat:@"\r\n%@\r\n", obj] dataUsingEncoding:NSUTF8StringEncoding]];
        }else if([obj isKindOfClass:[NSData class]]){
            [_data appendBytes:"--" length:2];
            [_data appendBytes:boundary length:blen];
            [_data appendBytes:"\r\n" length:2];
            [_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [_data appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [_data appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [_data appendData:(NSData *)obj];
            [_data appendBytes:"\r\n" length:2];
        }
    }
    [_data appendBytes:"--" length:2];
    [_data appendBytes:boundary length:blen];
    [_data appendBytes:"--\r\n" length:4];
    
    return _data;
}


@end
