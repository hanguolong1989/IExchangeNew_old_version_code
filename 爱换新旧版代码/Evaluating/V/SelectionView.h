//
//  SelectionView.h
//  IExchangeNew
//
//  Created by Hind on 16/7/20.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectionBlock)(NSDictionary *option, NSInteger index);

@interface SelectionView : UIView

+ (SelectionView *)instance;

- (void)showViewWithTitle:(NSString *)title descript:(NSString *)descript options:(NSArray *)options selectionBlock:(SelectionBlock)block;

#pragma mark - 涂屏幕
- (void)showDrawScreenView;

#pragma mark - 检查液晶
- (void)showLiquidCrystalView;

@end
