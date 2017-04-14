//
//  AutoCheckViewController.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/7.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "AutoCheckViewController.h"

#import "HGAutoCheckCollectionReusableView.h"

#import "HGAutoCheckCollectionViewCell.h"

#import "EvaluatingSectionView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Endian.h>
#import "AudioSessionManager.h"
#import "PhoneMessageModel.h"
#import "PhoneOptionModel.h"
#import "PhoneOptionCell.h"
#import "LoadingView.h"
#import "ManualCheckViewController.h"
@interface AutoCheckViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AVCaptureFileOutputRecordingDelegate>{
    
    
}

//背景图
@property (weak, nonatomic) IBOutlet UIImageView *checkBackgroundImageView;

//collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

//下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property(nonatomic,strong)NSArray*reuseNameArray;
@property(nonatomic,strong)NSDictionary*detaiDictionary;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTop;

@end


NSString static *kReuseID = @"autoCheckReuse";
NSString static *kCollectionCheckCell = @"collectionCheckCell";

@implementation AutoCheckViewController

-(void)yiduilog{
    NSLog(@"手机型号: %@", [UIDevice machineCode]);
    NSLog(@"Serial Number: %@", [UIDevice serialNumber]);
    NSLog(@"CPU架构: %@", [UIDevice cpuArchitecture]);
    NSLog(@"是否越狱: %@", @([UIDevice isJailBreak]));
    
    
    NSLog(@"设备基带版本: %@", [UIDevice basebandFirmwareVersion]);
    NSLog(@"设备固件版本: %@", [UIDevice deviceFirmwareVersion]);
    NSLog(@"型号: %@", [UIDevice modelNumber]);
    NSLog(@"销售地区: %@", [UIDevice regionInfo]);
    NSLog(@"设备构建版本: %@", [UIDevice deviceBuildVersion]);
    NSLog(@"设备颜色: %@", [UIDevice deviceColor]);
    
    
    NSLog(@"听筒是否可用：%@", @([UIDevice receiverAvailable]));
    NSLog(@"扬声器是否可用：%@", @([UIDevice speakerAvailable]));
    
    BOOL frontCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    BOOL rearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
    NSLog(@"前置摄像头是否可用：%@", @(frontCamera));
    NSLog(@"后置摄像头是否可用：%@", @(rearCamera));
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSLog(@"闪光灯是否可用: %@", @(device.hasTorch && device.hasFlash && device.torchActive));//√
    
    NSLog(@"GPS传感器是否可用: %@", @([CLLocationManager locationServicesEnabled]));
    NSLog(@"数字指南针是否可用: %@", @([CLLocationManager headingAvailable]));
    
    NSLog(@"麦克风是否可用: %@", @([UIDevice microphoneAvailable]));
    
    NSLog(@"陀螺仪是否可用: %@", @([UIDevice gyroscopeAvailable]));
    
    NSLog(@"加速传感器是否可用: %@", @([UIDevice accelerometerAvailable]));
    
    //    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    //    NSLog(@"传感器是否可用: %@", @([UIDevice currentDevice].proximityMonitoringEnabled));//?
    
    NSLog(@"手机总存储空间为：%0.2f GB", [UIDevice allDiskSpaceInBytes]/1024.0/1024.0/1024.0); //√
    NSLog(@"手机剩余存储空间为：%0.2f GB", [UIDevice freeDiskSpaceInBytes]/1024.0/1024.0/1024.0); //√
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self checkNet];
    
    [self yiduilog];
    
    
    self.navigationItem.title = @"自动检测";
    // Do any additional setup after loading the view.
    _nextButton.layer.cornerRadius = 45.0/2;
    _nextButton.layer.masksToBounds = YES;
    [self buttonGray];
    [self setupData];
    [self collectionViewAbout];
    _myCollectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    
    
}

