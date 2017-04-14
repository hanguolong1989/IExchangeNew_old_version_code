//
//  CTPlaceHolderTextView.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/8.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTPlaceHolderTextView : UITextView

/**
 占位符视图
 */
@property (nonatomic, retain) UILabel *placeHolderLabel;

/**
 占位符文本
 */
@property (nonatomic, retain) NSString *placeholder;

/**
 占位符文本颜色
 */
@property (nonatomic, retain) UIColor *placeholderColor;

/**
 文本改变的通知
 @param notification 通知对象
 */
-(void)textChanged:(NSNotification*)notification;

@end
