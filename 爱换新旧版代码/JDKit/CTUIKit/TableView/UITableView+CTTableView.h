//
//  UITableView+CTTableView.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/28.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(CTTableView)

- (void)showNoDataWithTipsOnHeader:(NSString *)tips;
- (void)showNoDataWithTipsOnFooter:(NSString *)tips;

- (void)showNoDataWithTipsOnHeader:(NSString *)tips refreshText:(NSString *)refreshText target:(id)target action:(SEL)action ;
- (void)showNoDataWithTipsOnFooter:(NSString *)tips refreshText:(NSString *)refreshText target:(id)target action:(SEL)action ;

@end