- (void)setupData {
    
    NSDictionary *estimateOptions = [self.resultData objectForKey:@"estimateOptions"];
    NSDictionary *autoDic  = estimateOptions[@"auto"];
    
    self.dataList = [NSMutableArray array];
    
    NSDictionary *array = autoDic[@"typeData"];
    
  
    NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor  sortDescriptorWithKey:@"groupId" ascending:YES]];
    
    NSArray *typeData = [array.allValues sortedArrayUsingDescriptors:sort];
    
    

    for (NSDictionary *section in typeData) {
        
        NSString *title = [section stringForKey:@"title"];
        
        NSMutableArray *rowData = [NSMutableArray array];
        
        NSDictionary *groupDic = [section objectForKey:@"groupData"];
        NSArray *groupData = groupDic.allValues;
        

        NSString *imageName = nil;
        if ([title isEqualToString:@"手机基本信息"]) {
            imageName = @"logo_auto_check_message";
            
            PhoneOptionModel *optionModel = [[PhoneOptionModel alloc] initWithKey:@"型号" name:@"型号" options:nil optionId:nil];
            [rowData addObject:optionModel];
        } else if ([title isEqualToString:@"手机光学功能"]) {
            imageName = @"logo_auto_check_optics";
        } else if ([title isEqualToString:@"手机通话功能"]) {
            imageName = @"logo_auto_check_phone";
        } else if ([title isEqualToString:@"手机辅助功能"]) {
            imageName = @"logo_auto_check_auxiliary";
        } else {
            imageName = @"logo_auto_check_message";
        }
        
        
        
        for (NSDictionary *option in groupData) {
            NSString *title = [option stringForKey:@"title"];
            NSArray *options = [option objectForKey:@"options"];
            NSNumber *optionId = [option objectForKey:@"id"];
            PhoneOptionModel *optionModel = [[PhoneOptionModel alloc] initWithKey:title name:title options:options optionId:optionId];
            [rowData addObject:optionModel];
        }
        PhoneMessageModel *model = [[PhoneMessageModel alloc] initWithKey:title name:title imageName:imageName rowData:rowData];
        
        
        [self.dataList addObject:model];
        
    }
}

/**
 * 设置信息
 *
 *
 */
-(void)buttonGray{
    
    _nextButton.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:1.0];
    _nextButton.userInteractionEnabled = NO;

}
-(void)buttonGreen{
    UIImage *orginImage = [UIImage imageWithColor:RGBAColor(24, 191, 84, 1)];
    [_nextButton setBackgroundImage:orginImage forState:UIControlStateNormal];
    _nextButton.userInteractionEnabled = YES;

}

#pragma mark - collectionView设置
-(void)collectionViewAbout{

    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HGAutoCheckCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCollectionCheckCell];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"HGAutoCheckCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseID];
//    _myCollectionView.showsVerticalScrollIndicator = YES;
    
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //分区头尺寸
//    NSInteger whatEver = 2;
    layout.headerReferenceSize = CGSizeMake(0,35);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    layout.sectionInset = (UIEdgeInsets){0, 20, 0, 20};
//    layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    

    _myCollectionView.collectionViewLayout = layout;
 
}


#pragma mark - 可复用头视图

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HGAutoCheckCollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseID forIndexPath:indexPath];
    
    NSArray *imageNamesArray = @[@"autoCheck_info.png",@"autoCheck_camera",@"autoCheck_telePhone",@"autoCheck_setup"];
    NSArray *fourNames = @[@"手机基本信息",@"手机光学功能",@"手机通话功能",@"手机辅助功能"];
    
    NSInteger index = indexPath.section;
    
    NSString *imageName = imageNamesArray[index];
    NSString *labelName = fourNames[index];
    reuseView.iconImageView.image = [UIImage imageNamed:imageName];
    reuseView.titleLabel.text = labelName;
 
    return reuseView;

    
}

- (IBAction)startCheck:(id)sender {

    
        
        [self startAutocheck];
        
        [self buttonGreen];
        [self.myCollectionView reloadData];
        
        _checkBackgroundImageView.image = [UIImage imageNamed:@"autoCheck_finished.png"];
        _checkBackgroundImageView.userInteractionEnabled = NO;
   
    
    
    
    
}


