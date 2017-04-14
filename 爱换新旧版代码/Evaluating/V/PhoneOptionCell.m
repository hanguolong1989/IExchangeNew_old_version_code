//
//  PhoneOptionCell.m
//  IExchangeNew
//
//  Created by Hind on 16/7/13.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "PhoneOptionCell.h"

@interface PhoneOptionCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusLogo;


@end

@implementation PhoneOptionCell

- (void)updateCellWithData:(PhoneOptionModel *)model {
    
    
    self.nameLabel.text = [model.name trim];
    
    
    NSLog(@"cell更新信息**************%@********************",model.data);
    
    if (PhoneOptionStatusAvailable == model.status) {
        self.statusLabel.text = model.data;
        self.statusLogo.image = [UIImage imageNamed:@"logo_auto_check_done"];
    } else if (PhoneOptionStatusNotAvailable == model.status) {
        self.statusLabel.text = @"无数据";
        self.statusLogo.image = [UIImage imageNamed:@"logo_auto_check_unknow"];
    } else {
        self.statusLabel.text = @"未检测";
        self.statusLogo.image = [UIImage imageNamed:@"logo_uncheck"];
    }
    
    
}

@end
