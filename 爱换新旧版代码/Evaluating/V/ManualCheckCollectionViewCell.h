//
//  ManualCheckCollectionViewCell.h
//  IExchangeNew
//
//  Created by koreadragon on 16/11/10.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualCheckCollectionViewCell : UICollectionViewCell
/**
 *  背景图
 */

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

/**
 *  状态image,status
 */
@property (weak, nonatomic) IBOutlet UIImageView *smallLogoImageView;
/**
 *  我的label
 */
@property (weak, nonatomic) IBOutlet UILabel *myLabel;





@end
