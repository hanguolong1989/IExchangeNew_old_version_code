//
//  CTCommon.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/21.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTCommon.h"

@implementation CTCommon

+ (float)widthWithFactor:(CGSize)oldSize height:(float)height
{
    float factor = oldSize.width * height;
    float newWidth = factor / oldSize.height;
    
    return newWidth;
}

+ (float)HeightWithFactor:(CGSize)oldSize width:(float)width
{
    float factor = oldSize.height * width;
    float newHeight = factor / oldSize.width;
    
    return newHeight;
}

@end
