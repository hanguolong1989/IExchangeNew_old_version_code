//
//  LoginViewController.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/5.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "LoginViewController.h"
#import "AutoCheckViewController.h"

@interface LoginViewController ()<UINavigationControllerDelegate>
{
    UIActivityIndicatorView *_myActivityView;//菊花
    NSTimer *countDownTimer;//倒计时器
    int time;
    NSMutableDictionary *phoneInfoJsonIphone;//手机信息
}

//绿色背景图
@property (weak, nonatomic) IBOutlet UIImageView *topBackgroundImageView;


//密码框背景栏
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;

//小锁子logo
@property (weak, nonatomic) IBOutlet UIImageView *lockLogoImageView;

//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;


//提示文字label
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *juhua;

//登录label的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTextWidth;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;


//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

//阴影层
@property (weak, nonatomic) IBOutlet UIView *shadowView;

//登录距离上个控件高度,原31，点击后下移5.5，优化完了之后恢复
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTopSpace;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self manualSet];
  
    self.navigationItem.title = @"登录";
    //将导航栏左边返回按钮内容改为@“返回”
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [ self statusBarWhite];
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:SYSTEM_HEX alpha:1.0]];

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage= [[UIImage alloc] init];
    
//   _authCodeTextField.text = @"466835";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(changeAddress)];
    self.navigationItem.rightBarButtonItem = right;
    
}




-(void)changeAddress{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置地址" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        
        
        NSString *currentAddress = [HGTools returnStr: @"http://192.168.1.55:8088" ifObjIsRealNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"NetAddress"]];
        textField.text = currentAddress;
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSArray *fieldsArray = alert.textFields;
        
        UITextField *field = fieldsArray.firstObject;
        
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        //        ;
        [def setObject:field.text forKey:@"NetAddress"];
        [def synchronize];
        if ([def synchronize]) {
            [HGTools showMessage:@"设置成功"];
        }else{
            [HGTools showMessage:@"设置失败"];
        }
        
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:sure];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      _myActivityView.center = _juhua.center;
}

//-(void)statusBarWhite{
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
//}
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
//}

//设置尺寸颜色等信息
-(void)manualSet{
    _topBackgroundImageView.image = [UIImage imageNamed:@"loginBg.png"];
    _roundLabel.layer.cornerRadius = 45.0/2;
    _roundLabel.layer.masksToBounds = YES;
    _roundLabel.layer.borderColor = [UIColor colorWithHexString:SYSTEM_HEX alpha:1.0].CGColor;
    _roundLabel.layer.borderWidth = 1.0f;
    _roundLabel.backgroundColor = [UIColor clearColor];
    _lockLogoImageView.image = [UIImage imageNamed:@"lockLogo.png"];
    
    
    
    _loginButton.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX alpha:1.0];
    CALayer *layer2 = _loginButton.layer;
    layer2.cornerRadius = 45.0/2;
    layer2.masksToBounds = YES;
    
    
    //////////////////////////////
    //////////////////////////////
    /////////实现阴影//////////////
    /////////////////////////////
    /////////////////////////////
    CALayer *shadow = _shadowView.layer;

    _shadowView.backgroundColor = [UIColor colorWithHexString:@"#6cda6c" alpha:1.0];
    shadow.shadowColor = [UIColor colorWithHexString:@"#6cda6c" alpha:1.0].CGColor;
    shadow.shadowOffset = CGSizeMake(0, 5);
    shadow.shadowOpacity = 0.5;
    shadow.shadowRadius = 2;
    shadow.cornerRadius = 45.0/2;
       //自定义颜色placeholder
    _authCodeTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入授权码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#a3a3a3" alpha:1.0]}];

    _authCodeTextField.font = [UIFont systemFontOfSize:14.0];
    
    
    
       //////////////////////////////
    //////////////////////////////
    /////////倒计时文字/////////////11.11.2016取消
    /////////////////////////////
    /////////////////////////////
    
//       countDownTimer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabel:) userInfo:nil repeats:YES];
//    
//    [[NSRunLoop currentRunLoop]addTimer:countDownTimer forMode:NSRunLoopCommonModes];
    
    //////////////////////////////
    //////////////////////////////
    /////////登录菊花//////////////
    /////////////////////////////
    /////////////////////////////
    _myActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _myActivityView.center = _juhua.center;
    [self.view addSubview:_myActivityView];

    
    
}


