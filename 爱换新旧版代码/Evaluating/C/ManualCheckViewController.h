//
//  ManualCheckViewController.h
//  IExchangeNew
//
//  Created by koreadragon on 16/11/8.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "HGBaseViewController.h"

@interface ManualCheckViewController : HGBaseViewController

@property (nonatomic, copy) NSNumber *infoId;
@property (nonatomic, copy) NSString *authCode;
@property (nonatomic, weak) NSDictionary *resultData;
@property (nonatomic, weak) NSArray *autoCheckData;


@end
