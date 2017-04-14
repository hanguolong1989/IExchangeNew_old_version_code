//
//  JDProgressHUD.m
//  MusicApp
//
//  Created by Hind on 16/2/25.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "JDProgressHUD.h"

@implementation JDProgressHUD

+ (JDProgressHUD *)instance
{
    static JDProgressHUD *_currentPromptView;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        _currentPromptView = [[JDProgressHUD alloc] initWithFrame:window.bounds];
        [window addSubview:_currentPromptView];
        
        [_currentPromptView hideAnimated:NO];
    });
    
    return _currentPromptView;
}


- (void)showText:(NSString *)text animated:(BOOL)animated {
    self.label.text = text;
    [self showAnimated:animated];
}

- (void)showLoadingWithAnimated:(BOOL)animated {
    self.label.text = @"加载中";
    [self showAnimated:animated];
}

- (void)showProgress {
    self.tag = 1000;
    self.mode = MBProgressHUDModeDeterminate;
    self.label.text = @"下载中...";
    self.square = YES;
    [self showAnimated:YES];
}

@end
