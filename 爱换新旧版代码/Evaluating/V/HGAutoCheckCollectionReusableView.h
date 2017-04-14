//
//  HGAutoCheckCollectionReusableView.h
//  IExchangeNew
//
//  Created by koreadragon on 16/11/7.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGAutoCheckCollectionReusableView : UICollectionReusableView

//图标imageView



@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//分割线
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
