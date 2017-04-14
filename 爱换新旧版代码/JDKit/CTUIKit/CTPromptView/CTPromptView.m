//
//  CTPromptView.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/15.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTPromptView.h"

#define DEFAULT_PROMPTVIEW_SHOW_TIME 1.5

@interface CTPromptView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation CTPromptView

+ (CTPromptView *)instance
{
    static CTPromptView *_currentPromptView;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _currentPromptView = [[CTPromptView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    });
    
    return _currentPromptView;
}

#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel = label;
        
        [self addSubview:_titleLabel];
        _titleLabel.textAlignment    =   NSTextAlignmentCenter;
        _titleLabel.textColor        =   [UIColor whiteColor];
        _titleLabel.backgroundColor  =   [UIColor clearColor];
        _titleLabel.lineBreakMode    =   NSLineBreakByCharWrapping;
        
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.alpha = 0;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:button];
        
    }
    return self;
}

- (void)show:(float)time
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha          =   1;
    } completion:^(BOOL finished) {
        //隐藏
        [self performSelector:@selector(hide) withObject:nil afterDelay:time];
    }];
}

- (void)hide
{
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

#pragma mark - public method
+ (void)showText:(NSString *)text {
    float time = DEFAULT_PROMPTVIEW_SHOW_TIME;
    
    [self showText:text time:time];
}


+ (void)showText:(NSString *)text time:(float)time {
    UIView *superView = [[[UIApplication sharedApplication] delegate] window];
    [self showText:text atView:superView time:time];
}

+ (void)showText:(NSString *)text atView:(UIView *)superView time:(float)time {
    CGPoint point = CGPointMake(superView.frame.size.width*0.5, superView.frame.size.height*0.5);
    [self showText:text gravity:point time:time];
}

+ (void)showText:(NSString *)text gravity:(CGPoint)point time:(float)time {
    UIView *superView = [[[UIApplication sharedApplication] delegate] window];
    [self showText:text gravity:point atView:superView time:time];
}

+ (void)showText:(NSString *)text gravity:(CGPoint)point atView:(UIView *)superView time:(float)time {
    [self showText:text icon:nil gravity:point atView:superView time:time];
}


+ (void)showText:(NSString *)text
            icon:(NSString *)imageName
         gravity:(CGPoint)point
          atView:(UIView *)superView
            time:(float)time
{
    
    CTPromptView *promptView = [CTPromptView instance];
    
    
    //阻止上一次的消失动画
    [NSObject cancelPreviousPerformRequestsWithTarget:promptView selector:@selector(hide) object:nil];
    
    if (nil != [promptView superview]) {
        [promptView removeFromSuperview];
    }
    
    [superView addSubview:promptView];
    [superView bringSubviewToFront:promptView];
    
    promptView.titleLabel.text = text;
    
    UIImage *iconImage = nil;
    if (imageName.length > 0) {
        iconImage = [UIImage imageWithKey:imageName];
    }
    
    if (iconImage != nil) {
        promptView.iconView.image = iconImage;
        
        //比图片高30，宽30
        CGSize originalSize = CGSizeMake(110, 140);
        promptView.bounds = CGRectMake(0, 0, originalSize.width, originalSize.height);
        
        //圆角半径
        promptView.layer.cornerRadius = 8;
        
        //图标
        promptView.iconView.frame = CGRectMake(15 , 20, 80, 80);
        
        //标题
        promptView.titleLabel.frame = CGRectMake(15, CGRectGetMaxY(promptView.iconView.frame), 80, 20);
        
    }
    else {
        
        promptView.layer.cornerRadius = 5;
        
        //根据文字来定视图大小
        NSDictionary *attributes = @{NSFontAttributeName:promptView.titleLabel.font};
        CGSize size = [text boundingRectWithSize:CGSizeMake(280, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        CGRect tFrame = CGRectMake(0, 0, MIN(SCREEN_WIDTH * 0.75, size.width), size.height);
        
        CGRect frame = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectInset(tFrame, -30,  -50) : CGRectInset(tFrame, -10,  -10);
        
        promptView.frame = frame;
        
        float width = promptView.frame.size.width;
        
        //标题
        CGFloat padding = 10;
        CGFloat titleWidth = width - padding * 2;
        
        if (size.width  < titleWidth) {
            promptView.titleLabel.numberOfLines = 1;
            promptView.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        else {
            promptView.titleLabel.numberOfLines = 3;
            promptView.titleLabel.adjustsFontSizeToFitWidth = NO;
        }
        
        [promptView.titleLabel setFrame: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectInset(promptView.bounds, 0,  50) : promptView.bounds];
    }
    
    promptView.center = point;
    
    //显示
    [promptView show:time];
}




@end