- (IBAction)gotoManual:(id)sender {
    
    NSLog(@"自动检测结果-----%@",self.dataList);
    
    for (NSDictionary *model in self.dataList) {
        
        
        NSLog(@"model=====%@",model);
        
        
    }
    
    ManualCheckViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"HGMANUALCHECK"];
    ctrl.autoCheckData = self.dataList;
    ctrl.resultData = self.resultData;
    ctrl.authCode = self.authCode;
    ctrl.infoId = self.infoId;
    
    

    [self.navigationController pushViewController:ctrl animated:YES];
}



//开始自动检测
- (void)startAutocheck{
    
    
    LoadingView *loadView = [LoadingView hgLoadingView];
    [loadView infoWithImageName:@"pandaWithPhone.png" title:@"正在检测..." detailTitle:@"正在对此设备进行自动评测，请勿中断，稍后将完成评测"];
    [loadView show:self];
    
    for (PhoneMessageModel *model in self.dataList) {
        
        for (PhoneOptionModel *option in model.rowData) {
            
            if ([option.key isEqualToString:@"型号"]) {
                //型号
                
                option.data = [self.resultData objectForKey:@"model"];
//                option.data = [HGTools getDeviceInfo];
                NSLog(@"系统自检手机型号%@",option.data);
                option.status = PhoneOptionStatusAvailable;
                
                
            }else if ([option.key isEqualToString:@"版本"]) {
                
                
                NSArray *options = option.options;
                NSNumber *optionId = option.optionId;
                NSString *key = nil;
                //版本
                if ([[UIDevice regionCode] isEqualToString:@"CH"]) {
                    //国行
                    key = @"国行";
                } else if ([[UIDevice regionCode] isEqualToString:@"ZP"]) {
                    //香港
                    key = @"港版";
                } else if ([[UIDevice regionCode] isEqualToString:@"J"]) {
                    //日版
                    key = @"日版";
                } else {
                    //其他
                    key = @"其他";
                }
                for (NSDictionary *tmpOption in options) {
                    NSString *subTitle = [tmpOption stringForKey:@"subTitle"];
                    NSNumber *subId = [tmpOption objectForKey:@"subId"];
                    if ([subTitle isEqualToString:key]) {
                        option.value = [NSDictionary dictionaryWithObjectsAndKeys:subId, optionId, nil];
                        break;
                    }
                }
                option.data = key;
                option.status = PhoneOptionStatusAvailable;
            }else if ([option.key isEqualToString:@"购买渠道"]) {
                
                
                NSArray *options = option.options;
                NSNumber *optionId = option.optionId;
                NSString *key = nil;
                //版本
                if ([[UIDevice regionCode] isEqualToString:@"CH"]) {
                    //国行
                    key = @"大陆";
                } else if ([[UIDevice regionCode] isEqualToString:@"ZP"]) {
                    //香港
                    key = @"港/澳";
                } else if ([[UIDevice regionCode] isEqualToString:@"J"]) {
                    //日版
                    key = @"其他";
                } else {
                    //其他
                    key = @"卡贴机";
                }
                for (NSDictionary *tmpOption in options) {
                    NSString *subTitle = [tmpOption stringForKey:@"subTitle"];
                    NSNumber *subId = [tmpOption objectForKey:@"subId"];
                    if ([subTitle isEqualToString:key]) {
                        option.value = [NSDictionary dictionaryWithObjectsAndKeys:subId, optionId, nil];
                        break;
                    }
                }
                option.data = key;
                option.status = PhoneOptionStatusAvailable;
            } else if ([option.key isEqualToString:@"内存"]) {
                //内存
                
                
                NSArray *options = option.options;
                NSNumber *optionId = option.optionId;
                option.status = PhoneOptionStatusAvailable;
                float allDiskSpace = [UIDevice allDiskSpaceInBytes]/1024.0/1024.0/1024.0;
                NSLog(@"开启自动评测-----------内存%f-----------",allDiskSpace);
                
                
                NSString *factValue = [self returnStorage:allDiskSpace];
                
                //由于后台返回数据会出现bug，所以目前本地判断出手机容量并传给后台，暂时没发现bug，待后期验证..11-15-2016
                NSNumber *subId = [self returnSubId];
                option.value = [NSDictionary dictionaryWithObjectsAndKeys:subId, optionId, nil];
                option.data = factValue;
                //options里面包含内存键值对，一一取出对比并拿到其id对比(原)
//                for (NSDictionary *tmpOption in options) {
//                    NSString *subTitle = [tmpOption stringForKey:@"subTitle"];
//                    
//                    if ([subTitle floatValue] >= allDiskSpace) {
//                        NSNumber *subId = [tmpOption objectForKey:@"subId"];
//                        option.value = [NSDictionary dictionaryWithObjectsAndKeys:subId, optionId, nil];
//                        option.data = subTitle;
//                        
//                        break;
//                    }
//                    
//                }
            } else if ([option.key isEqualToString:@"后置摄像头"]) {
                //后置摄像头
                BOOL rearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
             
                
                if (rearCamera) {
                    BOOL hasCamera = NO;
                    AVCaptureDeviceInput *inputCamera;
                    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
                    for (AVCaptureDevice *camera in cameras) {
                        if ([camera position] == AVCaptureDevicePositionBack) {
                            NSError *error = nil;
                            inputCamera = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
                            if (nil != inputCamera && nil == error) {
                                hasCamera = YES;
                                break;
                            }
                        }
                    }
                    option.data = @"";
                    if (hasCamera) {
                        [option setNormal:YES];
                    } else {
                        [option setNormal:NO];
                    }

                    
                } else {
                    [option setNormal:NO];
                }
                
            } else if ([option.key isEqualToString:@"前置摄像头"]) {
                
                //前置摄像头
                BOOL frontCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
                
                if (frontCamera) {
                    BOOL hasCamera = NO;
                    AVCaptureDeviceInput *inputCamera;
                    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
                    for (AVCaptureDevice *camera in cameras) {
                        if ([camera position] == AVCaptureDevicePositionFront) {
                            NSError *error = nil;
                            inputCamera = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
                            if (nil != inputCamera && nil == error) {
                                hasCamera = YES;
                                break;
                            }
                        }
                    }
                    option.data = @"";
                    if (hasCamera) {
                        [option setNormal:YES];
                    } else {
                        [option setNormal:NO];
                    }
                    
                } else {
                    [option setNormal:NO];
                }
                
                
                
            } else if ([option.key isEqualToString:@"闪光灯"]) {
                //闪光灯

                BOOL hasTorch;
                option.data = @"";
                
                Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
                if (captureDeviceClass != nil) {
                    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                    if ([device hasTorch] && [device hasFlash]){
                        
                        
                        
                        hasTorch = YES;
                        [device lockForConfiguration:nil];
                        [device setTorchMode:AVCaptureTorchModeOn];
                        [device setFlashMode:AVCaptureFlashModeOn];
                        [device unlockForConfiguration];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) NSEC_PER_SEC * 1), dispatch_get_main_queue(), ^{
                            
                            [device lockForConfiguration:nil];
                            [device setTorchMode:AVCaptureTorchModeOff];
                            [device setFlashMode:AVCaptureFlashModeOff];
                            [device unlockForConfiguration];
                            
                        });
                    }else{
                        hasTorch = NO;
                    }
                    
                    
                }
                
                [option setNormal:hasTorch];
                
            } else if ([option.key isEqualToString:@"麦克风"]) {
                //麦克风
                BOOL active = [UIDevice microphoneAvailable];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
            } else if ([option.key isEqualToString:@"扬声器"]) {
                //扬声器
                BOOL active = [UIDevice speakerAvailable];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
                
                //播放系统声音
                SystemSoundID soundId = 1007;
                AudioServicesPlaySystemSound(soundId);
               
                
            } else if ([option.key isEqualToString:@"听筒"]) {
                //听筒
                BOOL active = [UIDevice receiverAvailable];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
            } else if ([option.key isEqualToString:@"振动传感器"]) {
                //振动传感器
                 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动

                
                [self vibrate:option indexPath:[NSIndexPath indexPathForItem:1 inSection:3]];

            } else if ([option.key isEqualToString:@"无线功能"]) {
                //无线功能
                Reachability *reach = [Reachability reachabilityForLocalWiFi];
                BOOL active = [reach isReachableViaWiFi];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }

                
            } else if ([option.key isEqualToString:@"GPS传感器"]) {
                //GPS 传感器
                BOOL active = [CLLocationManager locationServicesEnabled];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
            } else if ([option.key isEqualToString:@"数字指南针"]) {
                //数字指南针
                BOOL active = [CLLocationManager headingAvailable];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
            } else if ([option.key isEqualToString:@"加速感应器"]) {
                //加速感应器
                BOOL active = [UIDevice accelerometerAvailable];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
            } else if ([option.key isEqualToString:@"陀螺仪"]) {
                //陀螺仪
                BOOL active = [UIDevice gyroscopeAvailable];
                option.data = @"";
                if (active) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
            }
            
            
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC * 2), dispatch_get_main_queue(), ^{
        
        
        [loadView dismiss];
        
    });

    
    
    

}


