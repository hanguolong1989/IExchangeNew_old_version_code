//
//  CIFilter+LUT.m
//  FilterMe-PartTwo
//
//  Created by Nghia Tran on 6/17/14.
//  Copyright (c) 2014 Fe. All rights reserved.
//

#import "CIFilter+LUT.h"
#import <CoreImage/CoreImage.h>
#import <OpenGLES/EAGL.h>

@implementation CIFilter (LUT)

+ (CIFilter *)filterWithImage:(UIImage *)filterImage dimension:(NSInteger)dimension
{
//    UIImage *image = [UIImage imageWithKey:name];
    
    NSInteger width = CGImageGetWidth(filterImage.CGImage);
    NSInteger height = CGImageGetHeight(filterImage.CGImage);
    NSInteger rowNum = height / dimension;
    NSInteger columnNum = width / dimension;
    
    if ((width % dimension != 0) || (height % dimension != 0) || (rowNum * columnNum != dimension))
    {
        NSLog(@"Invalid colorLUT");
        return nil;
    }
    
    unsigned char *bitmap = [self createRGBABitmapFromImage:filterImage.CGImage];
    
    if (bitmap == NULL)
    {
        return nil;
    }
    
    NSInteger size = dimension * dimension * dimension * sizeof(float) * 4;
    float *data = malloc(size);
    int bitmapOffest = 0;
    int z = 0;
    for (int row = 0; row <  rowNum; row++)
    {
        for (int y = 0; y < dimension; y++)
        {
            int tmp = z;
            for (int col = 0; col < columnNum; col++)
            {
                for (int x = 0; x < dimension; x++) {
                    float r = (unsigned int)bitmap[bitmapOffest];
                    float g = (unsigned int)bitmap[bitmapOffest + 1];
                    float b = (unsigned int)bitmap[bitmapOffest + 2];
                    float a = (unsigned int)bitmap[bitmapOffest + 3];
                    
                    NSInteger dataOffset = (z*dimension*dimension + y*dimension + x) * 4;
                    
                    data[dataOffset] = r / 255.0;
                    data[dataOffset + 1] = g / 255.0;
                    data[dataOffset + 2] = b / 255.0;
                    data[dataOffset + 3] = a / 255.0;
                    
                    bitmapOffest += 4;
                }
                z++;
            }
            z = tmp;
        }
        z += columnNum;
    }
    
    free(bitmap);
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorCube"];
    [filter setValue:[NSData dataWithBytesNoCopy:data length:size freeWhenDone:YES] forKey:@"inputCubeData"];
    [filter setValue:[NSNumber numberWithInteger:dimension] forKey:@"inputCubeDimension"];
    
    return filter;
}

+ (unsigned char *)createRGBABitmapFromImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char *bitmap;
    NSInteger bitmapSize;
    NSInteger bytesPerRow;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    bytesPerRow   = (width * 4);
    bitmapSize     = (bytesPerRow * height);
    
    bitmap = malloc( bitmapSize );
    if (bitmap == NULL)
    {
        return NULL;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        free(bitmap);
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmap,
                                     width,
                                     height,
                                     8,
                                     bytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease( colorSpace );
    
    if (context == NULL)
    {
        free (bitmap);
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    CGContextRelease(context);
    
    return bitmap;
}


@end