//登录事件

- (IBAction)newLoginAction:(id)sender {
   

    
    [self postData];
}


#pragma mark - handle data
- (void)postData {
    
    NSString *temp = [self.authCodeTextField.text trim];
    NSString *authCode = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //获取设备基础信息并传至后台
    [self getPhoneInfo:authCode];
    
    if (authCode.length > 0) {
        [self.view endEditing:YES];
        
    //平台信息, 1：安卓；2：苹果
        
        NSString *phoneType = @"2";

        NSDictionary *params = @{@"authCode":authCode,
                                 @"phoneInfoJsonIphone":[HGTools dictionaryToJSON:phoneInfoJsonIphone],
                                 @"phoneType":phoneType};
        
        
        
        
        [_myActivityView  startAnimating];
      
        _loginButton.userInteractionEnabled = NO;//开始登录，关掉用户交互
      
        [HGTools POST:NEW_LOGIN_AUTHCODE params:params success:^(id response) {
            
            NSLog(@"使用authCode登录返回信息:%@",response);
 
            NSDictionary *dic = [response objectForKey:@"data"];
            
            [_myActivityView stopAnimating];
            _loginButton.userInteractionEnabled = YES;
            
            NSString * status = [dic objectForKey:@"status"];
            
            
            if ([status isEqualToString:@"SUCCESS"] ) {
                
//                _authCodeTextField.text = nil;
                
                NSDictionary *resultDic = [dic objectForKey:@"result"];
                
                AutoCheckViewController *autoCheckVC = [STORYBOARD instantiateViewControllerWithIdentifier:@"AUTOCHECKVC"];
                autoCheckVC.infoId = [resultDic objectForKey:@"infoId"];
                autoCheckVC.authCode = authCode;
                autoCheckVC.resultData = resultDic;
                
                [self.navigationController pushViewController:autoCheckVC animated:YES];
                
                
            } else {

                [HGTools showMessage:[HGTools returnStr:@"验证失败，请重试" ifObjIsRealNull:[dic objectForKey:@"message"]]];
            }
            
            
            
        } failure:^(NSURLSessionDataTask *Task, NSError *error) {
            
            [_myActivityView stopAnimating];
            _loginButton.userInteractionEnabled = YES;
            [HGTools showMessage:error.localizedDescription];
            
        }];

    } else {
        [CTPromptView showText:@"请输入授权码"];
    }
}


/**
 获取设备信息

 @param authCode 授权码
 */
-(void)getPhoneInfo:(NSString *)authCode{
    //DeviceBasebandVersion
    NSString *DeviceBasebandVersion = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice basebandFirmwareVersion]];
    //设备构建版本
    NSString *deviceBuildVersion = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice deviceBuildVersion]];
    //设备固件版本
    NSString *deviceFirmwareVersion = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice deviceFirmwareVersion]];
    
    //设备颜色
    NSString *deviceColor = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice deviceColor]];
    //产品类型
    NSString *DeviceProductType = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice machineCode]];
    //        NSString *DeviceProductType = @"iphone7,1";
    //设备类型
    NSString *DeviceClass = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice currentDevice].model];
    //销售地区
    NSString *regionInfo = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice regionInfo]];
    //CPU架构
    NSString *DeviceCpuArchitecture = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice cpuArchitecture]];
    //系统版本
    NSString *systemVersion = [HGTools returnStr:@"" ifObjIsRealNull:[[UIDevice currentDevice] systemVersion]];
    //型号
    NSString *modelNumber = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice modelNumber]];
    //序列号
    NSString *serialNumber = [HGTools returnStr:@"" ifObjIsRealNull:[UIDevice serialNumber]];
    //是否越狱
    NSString *isJailBreak = @"n";
    if ([UIDevice isJailBreak]) {
        isJailBreak = @"y";
    }
    NSInteger memory = ceilf([UIDevice allDiskSpaceInBytes]/1024.0/1024.0/1024.0);
    //内存
    NSString *MobileMemory = [NSString stringWithFormat:@"%@", @(memory)];
    
    //IMEI号
    NSString *imei = self.imei;


    //设备激活状态
    NSString *DeviceActivationState = @"y";
    //设备基带引导装载版本
    NSString *DeviceBasebandBootloaderVersion = @"";
    //设备标记