/**
 震动弹窗手动选择

 @param option 选择
 @param indexPath 手机选项
 */
-(void)vibrate:(PhoneOptionModel *)option
     indexPath:(NSIndexPath *)indexPath{
    
    HGAertView *hgView = [HGAertView hgAlertView];
    
    [hgView newSelectTextTitle:@"震动手动选择" rightIconName:nil phoneColor:NO secondTitle:@"点击按钮来检测震动" middleButtonTitle:@"检测震动" thirdTitle:@"请选择是否感受到手机震动" selectMiddle:^(UIButton *middleButton) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    } buttonNameArray:@[@"有震动",@"无震动"] selectOther:^(UIButton *selectButton, NSString *selectTitle) {
        
        if ([selectTitle isEqualToString:@"有震动"]) {
            [option setNormal:YES];
            [_myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            
        }else{
            [option setNormal:NO];
            [_myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            
        }
        
    }];
    

    [hgView myShow:self];
    
}

-(void)checkNet{
   
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status)
        {
            case NotReachable:
            {
                [HGTools showMessage:@"wifi连接失败"];
        
                break;
            }
                
            case ReachableViaWiFi:
            {
      
                break;
            }
                
            case ReachableViaWWAN:
            {
                //  case ReachableViaWWAN handler
                break;
            }
            default:
                break;
        }
    }];


}
#pragma mark - collectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HGAutoCheckCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCheckCell forIndexPath:indexPath];
 
    PhoneMessageModel *sectionModel = [self.dataList objectAtIndex:indexPath.section];
    
    PhoneOptionModel *optionModel = [sectionModel.rowData objectAtIndex:indexPath.row];
    
    [cell updateCellWithData:optionModel];
    
    

    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.item == 1 && indexPath.section == 3) {//震动
    
        for (PhoneMessageModel *model in self.dataList) {
            
            for (PhoneOptionModel *option in model.rowData) {
                
                if ([option.key isEqualToString:@"振动传感器"]) {
                    [self vibrate:option indexPath:indexPath];
                    [_myCollectionView reloadItemsAtIndexPaths:@[indexPath]];

                }
            }
        }
        
        
        
        
//    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section != 3) {
        return 3;
    }
    
    return 6;
}

