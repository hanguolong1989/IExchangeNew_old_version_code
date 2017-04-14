//
//  EvaluatingSectionView.h
//  IExchangeNew
//
//  Created by Hind on 16/6/29.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneMessageModel.h"


@interface EvaluatingSectionView : UIView

+ (EvaluatingSectionView *)viewWithFrame:(CGRect)frame;

- (void)updateViewWithModel:(PhoneMessageModel *)model;

@end
