//
//  JDProgressHUD.h
//  MusicApp
//
//  Created by Hind on 16/2/25.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "MBProgressHUD.h"

@interface JDProgressHUD : MBProgressHUD

+ (JDProgressHUD *)instance;

/**
 *  显示加载中的样式
 *
 *  @param animated 是否动画展现
 */
- (void)showLoadingWithAnimated:(BOOL)animated;

- (void)showText:(NSString *)text animated:(BOOL)animated;

- (void)showProgress;

@end