#pragma mark ---- UICollectionViewDelegate And FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREEN_WIDTH - 80)/3 ,((SCREEN_WIDTH - 80)/3 )* 1.2};
}



#pragma mark - 检测摄像头
- (void)checkFrontCamera {
    BOOL rearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    
    if (rearCamera) {
        BOOL hasCamera = NO;
        AVCaptureDeviceInput *inputCamera;
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *camera in cameras) {
            if ([camera position] == AVCaptureDevicePositionBack) {
                NSError *error = nil;
                inputCamera = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
                if (nil != inputCamera && nil == error) {
                    hasCamera = YES;
                    break;
                }
            }
        }
        
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        self.captureSession = captureSession;
        [captureSession beginConfiguration];
        
        if([captureSession canAddInput:inputCamera]){
            [captureSession addInput:inputCamera];
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [AVCaptureMovieFileOutput new];
        if([captureSession canAddOutput:movieFileOutput]){
            [captureSession addOutput:movieFileOutput];
        }
        [captureSession commitConfiguration];
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
        self.captureVideoPreviewLayer = captureVideoPreviewLayer;
        captureVideoPreviewLayer.frame = CGRectZero;
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:captureVideoPreviewLayer];
        
        [captureSession startRunning];
        
        NSString *tmpFile = [[NSString alloc] initWithFormat:@"%@/frontCamera.mov", NSTemporaryDirectory()];
        NSURL *tempURL = [NSURL fileURLWithPath:tmpFile];
        //开始录制
        [movieFileOutput startRecordingToOutputFileURL:tempURL recordingDelegate:self];
        
        [movieFileOutput performSelector:@selector(stopRecording) withObject:nil afterDelay:1];
        
    }
    
}

