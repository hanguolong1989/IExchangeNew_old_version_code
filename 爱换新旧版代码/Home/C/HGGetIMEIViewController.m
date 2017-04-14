//
//  HGGetIMEIViewController.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/3.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "HGGetIMEIViewController.h"
#import "LoginViewController.h"
@interface HGGetIMEIViewController ()
{
    UIView *bgView;
    CGRect originRect;//原始rect
    UIWindow *window;
    CGRect _original;
}

@property (weak, nonatomic) IBOutlet UIButton *gotoSetButton;

@property (weak, nonatomic) IBOutlet UIImageView *imagView_Pic;

@property(nonatomic,assign)CGPoint point;
@property (weak, nonatomic) IBOutlet UITextField *imeiField;

@end

@implementation HGGetIMEIViewController

//GoToSetUpIMEI  ID

//按钮颜色
-(void)buttonColor{
    _gotoSetButton.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX alpha:1.0];
}


//检验并进入登录界面
- (IBAction)startAutoCheck:(id)sender {
    NSString *IMEIString = [_imeiField.text stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    
    if (IMEIString.length >0 && IMEIString.length == 15 ) {
        
        
        [self.view endEditing:YES];
        
        LoginViewController *loginVC = (LoginViewController *)[STORYBOARD instantiateViewControllerWithIdentifier:@"HGLOGIN"];
        
        loginVC.imei = IMEIString;
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
        
    }else{
        [HGTools showMessage:@"IMEI不合法,请检查..."];
        
    }
    

}
//进入设置   (iOS10)
- (IBAction)GOTOSETUP:(id)sender {
    
if (IOS_VERSION >= 10.0) {
    
        //注意首字母改成了大写，prefs->Prefs
        NSURL*url=[NSURL URLWithString:@"Prefs:root=General&path=About"];
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
        [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:url withObject:nil];
    }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=General&path=About"]]){
        NSURL*url=[NSURL URLWithString:@"prefs:root=General&path=About"];
        [[UIApplication sharedApplication]openURL:url];
       
    }else{
         [CTPromptView showText:@"无法打开设置,请手动粘贴"];
    }
    
}


-(void)addPastBoardNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pasteboardChanged:) name:@"NEWIMEI" object:nil];
   
    
   
}




-(void)pasteboardChanged:(NSNotification *)sender{
    
    
    NSString *imei = sender.userInfo[@"IMEI"];

    switch (imei.length) {
        case 15:
        {
            
            if (_imeiField.text.length != 15) {
                
                _imeiField.text = imei;
                [HGTools showMessage:@"已自动粘贴"];
            }
        }
            break;
            
        default:
            [HGTools showMessage:@"刚复制错啦,请重新去复制"];
            break;
    }
    
    
    
 
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIPasteboardChangedNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buttonColor];
    [self setBackTitle];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlarge)];
    tap.numberOfTapsRequired = 2;
    [self.imagView_Pic addGestureRecognizer:tap];
    self.imagView_Pic.userInteractionEnabled = YES;
   
    
    
    [_imeiField setClearButtonMode:UITextFieldViewModeWhileEditing];
     
    
    window = [[[UIApplication sharedApplication] delegate] window];
   

    [self addPastBoardNotification];
    
    
    
    }

-(void)enlarge{

    CGRect rectInView = [self.view convertRect:self.imagView_Pic.frame toView:self.view];
    _original = rectInView;
    originRect = rectInView;
    _original = CGRectMake(_original.origin.x + (_original.size.width - _imagView_Pic.frame.size.width) / 2.f,
                           _original.origin.y + (_original.size.height - _imagView_Pic.frame.size.height) / 2.f,
                           _imagView_Pic.frame.size.width, _imagView_Pic.frame.size.height);
    
    UIImageView *imgView = [[UIImageView alloc] init];    //要显示的图片，即要放大的图片
   
    imgView.image = [UIImage imageNamed:@"koreaPhone.png"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.userInteractionEnabled = YES;
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)];
    [imgView addGestureRecognizer:tapGesture];

    tapGesture.numberOfTapsRequired = 1;
    
    [[UIApplication sharedApplication]
     setStatusBarHidden:YES
     withAnimation:UIStatusBarAnimationNone];
    imgView.frame = originRect;
    [window addSubview:imgView];
    
//    [UIView animateWithDuration:0.3 animations:^{
        imgView.frame = window.frame;
       
//    } completion:^(BOOL finished) {
//        
//    }];
}

-(void)closeView:(UITapGestureRecognizer *)sender{
    
    [[UIApplication sharedApplication]
     setStatusBarHidden:NO
     withAnimation:UIStatusBarAnimationFade];
    UIImageView *denImage = (UIImageView *) sender.view;
    [denImage removeFromSuperview];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_imeiField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
