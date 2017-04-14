//
//  UITableView+CTTableView.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/28.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "UITableView+CTTableView.h"
#import "CTNoDataView.h"


@implementation UITableView(CTTableView)

- (void)showNoDataWithTipsOnHeader:(NSString *)tips {
    [self showNoDataWithTipsOnHeader:tips refreshText:nil target:nil action:nil];
}

- (void)showNoDataWithTipsOnHeader:(NSString *)tips refreshText:(NSString *)refreshText target:(id)target action:(SEL)action {
    
    float height = self.frame.size.height;
    if (self.tableFooterView) {
        height = self.frame.size.height - self.tableFooterView.frame.size.height;
    }
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, height);
    UIView *footer = [self viewWithFrame:frame noDataTips:tips refreshText:refreshText target:target action:action];
    
    self.tableHeaderView = footer;
}


- (void)showNoDataWithTipsOnFooter:(NSString *)tips {
    [self showNoDataWithTipsOnFooter:tips refreshText:nil target:nil action:nil];
}

- (void)showNoDataWithTipsOnFooter:(NSString *)tips refreshText:(NSString *)refreshText target:(id)target action:(SEL)action {
    float height = self.frame.size.height;
    if (self.tableHeaderView) {
        height = self.frame.size.height - self.tableHeaderView.frame.size.height;
    }
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, height);
    UIView *footer = [self viewWithFrame:frame noDataTips:tips refreshText:refreshText target:target action:action];
    
    self.tableFooterView = footer;
}

- (UIView *)viewWithFrame:(CGRect)frame noDataTips:(NSString *)tips refreshText:(NSString *)refreshText target:(id)target action:(SEL)action {
    
    UINib *noDataViewNib = [UINib nibWithNibName:@"CTNoDataView" bundle:nil];
    NSArray *views = [noDataViewNib instantiateWithOwner:self options:nil];
    CTNoDataView *noDataView = [views lastObject];
    noDataView.frame = frame;
    [noDataView showTips:tips];
    
    [noDataView addRefreshWithText:refreshText target:target action:action];
    
    return noDataView;
}




@end
