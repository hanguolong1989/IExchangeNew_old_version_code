//
//  LiquidCrystalView.m
//  IExchangeNew
//
//  Created by Hind on 16/7/21.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "LiquidCrystalView.h"

@implementation LiquidCrystalView

- (void)awakeFromNib
{
    [self initialize];
    [super awakeFromNib];
}

#pragma mark - Private methods
- (void)initialize {
    self.backgroundColor = [UIColor blackColor];

    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheView:)];
    doubleRecognizer.numberOfTapsRequired = 1; // 双击
    [self addGestureRecognizer:doubleRecognizer];

}

- (void)clickTheView:(UITapGestureRecognizer *)tap {
    if ([self.backgroundColor isEqual:[UIColor blackColor]]) {
        //本来是黑的，变白
        self.backgroundColor = [UIColor whiteColor];
    } else if ([self.backgroundColor isEqual:[UIColor whiteColor]]) {
        //本来是白的，退出
        self.hidden = YES;
    }
}

- (void)resetView {
    
    self.backgroundColor = [UIColor blackColor];

}

@end
