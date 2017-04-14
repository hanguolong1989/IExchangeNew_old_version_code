//
//  HGAutoCheckCollectionViewCell.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/7.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "HGAutoCheckCollectionViewCell.h"

@implementation HGAutoCheckCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _upLabel.textColor = [UIColor colorWithHexString:@"#464646" alpha:1.0];
    _upLabel.font = [UIFont systemFontOfSize:14.0];
    
    _belowLabel.textColor = [UIColor colorWithHexString:@"#cccccc" alpha:1.0];
    _belowLabel.font = [UIFont systemFontOfSize:12.0];
    
}
- (void)updateCellWithData:(PhoneOptionModel *)model{
    
    
    self.upLabel.text = [model.name trim];
    
 
    if (PhoneOptionStatusAvailable == model.status) {
        self.belowLabel.text = model.data;
        self.iconImageView.image = [UIImage imageNamed:@"autoCheck_well.png"];
    } else if (PhoneOptionStatusNotAvailable == model.status) {
        self.belowLabel.text = @"无数据";
        self.iconImageView.image = [UIImage imageNamed:@"logo_auto_check_unknow"];
    } else {
        self.belowLabel.text = @"未检测";
        self.iconImageView.image = [UIImage imageNamed:@"autoCheck_unCheck.png"];
    }

}

@end
