//
//  CTTableView.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/11.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTTableView.h"
@interface CTTableView()

@property (nonatomic, strong) CTLoadingMoreCell *loadingMoreCell;

@end

@implementation CTTableView

- (UITableViewCell *)cellForMoreCell {
    return self.loadingMoreCell;
}

- (void)stopLoadingMore {
    [self.loadingMoreCell stopLoading];
}

- (void)startLoadingMore {
    [self.loadingMoreCell startLoading];
}


#pragma mark - getter & setter
- (CTLoadingMoreCell *)loadingMoreCell {
    if (nil == _loadingMoreCell) {
        self.loadingMoreCell = [CTLoadingMoreCell loadingMoreCellForTableView:self target:self action:@selector(moreCellClick:)];
    }
    return _loadingMoreCell;
}

#pragma mark - action
- (void)moreCellClick:(UIButton *)button {
    [self startLoadingMore];

    [self loadNextPage];
}

- (void)loadNextPage {
    
}

@end