//后置摄像头
- (void)checkRearCamera {
    BOOL rearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
    if (rearCamera) {
        BOOL hasCamera = NO;
        AVCaptureDeviceInput *inputCamera;
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *camera in cameras) {
            if ([camera position] == AVCaptureDevicePositionBack) {
                NSError *error = nil;
                inputCamera = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
                if (nil != inputCamera && nil == error) {
                    hasCamera = YES;
                    break;
                }
            }
        }
        
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        self.captureSession = captureSession;
        [captureSession beginConfiguration];
        
        if([captureSession canAddInput:inputCamera]){
            [captureSession addInput:inputCamera];
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [AVCaptureMovieFileOutput new];
        if([captureSession canAddOutput:movieFileOutput]){
            [captureSession addOutput:movieFileOutput];
        }
        [captureSession commitConfiguration];
        
        AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
        self.captureVideoPreviewLayer = captureVideoPreviewLayer;
        captureVideoPreviewLayer.frame = CGRectZero;
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:captureVideoPreviewLayer];
        
        [captureSession startRunning];
        
        NSString *tmpFile = [[NSString alloc] initWithFormat:@"%@/rearCamera.mov", NSTemporaryDirectory()];
        NSURL *tempURL = [NSURL fileURLWithPath:tmpFile];
        //开始录制
        [movieFileOutput startRecordingToOutputFileURL:tempURL recordingDelegate:self];
        
        [movieFileOutput performSelector:@selector(stopRecording) withObject:nil afterDelay:1];
    }
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
      fromConnections:(NSArray *)connections
{
    //Recording started
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    //Recording finished - do something with the file at outputFileURL
    NSString *fileName = [outputFileURL.absoluteString lastPathComponent];
    
    for (PhoneMessageModel *model in self.dataList) {
        for (PhoneOptionModel *option in model.rowData) {
            if ([option.key isEqualToString:@"前置摄像头"] && [fileName hasPrefix:@"frontCamera"]) {
                
                //前置摄像头是否可用
                option.data = @"";
                if (nil == error) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }
                
                [self.captureSession stopRunning];
                [self.captureVideoPreviewLayer removeFromSuperlayer];
                self.captureSession = nil;
                self.captureVideoPreviewLayer = nil;
                
                break;
            }
            
            if ([option.key isEqualToString:@"后置摄像头"] && [fileName hasPrefix:@"rearCamera"]) {
                
                [self.captureSession stopRunning];
                [self.captureVideoPreviewLayer removeFromSuperlayer];
                self.captureSession = nil;
                self.captureVideoPreviewLayer = nil;
                
                //前置摄像头是否可用
                option.data = @"";
                if (nil == error) {
                    [option setNormal:YES];
                } else {
                    [option setNormal:NO];
                }                                                                      
                
                [self checkFrontCamera];
                
                break;
            }
        }
    }
    [self.myCollectionView reloadData];
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
