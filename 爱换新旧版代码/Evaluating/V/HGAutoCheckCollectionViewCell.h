//
//  HGAutoCheckCollectionViewCell.h
//  IExchangeNew
//
//  Created by koreadragon on 16/11/7.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneOptionModel.h"

@interface HGAutoCheckCollectionViewCell : UICollectionViewCell

//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//上面label
@property (weak, nonatomic) IBOutlet UILabel *upLabel;

//下面的label
@property (weak, nonatomic) IBOutlet UILabel *belowLabel;


- (void)updateCellWithData:(PhoneOptionModel *)model;


@end
