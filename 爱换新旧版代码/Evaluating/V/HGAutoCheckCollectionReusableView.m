//
//  HGAutoCheckCollectionReusableView.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/7.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "HGAutoCheckCollectionReusableView.h"

@implementation HGAutoCheckCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#ececec" alpha:1.0];
}

@end
