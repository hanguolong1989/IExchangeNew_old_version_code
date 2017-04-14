//
//  CTLoadingMoreCell.h
//  GZCT
//
//  Created by NewMBP1 on 15/7/11.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTLoadingMoreCell : UITableViewCell

+ (CTLoadingMoreCell *)loadingMoreCellForTableView:(UITableView *)tableView target:(id)target action:(SEL)action;

- (void)startLoading;
- (void)stopLoading;

@end
