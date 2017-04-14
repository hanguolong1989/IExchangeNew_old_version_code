//
//  CTDataHelper.h
//  GZCT
//
//  Created by NewMBP1 on 15/5/14.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void (^handleResultBlock)(id responeData);
typedef void (^loadDataBlockFailure)(AFHTTPRequestOperation *operation, NSError *error);

@interface CTDataHelper : NSObject

- (void)loadDataWithSuccess:(handleResultBlock)bloc;
- (void)loadDataWithSuccess:(handleResultBlock)bloc failure:(loadDataBlockFailure)failure;
- (void)loadDataWithSuccess:(handleResultBlock)bloc failure:(loadDataBlockFailure)failure pageNo:(NSInteger)pageNo;

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL hasNextPage;

@end
