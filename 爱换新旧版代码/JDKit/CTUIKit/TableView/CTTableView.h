//
//  CTTableView.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/11.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTLoadingMoreCell.h"

@interface CTTableView : UITableView

- (UITableViewCell *)cellForMoreCell;

- (void)loadNextPage;

- (void)startLoadingMore;
- (void)stopLoadingMore;

@end
