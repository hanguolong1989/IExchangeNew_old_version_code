//
//  CALayer+CTLayer.m
//  MusicApp
//
//  Created by Hind on 16/2/22.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "CALayer+CTLayer.h"

@implementation CALayer(CTLayer)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
