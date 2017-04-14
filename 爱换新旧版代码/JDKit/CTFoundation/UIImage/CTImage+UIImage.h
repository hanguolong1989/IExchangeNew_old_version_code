//
//  CTImage+UIImage.h
//  GZCT
//
//  Created by Hind on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(CTImage)

+ (UIImage *)imageWithKey:(NSString *)name;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)transformToSizeCT:(CGSize)newSize;

- (UIImage *)cropImageWithRect:(CGRect)imageRect;

//灰度图片
- (UIImage *)grayImage;
//二值化图片
- (UIImage *)convertToGrayscale;

@end
