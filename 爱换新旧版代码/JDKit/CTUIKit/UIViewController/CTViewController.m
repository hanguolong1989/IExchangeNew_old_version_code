//
//  CTViewController.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTViewController.h"
#import "CTActivityIndicatorView.h"




@interface CTViewController ()

@property (nonatomic, strong) CTActivityIndicatorView *indicatorView;

@end

@implementation CTViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRootController = NO;
        if (self.isRootController) {
            self.barStyle = CTNavigationBarStylePrimary;
        } else {
            self.barStyle = CTNavigationBarStyleSecondary;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isRootController = NO;
        if (self.isRootController) {
            self.barStyle = CTNavigationBarStylePrimary;
        } else {
            self.barStyle = CTNavigationBarStyleSecondary;
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
    NSLog(@"loadView : this is %@", [self class]);
    [self preferNavigationBarStyle:self.barStyle];
    
    self.view.backgroundColor = RGBAColor(248, 248, 248, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear : this is %@", [self class]);
    [self preferNavigationBarStyle:self.barStyle];
}


#pragma mark - 导航部分
- (void)setNavigationTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)useDefaultBackButton
{
    //返回按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:[UIImage imageWithKey:@"btn_back_white.png"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageWithKey:@"btn_back_ios.png"] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBAColor(115,115,115, 1) forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    backButton.titleLabel.minimumScaleFactor = 0.8;
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backButton setTitleColor:RGBAColor(89, 89, 89, 1) forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 2, 70, 40);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:backButton];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
}

- (void)preferNavigationBarStyle:(CTNavigationBarStyle)style {
    self.barStyle = style;
    NSDictionary *primaryTitle = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName: RGBAColor(57, 57, 57, 1)};
    NSDictionary *secondaryTitle = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName: RGBAColor(255, 255, 255, 1)};
    switch (style) {
        case CTNavigationBarStyleSecondary:
        {
            self.navigationController.navigationBar.titleTextAttributes = secondaryTitle;
            UIImage *image = [UIImage imageWithColor:RGBAColor(24, 191, 84, 1)];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            break;
        }
        case CTNavigationBarStylePrimary:
        default: {
            self.navigationController.navigationBar.titleTextAttributes = primaryTitle;
            UIImage *image = [UIImage imageWithColor:RGBAColor(255, 255, 255, 1)];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            break;
        }
    }
    CALayer * bgLayer = [[self.navigationController.navigationBar.layer sublayers] objectAtIndex:0];
    if (1 == [[bgLayer sublayers] count]) {
        UIImage * maskimg = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        CALayer * maskLayer = [CALayer layer];
        
        maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, maskimg.size.height);
        maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        [bgLayer addSublayer:maskLayer];
    }
    
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (CTNavigationBarStylePrimary == self.barStyle) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

//移除或显示导航栏下方的横线
- (void)hideLineUnderNavigationBar:(BOOL)hidden {
    if (hidden) {
        // 添加上这一句，可以去掉导航条下边的shadowImage，就可以正常显示了
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        self.navigationController.navigationBar.shadowImage = nil;
        self.navigationController.navigationBar.translucent = YES;
    }
}

#pragma mark - action
//返回按钮
- (void)backButtonClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载状态
- (CTActivityIndicatorView *)indicatorView {
    if (nil == _indicatorView) {
        self.indicatorView = [[CTActivityIndicatorView alloc] init];
    }
    return _indicatorView;
}


- (void)startLoadingAtView:(UIView *)view center:(CGPoint)point {
    if (self.indicatorView.superview) {
        [self.indicatorView removeFromSuperview];
    }
    [view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    self.indicatorView.center = point;
}

- (void)startLoadingAtView:(UIView *)view {
    CGPoint point = CGPointMake(view.frame.size.width*0.5, view.frame.size.height*0.5);
    [self startLoadingAtView:view center:point];
}

- (void)startLoading {
    [self startLoadingAtView:self.view];
}

- (void)stopLoading {
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
}

#pragma mark - 旋转
- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [UIViewController attemptRotationToDeviceOrientation];
}

#pragma mark - 导航
+ (CTNavigationController *)navigationController {
    UITabBarController *tabbarCtrl = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ([tabbarCtrl isKindOfClass:[UITabBarController class]]) {
        CTNavigationController *navigationController = (CTNavigationController *)tabbarCtrl.selectedViewController;
        if ([navigationController isKindOfClass:[CTNavigationController class]]) {
            return navigationController;
        }
    } else if ([tabbarCtrl isKindOfClass:[CTNavigationController class]]) {
        return (CTNavigationController *)tabbarCtrl;
    }

    
    return nil;
}


@end
