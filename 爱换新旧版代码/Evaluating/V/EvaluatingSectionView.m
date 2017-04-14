//
//  EvaluatingSectionView.m
//  IExchangeNew
//
//  Created by Hind on 16/6/29.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "EvaluatingSectionView.h"

@interface EvaluatingSectionView()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;


@end

@implementation EvaluatingSectionView

+ (EvaluatingSectionView *)viewWithFrame:(CGRect)frame
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EvaluatingSectionView" owner:self options:nil];
    EvaluatingSectionView *view = [nib lastObject];
    if (view) {
        view.frame = frame;
    }
    return view;
}

- (void)updateViewWithModel:(PhoneMessageModel *)model {
    self.logoView.image = [UIImage imageNamed:model.imageName];
    self.nameView.text = model.name;
}

@end
