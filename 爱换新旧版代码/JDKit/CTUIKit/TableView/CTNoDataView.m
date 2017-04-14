//
//  CTNoDataView.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/28.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTNoDataView.h"

@interface CTNoDataView()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *refreshLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CTNoDataView

- (void)showTips:(NSString *)tips {
    self.tipsLabel.text = tips;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.tipsTopConstraint.constant = frame.size.height*0.4;
    [self setNeedsLayout];
}

- (void)addRefreshWithText:(NSString *)text target:(id)target action:(SEL)action {
    if (text.length > 0) {
        self.refreshLabel.hidden = NO;
    } else {
        self.refreshLabel.hidden = YES;
    }
    
    if (nil != target) {
        self.button.hidden = NO;
        
        self.refreshLabel.text = text;
        [self.button removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.refreshLabel.text = text;
    }
    
}

- (IBAction)buttonClick:(UIButton *)button {
    self.userInteractionEnabled = NO;
    [self.activityIndicatorView startAnimating];
}




@end
