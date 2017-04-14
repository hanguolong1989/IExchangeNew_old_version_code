//
//  CTCustomBadge.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/16.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
	仿照iOS系统的badge效果
	@author Hin D
 */
@interface CTCustomBadge : UIView

/**
	气泡里面的字
 */
@property(nonatomic,retain) NSString *badgeText;
/**
	气泡里面字体颜色
 */
@property(nonatomic,retain) UIColor *badgeTextColor;
/**
	气泡里面的背景色
 */
@property(nonatomic,retain) UIColor *badgeInsetColor;
/**
	气泡边框的颜色
 */
@property(nonatomic,retain) UIColor *badgeFrameColor;

/**
	是否设置气泡大小
 */
@property(nonatomic,readwrite) BOOL badgeFrame;
/**
	气泡内是否有阴影
 */
@property(nonatomic,readwrite) BOOL badgeShining;

/**
	气泡圆角
 */
@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
/**
 气泡边框大小
 */
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;
/**
 是否有外阴影
 */
@property(nonatomic,readwrite) BOOL shadow;

/**
	快速建立气泡文字，效果与iOS系统默认效果一致，有阴影，边框1px，大小(25,25)，白字红底，圆角0.4
	@param badgeString 气泡中的文字
	@returns PCCustomBadge
 */
+ (CTCustomBadge *) customBadgeWithString:(NSString *)badgeString;

/**
	气泡文字的方法
	@param badgeString 气泡内文字
	@param stringColor 气泡内文字
	@param insetColor 气泡里面的背景色
	@param badgeFrameYesNo 是否设置气泡大小
	@param frameColor 气泡边框的颜色
	@param scale 气泡边框大小
	@param shining 是否有阴影
	@returns PCCustomBadge
 */
+ (CTCustomBadge *) customBadgeWithString:(NSString *)badgeString
                          withStringColor:(UIColor*)stringColor
                           withInsetColor:(UIColor*)insetColor
                           withBadgeFrame:(BOOL)badgeFrameYesNo
                      withBadgeFrameColor:(UIColor*)frameColor
                                withScale:(CGFloat)scale
                              withShining:(BOOL)shining;

/**
	改变气泡里的文字
	@param badgeString 要更改的字符串
 */
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
