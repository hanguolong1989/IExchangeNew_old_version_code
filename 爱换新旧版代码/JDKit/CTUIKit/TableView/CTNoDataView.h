//
//  CTNoDataView.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/28.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTNoDataView : UIView

- (void)showTips:(NSString *)tips;
- (void)addRefreshWithText:(NSString *)text target:(id)target action:(SEL)action;

@end
