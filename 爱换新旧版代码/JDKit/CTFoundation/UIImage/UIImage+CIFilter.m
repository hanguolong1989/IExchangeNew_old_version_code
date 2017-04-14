//
//  UIImage+CIFilter.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/3.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "UIImage+CIFilter.h"
#import "CIFilter+LUT.h"


@implementation UIImage(CIFilter)

- (UIImage *)imageFilterWithimage:(UIImage *)filterimage {
    
    CIFilter *lutFilter = [CIFilter filterWithImage:filterimage dimension:64];
    
    // Set parameter
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    [lutFilter setValue:ciImage forKey:@"inputImage"];
    CIImage *outputImage = [lutFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    
    CGImageRef fullResImage = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *result = [UIImage imageWithCGImage:fullResImage
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    return result;
    
}

@end
