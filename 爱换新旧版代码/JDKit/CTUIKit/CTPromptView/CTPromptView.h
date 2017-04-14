//
//  CTPromptView.h
//  GZCT
//
//  Created by NewMBP1 on 15/5/15.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTPromptView : UIView

+ (void)showText:(NSString *)text;

+ (void)showText:(NSString *)text time:(float)time;

+ (void)showText:(NSString *)text atView:(UIView *)superView time:(float)time;

+ (void)showText:(NSString *)text gravity:(CGPoint)point time:(float)time;

+ (void)showText:(NSString *)text gravity:(CGPoint)point atView:(UIView *)superView time:(float)time;

+ (void)showText:(NSString *)text
            icon:(NSString *)imageName
         gravity:(CGPoint)point
          atView:(UIView *)superView
            time:(float)time;


@end
