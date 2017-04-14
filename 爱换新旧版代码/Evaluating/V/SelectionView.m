//
//  SelectionView.m
//  IExchangeNew
//
//  Created by Hind on 16/7/20.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "SelectionView.h"
#import "DrawScreenView.h"
#import "LiquidCrystalView.h"

@interface SelectionView()

@property (weak, nonatomic) IBOutlet LiquidCrystalView *liquidCrystalView;

@property (weak, nonatomic) IBOutlet UIView *drawScreenBgView;
@property (weak, nonatomic) IBOutlet DrawScreenView *drawScreenView;
@property (copy, nonatomic) SelectionBlock block;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
@property (weak, nonatomic) IBOutlet UIView *selectionBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (strong, nonatomic) NSArray *options;

@end

@implementation SelectionView


+ (SelectionView *)instance
{
    static SelectionView *_currentSelectionView;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectionView" owner:self options:nil];
        _currentSelectionView = [nib lastObject];
        _currentSelectionView.frame = [UIScreen mainScreen].bounds;
    });
    
    return _currentSelectionView;
}

- (void)showViewWithTitle:(NSString *)title descript:(NSString *)descript options:(NSArray *)options selectionBlock:(SelectionBlock)block {
    
    self.block = block;
    self.titleLabel.text = title;
    self.descriptLabel.text = descript;
    self.options = options;
    
    NSDictionary *attributes = @{NSFontAttributeName:self.descriptLabel.font};
    CGSize size = [descript boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.descriptLabelHeight.constant = size.height + 5;
    
    [self.selectionBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float width = SCREEN_WIDTH - 60;
    for (int i = 0; i < options.count; i++) {
        NSDictionary *option = [options objectAtIndexCT:i];
        NSString *optionTitle = [option objectForKey:@"subTitle"];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*41, width, 0.5)];
        lineView.backgroundColor = RGBAColor(209, 209, 209, 1);
        [self.selectionBgView addSubview:lineView];
        
        CGRect frame = CGRectMake(0, i * 41, width, 41);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = frame;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:optionTitle forState:UIControlStateNormal];
        [button setTitleColor:RGBAColor(88, 205, 110, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectionBgView addSubview:button];
    }

    float height = CGRectGetMinY(self.descriptLabel.frame) + size.height + 15 + 5 + 41 * options.count;
    self.bgViewHeight.constant = height;
    
    [self removeFromSuperview];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

- (void)optionButtonClick:(UIButton *)btn {
    NSInteger index = btn.tag;
    NSDictionary *optionTitle = [self.options objectAtIndexCT:index];

    if (self.block) {
        self.block(optionTitle, index);
    }
    [self dismiss];
}

- (IBAction)backButtonClick:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    self.block = nil;
    self.options = nil;

    [self removeFromSuperview];
}


#pragma mark - 涂屏幕
- (void)showDrawScreenView {
    self.drawScreenBgView.hidden = NO;
    
    [self.drawScreenView clearView];
}

#pragma mark - 检查液晶
- (void)showLiquidCrystalView {
    self.liquidCrystalView.hidden = NO;
    [self.liquidCrystalView resetView];
}


@end
