//
//  CTViewController.h
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTNavigationController.h"

typedef NS_ENUM (NSInteger ,CTNavigationBarStyle){
    CTNavigationBarStylePrimary,
    CTNavigationBarStyleSecondary
};// navigation bar 的类型

@interface CTViewController : UIViewController

@property (nonatomic) CTNavigationBarStyle barStyle;
@property (nonatomic, assign) BOOL isRootController;

- (void)hideLineUnderNavigationBar:(BOOL)hidden;

- (void)setNavigationTitle:(NSString *)title;
- (void)useDefaultBackButton;


- (void)startLoading;
- (void)startLoadingAtView:(UIView *)view;
- (void)startLoadingAtView:(UIView *)view center:(CGPoint)point;

- (void)stopLoading;

+ (CTNavigationController *)navigationController;

- (void)preferNavigationBarStyle:(CTNavigationBarStyle)style;


#pragma mark - 旋转
- (void)setOrientation:(UIInterfaceOrientation)orientation;

@end
