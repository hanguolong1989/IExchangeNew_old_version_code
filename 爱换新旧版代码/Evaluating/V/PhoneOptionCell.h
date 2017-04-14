//
//  PhoneOptionCell.h
//  IExchangeNew
//
//  Created by Hind on 16/7/13.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneOptionModel.h"


@interface PhoneOptionCell : UITableViewCell

- (void)updateCellWithData:(PhoneOptionModel *)model;

@end
