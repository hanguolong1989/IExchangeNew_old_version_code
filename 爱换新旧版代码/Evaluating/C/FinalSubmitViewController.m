//
//  FinalSubmitViewController.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/10.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "FinalSubmitViewController.h"

@interface FinalSubmitViewController ()



@property (weak, nonatomic) IBOutlet UILabel *iPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *storageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pandaImageView;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;

@property (weak, nonatomic) IBOutlet UILabel *lookPeopleLabel;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (weak, nonatomic) IBOutlet UIView *shadowView;


@end

@implementation FinalSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"评测结果";
    NSString *iPhoneName = [HGTools getDeviceInfo];
    NSString *flash = [HGTools getDeviceFlash];
    NSString *storage = [self returnStorage];
    
 
    self.navigationItem.hidesBackButton =YES;
    
    //手机名称
    _iPhoneLabel.text = iPhoneName;
    
    NSMutableAttributedString *headString = [[NSMutableAttributedString alloc]initWithString:@"内存: "];
    NSMutableAttributedString *flashString = [[NSMutableAttributedString alloc]initWithString:flash];
    NSMutableAttributedString *storageName = [[NSMutableAttributedString alloc]initWithString:@" ┃ 容量:"];
    NSMutableAttributedString *storageString = [[NSMutableAttributedString alloc]initWithString:storage];
    
    [headString appendAttributedString:flashString];
    [headString appendAttributedString:storageName];
    [headString appendAttributedString:storageString];
    //内存规格
    _storageLabel.attributedText = headString;
    
    _finishLabel.textColor = [UIColor colorWithHexString:@"#474747"];
    _lookPeopleLabel.textColor = [UIColor colorWithHexString:@"#a4a4a4"];
    
    _finishButton.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX];
    
    
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
    
    CALayer *layer2 = _finishButton.layer;
    layer2.cornerRadius = 45.0/2;
    layer2.masksToBounds = YES;
}

-(NSString *)returnStorage{
    
    float allDiskSpace = [UIDevice allDiskSpaceInBytes]/1024.0/1024.0/1024.0;
    
    
    if (allDiskSpace < 4) {
        return @"4GB";
    }else if ( allDiskSpace < 8  && allDiskSpace > 4 ){
        return @"8GB";
    }else if (allDiskSpace < 16 && allDiskSpace >8){
        return @"16GB";
    }else if (allDiskSpace < 32 && allDiskSpace > 16){
        return @"32GB";
    }else if (allDiskSpace < 64 && allDiskSpace >32){
        return @"64GB";
    }else if (allDiskSpace < 128 && allDiskSpace > 64){
        return @"128GB";
    }else if(allDiskSpace < 256 && allDiskSpace > 128){
        return @"256GB";
    }else{
        return @"unKnow";
    }
    
    
}
- (IBAction)finalSubmit:(id)sender {
    
     [self.navigationController popToRootViewControllerAnimated:YES];
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