//    NSString *DeviceId = @"";
    //是否有锁
    NSString *IsLock = @"n";
    //产品识别码ID
    NSString *ProductId = @"";
    //供应商ID
    NSString *VendorId = @"";
    //制造商
    NSString *UsbManufacturer = @"Apple Inc.";
    NSString *UsbProduct = @"";
    //硬件版本
    NSString *DeviceVersion = @"";
    
    phoneInfoJsonIphone = [NSMutableDictionary dictionary];
    
    
    [phoneInfoJsonIphone setObject:authCode forKey:@"token"];
    
    [phoneInfoJsonIphone setObject:DeviceActivationState forKey:@"DeviceActivationState"];
    
    [phoneInfoJsonIphone setObject:DeviceBasebandBootloaderVersion forKey:@"DeviceBasebandBootloaderVersion"];
    
    [phoneInfoJsonIphone setObject:DeviceBasebandVersion forKey:@"DeviceBasebandVersion"];
    
    [phoneInfoJsonIphone setObject:deviceBuildVersion forKey:@"DeviceBuildVersion"];
    
    [phoneInfoJsonIphone setObject:deviceFirmwareVersion forKey:@"DeviceFirmwareVersion"];
    
    [phoneInfoJsonIphone setObject:imei forKey:@"DeviceId"];
    
    [phoneInfoJsonIphone setObject:deviceColor forKey:@"DeviceDeviceColor"];
    
    [phoneInfoJsonIphone setObject:DeviceProductType forKey:@"DeviceProductType"];
    
    [phoneInfoJsonIphone setObject:DeviceClass forKey:@"DeviceClass"];
    
    [phoneInfoJsonIphone setObject:regionInfo forKey:@"DeviceRegionInfo"];
    
    [phoneInfoJsonIphone setObject:imei forKey:@"InternationalMobileEquipmentIdentity"];
    
    [phoneInfoJsonIphone setObject:DeviceCpuArchitecture forKey:@"DeviceCpuArchitecture"];
    
    [phoneInfoJsonIphone setObject:systemVersion forKey:@"ProductVersion"];
    
    [phoneInfoJsonIphone setObject:modelNumber forKey:@"ModelNumber"];
    
    [phoneInfoJsonIphone setObject:serialNumber forKey:@"SerialNumber"];
    
    [phoneInfoJsonIphone setObject:isJailBreak forKey:@"Jailbroken"];
    
    [phoneInfoJsonIphone setObject:IsLock forKey:@"IsLock"];
    
    [phoneInfoJsonIphone setObject:ProductId forKey:@"ProductId"];
    
    [phoneInfoJsonIphone setObject:VendorId forKey:@"VendorId"];
    
    [phoneInfoJsonIphone setObject:UsbManufacturer forKey:@"UsbManufacturer"];
    
    [phoneInfoJsonIphone setObject:UsbProduct forKey:@"UsbProduct"];
    
    [phoneInfoJsonIphone setObject:DeviceVersion forKey:@"DeviceVersion"];
    
    [phoneInfoJsonIphone setObject:MobileMemory forKey:@"MobileMemory"];
}

-(void)refreshLabel:(NSTimer *)sender{
    
    time --;
    

    if (time == 0) {
        
        //计时结束后移除计时器
        [countDownTimer invalidate];
        
        NSAttributedString *validTime = [[NSAttributedString alloc] initWithString:@"输入时间已过期" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        
        
        _titleLabel.attributedText = validTime;
    }else{
        
        NSString *title = @"*请在";
        NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",time]];
        NSMutableAttributedString *after = [[NSMutableAttributedString alloc]initWithString:@"秒内输入授权码"];
        
        
        NSMutableAttributedString *muString = [[NSMutableAttributedString alloc]initWithString:title];
        
        [self changeColor:muString hexString:@"#474747"];
        [self changeColor:timeString hexString:@"#e57a27"];
        [self changeColor:after hexString:@"#474747"];
        
        [muString appendAttributedString:timeString];
        [muString appendAttributedString:after];
        
        
        _titleLabel.attributedText = muString;
    }
    
}

//给可变字符串添加颜色

-(void)changeColor:(NSMutableAttributedString *)string
         hexString:(NSString *)hex{
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:hex alpha:1.0]} range:NSMakeRange(0, string.length)];
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
