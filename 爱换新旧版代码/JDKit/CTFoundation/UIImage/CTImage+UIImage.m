//
//  CTImage+UIImage.m
//  GZCT
//
//  Created by Hind on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTImage+UIImage.h"

@implementation UIImage(CTImage)

+ (UIImage *)imageWithKey:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    if (!image) {
        NSLog(@"warning=====================找不到图片: %@", name);
    }
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  压缩图片
 *
 *  @param newSize 定义压缩后的图片大小
 *
 *  @return 压缩后的图片
 */
- (UIImage *)transformToSizeCT:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  裁剪图片
 *
 *  @param imageRect 定义裁剪的区域相对于原图片的位置
 *
 *  @return 裁剪后的图片
 */
- (UIImage *)cropImageWithRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [self drawInRect:drawRect];
    
    // grab image
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //返回裁剪的部分图像
    return croppedImage;
    
}

- (UIImage *)grayImage
{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate (nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

- (UIImage *)convertToGrayscale {
    
    CGSize size = [self size];
    
    int width = size.width;
    
    int height = size.height;
    
    // the pixels will be painted to this array
    
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    int tt = 1;
    
    CGFloat intensity;
    
    int bw;
    
    for(int y = 0; y < height; y++) {
        
        for(int x = 0; x < width; x++) {
            
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            intensity = (rgbaPixel[tt] + rgbaPixel[tt + 1] + rgbaPixel[tt + 2]) / 3. / 255.;
            
            if (intensity > 0.45) {
                
                bw = 255;
                
            } else {
                
                bw = 0;
                
            }
            
            rgbaPixel[tt] = bw;
            
            rgbaPixel[tt + 1] = bw;
            
            rgbaPixel[tt + 2] = bw;
            
        }
        
    }
    
    // create a new CGImageRef from our context with the modified pixels
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    free(pixels);
    
    // make a new UIImage to return
    
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    
    CGImageRelease(image);
    
    return resultUIImage;
}



@end
