//
//  GuiderViewController.m
//  IExchangeNew-Salesman
//
//  Created by Hind on 16/7/26.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "GuiderViewController.h"
#import "HGBaseNavigationController.h"
#import "NSString+HGMD5.h"
 #import <sys/mount.h>
@interface GuiderViewController()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation GuiderViewController


- (void)loadView {
    [super loadView];
    
    

    
}


//设置背景图
-(void)setDefaultImage{
    
    if (SCREEN_HEIGHT == 480) {
        self.bgImageView.image = [UIImage imageNamed:@"Default"];
    } else if (SCREEN_HEIGHT == 568) {
        self.bgImageView.image = [UIImage imageNamed:@"Default_568h"];
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"Default_667h"];
    }
    
    UIImage *orginImage = [UIImage imageWithColor:RGBAColor(24, 191, 84, 1)];
    [self.registerButton setBackgroundImage:orginImage forState:UIControlStateNormal];
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = YES;
    _registerButton.layer.shadowColor = [UIColor redColor].CGColor;
    _registerButton.layer.shadowOffset = CGSizeMake(10, 2);
    
}

//按钮渐变动画
-(void)buttonAnimation{
    
    
    _registerButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:2 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _registerButton.transform = CGAffineTransformMakeScale(1, 1);

    } completion:^(BOOL finished) {
        
//        NSLog(@"“开始检测”按钮出现，可以检测");
    }];

    
    
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setDefaultImage];
    [self buttonAnimation];
    NSLog(@"手机总存储空间为：%0.2f GB", [UIDevice allDiskSpaceInBytes]/1024.0/1024.0/1024.0); //√
    NSLog(@"新版--手机总存储空间%@",[self getTotalDiskSize]);
    NSLog(@"手机剩余存储空间为：%0.2f GB", [UIDevice freeDiskSpaceInBytes]/1024.0/1024.0/1024.0); //√
   
 
    NSLog(@"设备名称:%@",[HGTools getDeviceInfo]);
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

//    [HGTools alertWithTitle:@"设备名称" message:[HGTools getDeviceInfo] viewController:self];
    
}
-(NSString *)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    
    NSInteger KB = 1000;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (freeSpace < 10)  {
        return @"0 B";
    }else if (freeSpace < KB)    {
        return @"< 1 KB";
    }else if (freeSpace < MB)    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)freeSpace)/KB];
    }else if (freeSpace < GB)    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)freeSpace)/MB];
    }else   {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)freeSpace)/GB];
    }

}
- (IBAction)registerButtonClick:(id)sender {

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    HGBaseNavigationController *myTabvc = [STORYBOARD instantiateViewControllerWithIdentifier:@"HGLBASENAVI"];
    window.rootViewController = myTabvc;
 
    
}


@end
