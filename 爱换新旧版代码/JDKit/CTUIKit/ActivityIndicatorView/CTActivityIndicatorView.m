//
//  CTActivityIndicatorView.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/14.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTActivityIndicatorView.h"

@interface CTActivityIndicatorView()

@property (weak, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation CTActivityIndicatorView

- (instancetype)init
{
    CGRect frame = CGRectMake(0, 0, 75, 75);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:bgView];
        bgView.backgroundColor = RGBAColor(0, 0, 0, 0.3);
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        self.indicatorView.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.indicatorView.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
}

- (void)startAnimating {
    [self.indicatorView startAnimating];
    self.hidden = NO;
}

- (void)stopAnimating {
    [self.indicatorView stopAnimating];
    self.hidden = YES;
}

- (BOOL)isAnimating {
    return self.indicatorView.isAnimating;
}

@end
