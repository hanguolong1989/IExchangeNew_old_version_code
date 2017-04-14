//
//  CTNavigationController.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTNavigationController.h"

@interface CTNavigationController ()

@end

@implementation CTNavigationController

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"";
    
    NSDictionary *secondaryTitle = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName: RGBAColor(57, 57, 57, 1)};
    
    self.navigationBar.titleTextAttributes = secondaryTitle;

    UIImage *backgroundImg = [UIImage imageWithColor:RGBAColor(24, 191, 84, 1)];
    [self.navigationBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_VERSION >= 7) {
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([self.topViewController isKindOfClass:NSClassFromString(@"MAScoresDetailViewController")] || [self.topViewController isKindOfClass:NSClassFromString(@"MASettingViewController")]) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}



@end
