//
//  CTDataHelper.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/14.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTDataHelper.h"


@implementation CTDataHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNo = 1;
        self.hasNextPage = NO;
    }
    return self;
}

- (void)loadDataWithSuccess:(handleResultBlock)bloc {
    
}

- (void)loadDataWithSuccess:(handleResultBlock)bloc failure:(loadDataBlockFailure)failure {
    
}


- (void)loadDataWithSuccess:(handleResultBlock)bloc failure:(loadDataBlockFailure)failure pageNo:(NSInteger)pageNo {
    
}

@end
