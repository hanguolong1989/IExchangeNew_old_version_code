//
//  DrawScreenView.h
//  IExchangeNew
//
//  Created by Hind on 16/7/20.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};


@interface DrawScreenView : UIView


@property (nonatomic, readwrite) DrawingMode drawingMode;
@property (nonatomic, strong) UIColor *selectedColor;

- (void)clearView;

@end
