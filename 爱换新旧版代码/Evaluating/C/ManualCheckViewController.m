//
//  ManualCheckViewController.m
//  IExchangeNew
//
//  Created by koreadragon on 16/11/8.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "ManualCheckViewController.h"
#import "ManualCheckCollectionViewCell.h"
#import "PhoneOptionModel.h"
#import "PhoneMessageModel.h"
#import "LoadingView.h"
#import "FinalSubmitViewController.h"
#import "TouchCollectionViewCell.h"
#import "FingerView.h"
#import "SDCycleScrollView.h"
#import <LocalAuthentication/LocalAuthentication.h>
static NSString * kCellId = @"manualCellId";
static NSString *kUICollectionElementKindSectionHeader = @"UICollectionElementKindSectionHeader";


@interface ManualCheckViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,SDCycleScrollViewDelegate>{
    CGFloat collHeight;//collectionView的高度，以便设置cell高度
    NSInteger index;//标记触摸屏幕时的操作次数
    NSInteger addIndex;//滑动显示屏幕
    UICollectionView *sonCollectionView;//测试屏幕触摸时的collectionView
    UIView *backView;
//    NSMutableArray *touchArray;//记录触摸信息的array
    UIPageControl *_pageControl;//分页显示器
}


@property (weak, nonatomic) IBOutlet UIImageView *backgoundImageView;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property(nonatomic,strong)NSMutableArray*okBadArray;

@property (nonatomic, strong) NSMutableDictionary * dataList;
@property (nonatomic, strong) NSMutableArray * estimateOptions;
@property(nonatomic,strong)NSMutableArray * titleArray;
@property (strong , nonatomic) NSIndexPath * m_lastAccessed;

@end

@implementation ManualCheckViewController

-(NSMutableArray *)okBadArray{
    if (!_okBadArray  ) {
        _okBadArray = [NSMutableArray new];
    }
    return _okBadArray;
}
-(NSMutableArray *)titleArray{
    if (!_titleArray  ) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dataList = [NSMutableDictionary dictionary];
    }
    return self;
}

//-(NSMutableDictionary *)dataList{
//    if (!_dataList) {
//        _dataList = [NSMutableDictionary new];
//    }
//    
//    return _dataList;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ self statusBarWhite];
    self.navigationItem.title = @"手动评测";
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"#69da6b" alpha:1.0]];
    [self setupInfo];
    
  
    
    NSArray *namesArray = @[@"通话功能",@"触摸功能",@"液晶显示",@"屏幕外观",@"颜色",@"边框背板",@"充电功能",@"维修拆机史",@"进水问题",@"指纹功能",@"iCloud账户",@"国内保修情况"];
    self.titleArray = namesArray.mutableCopy;
    
    for (int i=0; i<12; i++) {
        NSString *select = @"unKnow";
        [self.okBadArray addObject:select];
    }
    NSLog(@"self.okBadArray----%@",self.okBadArray);
    
}

-(void)setupInfo{
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
//    _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 1.0;
    layout.minimumInteritemSpacing = 1.0;
    layout.sectionInset = (UIEdgeInsets){1,0,1,0};
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 150);
    _myCollectionView.collectionViewLayout = layout;
    
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ManualCheckCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellId];
    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUICollectionElementKindSectionHeader];
    
    
    
    ///button
    _nextButton.layer.cornerRadius = 45.0/2;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
   
    
}


#pragma mark - 提交
- (IBAction)submit:(id)sender {

        if (self.dataList.count < self.estimateOptions.count) {
            [HGTools showMessage:@"请完善选择项"];
            return;
        }
        
        
        NSMutableDictionary *faqStringApple = [NSMutableDictionary dictionary];
        [faqStringApple setDictionary:self.dataList];
        for (PhoneMessageModel *section in self.autoCheckData) {
            for (PhoneOptionModel *model in section.rowData) {
                if (nil != model.value) {
                    [faqStringApple addEntriesFromDictionary:model.value];
                }
            }
        }
        
        NSMutableString *faqStringAppleString = [NSMutableString string];
        for (NSString *tmpKey in faqStringApple.allKeys) {
            NSString *value = [faqStringApple objectForKey:tmpKey];
            
            if (faqStringAppleString.length != 0) {
                [faqStringAppleString appendString:@":"];
            }
            
            [faqStringAppleString appendFormat:@"%@,%@", tmpKey, value];
            
        }
    
    
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.infoId forKey:@"infoId"];
        [param setObject:self.authCode forKey:@"authCode"];
        [param setObject:@"2" forKey:@"phoneType"];
        [param setObject:faqStringAppleString forKey:@"faqStringApple"];
        [param setObject:[HGTools returnStr:@"" ifObjIsRealNull:_resultData[@"brandId"]] forKey:@"brandId"];
        [param setObject:[HGTools returnStr:@"" ifObjIsRealNull:_resultData[@"detailId"]] forKey:@"detailId"];
        
    LoadingView *loadView = [LoadingView hgLoadingView];
    [loadView infoWithImageName:@"pandaWithPhone.png" title:@"正在提交..." detailTitle:@"您的信息正在整理提交，请耐心等候"];
    [loadView show:self];
    self.view.userInteractionEnabled = NO;

    
    [HGTools POST:NEW_POST_REPORT params:param success:^(id response) {
        
        [loadView dismiss];
        
        self.view.userInteractionEnabled = YES;
        
        NSDictionary *data = [response objectForKey:@"data"];
        
        if ([data[@"status"] isEqualToString:@"SUCCESS"]) {
            
            FinalSubmitViewController *FINALSUBMIT = [self.storyboard instantiateViewControllerWithIdentifier:@"FINALSUBMIT"];
            [self.navigationController pushViewController:FINALSUBMIT animated:YES];
            
        }else{
            
            if (data[@"message"] != nil) {
                [HGTools showMessage:data[@"message"]];
            }else{
                [HGTools showMessage:@"提交失败，请重试"];
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask *Task, NSError *error) {
        
        [loadView dismiss];
        self.view.userInteractionEnabled = YES;

        [HGTools showMessage:@"网络错误"];
        
    }];
    
   

}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//头视图
     
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUICollectionElementKindSectionHeader forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"manual_Bg.png"]];
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        [reusableView addSubview:imageView];
        
        
        return reusableView;
        
    }
    return nil;
    
}
    

#pragma mark - setter
- (void)setResultData:(NSDictionary *)resultData {
    _resultData = resultData;
    NSDictionary *estimateOptions = [self.resultData objectForKey:@"estimateOptions"];
    NSDictionary *autoDic  = estimateOptions[@"manual"];

    NSDictionary *array = autoDic[@"typeData"];
    
    NSArray *typeData = array.allValues;
    self.estimateOptions = typeData.mutableCopy;

}
- (NSDictionary *)sectionWithKey:(NSString *)key {
    for (NSDictionary *section in self.estimateOptions) {
        NSString *title = [section stringForKey:@"title"];
        if ([title isEqualToString:key]) {
            return section;
        }
    }
    return nil;
}


#pragma  mark - collectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    if (collectionView != sonCollectionView) {
        return 1;
    }
    return 25;
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == sonCollectionView) {
        
        if (section == 0 ||  section == 12  || section == 24) {
            return 13;
        }
        

       return  3;
    }
   
    return self.estimateOptions.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    if (collectionView == sonCollectionView) {
        
        TouchCollectionViewCell *cell = [sonCollectionView dequeueReusableCellWithReuseIdentifier:@"son" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
        
        
    }else{
        
        ManualCheckCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
        cell.myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"manualLogo%d",indexPath.item]];
        cell.myLabel.text = self.titleArray[indexPath.item];
        
        cell.smallLogoImageView.image = nil;
        
        NSString *imageName = self.okBadArray[indexPath.item];
//        if ([self.okBadArray[indexPath.item] isEqualToString:@"ok"]) {
            [cell.smallLogoImageView setRoundImage:imageName];
//        }else if ([self.okBadArray[indexPath.item] isEqualToString:@"bad"]){
//            [cell.smallLogoImageView setRoundImage:@"manualTestFailure.png"];
//        }else{
        
            
            
            //        [cell.smallLogoImageView setRoundImage:@"autoCheck_unknow.png"];
            
//        }
        
        return cell;
    }
    
}

#pragma mark - flowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat fullHeight = self.view.window.frame.size.height;
    if (collectionView != sonCollectionView) {
        
        return (CGSize){ (SCREEN_WIDTH - 2) / 3,120};
    }else{
        return (CGSize){ (SCREEN_WIDTH -12) / 13,(fullHeight -24)/ 25};
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (collectionView != sonCollectionView ){
        return (UIEdgeInsets){0,0,0,0};
    }else{
        
        if(section == 24){
            
            return (UIEdgeInsets){0,0,0,0};
            
        }else{
            return (UIEdgeInsets){0,0,1,0};
        }
        
    }

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (collectionView != sonCollectionView ){
        return 1;
    }else{
        
        if (section == 0 ||section == 12  || section == 24) {
            return 1;
        }
        
        
        //每行三个的区
        CGFloat cellWidth = (SCREEN_WIDTH -12) / 13;
        return cellWidth * 5 + 4;
    }
 
}




-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    
    
    if (collectionView != sonCollectionView ) {
    
        switch (indexPath.item) {
        case 0://通话功能
                
                [self touchWithIndexPath:indexPath secondTitle:@"能否正常拨打电话、语音是否正常" rightIconName:nil middleButtonTitle:@"点击拨打112检测" middleAction:^(UIButton *middleButton) {
                    
                    NSURL *url = [NSURL URLWithString:@"tel://112"];
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }];

        
            break;
        case 1://触摸功能
            {

                [self touchWithIndexPath:indexPath secondTitle:@"涂满指定的格子" rightIconName:nil middleButtonTitle:@"点击检测" middleAction:^(UIButton *middleButton) {
                    
                     [self touchDisplayTest];
                }];
            }
            break;
        case 2://液晶显示
            
        {

            [self touchWithIndexPath:indexPath secondTitle:@"观察屏幕是否存在亮点、色差等情况" rightIconName:@"alertBulb" middleButtonTitle:@"点击检测" middleAction:^(UIButton *middleButton) {
                
                //液晶显示的检测
                [self fullScreen];
                
            }];
            
        }
            break;
        case 3://屏幕外观

                [self touchWithIndexPath:indexPath secondTitle:@"观察屏幕是否磨损"rightIconName:@"alertBulb" middleButtonTitle:nil middleAction:nil];
            break;
        case 4://颜色

            [self touchWithIndexPath:indexPath secondTitle:@"选择手机颜色"rightIconName:nil middleButtonTitle:nil middleAction:nil];
            break;
        case 5://边框背板

               
                [self touchWithIndexPath:indexPath secondTitle:@"观察边框背板是否有划痕、掉漆等现象"rightIconName:@"alertBulb" middleButtonTitle:nil middleAction:nil];
            break;
        case 6://充电功能

                [self touchWithIndexPath:indexPath secondTitle:@"请接上数据线进行充电"rightIconName:nil middleButtonTitle:nil middleAction:nil];

            break;
        case 7://维修拆机
                
                [self touchWithIndexPath:indexPath secondTitle:@"更换过零部件如屏幕、主板等，即为维修过"rightIconName:nil middleButtonTitle:nil middleAction:nil];

            break;
        case 8://是否进水
                [self touchWithIndexPath:indexPath secondTitle:@"屏幕有斑块、防拆标撕毁即为有进过水"rightIconName:nil  middleButtonTitle:nil middleAction:nil];
            break;
        case 9://指纹功能
            {
                
                //判断是否支持指纹识别
                BOOL finger = [self isDeviceSupportTouchID];
                
                
                if (finger) {
                    [self touchWithIndexPath:indexPath secondTitle:@"打开手机系统设置-指纹设置-添加指纹可以录入即为正常"rightIconName:nil middleButtonTitle:@"跳转到设置界面" middleAction:^(UIButton *middleButton){
                        
                        [self jumpToSetUpWithUrl:@"Prefs:root"];
                    }];
                }else{
                    [self fingerWithIndexPath:indexPath secondTitle:@"您的手机不支持指纹识别"rightIconName:nil middleButtonTitle:nil middleAction:^(UIButton *middleButton){
                        
                        
                    }];
                    

                }
            }
            
            break;
        case 10://iCloud账户

            {
                [self touchWithIndexPath:indexPath secondTitle:@"打开系统设置-iCloud查看并清除/解除"rightIconName:nil  middleButtonTitle:@"查看是否解除" middleAction:^(UIButton *middleButton){
                    
                    
                    [self jumpToSetUpWithUrl:@"Prefs:root=CASTLE"];
                    
                     }];
                
            }
            break;
        case 11://保修情况
            {
                [self touchWithIndexPath:indexPath secondTitle:@"请在苹果官网通过序列号查询手机是否在保修期"rightIconName:@"safariLogo" middleButtonTitle:@"去复制序列号" middleAction:^(UIButton *middleButton){
                    
                    
                    [self jumpToSetUpWithUrl:@"Prefs:root=General&path=About"];
                    
                }];
            }
            break;
            
        default:
            break;
    }

    }else{
        
        TouchCollectionViewCell *cell = (TouchCollectionViewCell *)[sonCollectionView cellForItemAtIndexPath:indexPath];
        
        
        if (!cell.touch) {
            cell.touch = YES;
            addIndex++;
            cell.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX];
             sonCollectionView.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX alpha:addIndex*(1.0/105)];

            
            if (addIndex == 105) {
               [self removeTheCollectionViewWithMessage:@"屏幕完好"];
            }
            
        }
        
    }
    
    
}


/**
 跳转到设置界面
 */
-(void)jumpToSetUpWithUrl:(NSString *)pathString{
    
    
    
    if (IOS_VERSION >= 10.0) {
        
        //注意首字母改成了大写，prefs->Prefs
        NSURL*url=[NSURL URLWithString:pathString];
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
        [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:url withObject:nil];
        
    }else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pathString]]){
        NSURL*url=[NSURL URLWithString:pathString];
        [[UIApplication sharedApplication]openURL:url];
        
    }else{
       //
    }
}


/**
 是否支持指纹识别

 @return 布尔值
 */
- (BOOL)isDeviceSupportTouchID
{
    
    LAContext *context = [[LAContext alloc] init];
    NSError *contextError = nil;
    BOOL  isSupport = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&contextError];
    
    if (isSupport) {
        return YES;
    }
    else {
        
        switch (contextError.code) {
                
            case  LAErrorTouchIDNotAvailable:
                
                return NO;
            default:
            {
                //TouchID 不可用，无指纹解锁功能
                NSLog(@"TouchID not available");
                return YES;
                break;
            }
        }
    }
}

//切换颜色显示屏幕
-(void)fullScreen{
    UIView *view = [UIView new];
    view.tag = 666;
    index = 0;
    view.frame = self.view.window.frame;
    view.backgroundColor = [UIColor redColor];

    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self.view.window addSubview:view];
    _pageControl= [[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:6];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center=CGPointMake(SCREEN_WIDTH/2, 30);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    //设置总页数
    _pageControl.numberOfPages=6;
    
    [self.view.window addSubview:_pageControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeColor:)];
    [view addGestureRecognizer:tap];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeColor:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:swipe];
    
}

//点击切换屏幕显示颜色，检测屏幕有无坏点
-(void)changeColor:(UIGestureRecognizer *)sender{
    UIView *view = sender.view;
    
    NSArray *colors = @[[UIColor greenColor],[UIColor blueColor],[UIColor blackColor],[UIColor whiteColor],[UIColor yellowColor]];
    
    if (view.tag == 666 && index != 5) {
        view.backgroundColor = (UIColor *)colors[index];
        index++;
        _pageControl.currentPage = index;
    }else{
        [view removeFromSuperview];
        [_pageControl removeFromSuperview];
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
    }
}
//滑动显示触摸区域
-(void)touchDisplayTest{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = (UIEdgeInsets ){0,0,0,0};
    
    sonCollectionView = [[UICollectionView alloc]initWithFrame:self.view.window.frame collectionViewLayout:layout];
    addIndex = 0;
    [sonCollectionView registerClass:[TouchCollectionViewCell class] forCellWithReuseIdentifier:@"son"];
    sonCollectionView.delegate = self;
    sonCollectionView.dataSource = self;
    sonCollectionView.backgroundColor = [UIColor whiteColor];
    
    
//    touchArray = [NSMutableArray new];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMoved:)];
    [sonCollectionView addGestureRecognizer:pan];
    
    
    //双击退出测试
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTouchTest:)];
    doubleTap.numberOfTapsRequired = 2;

     CGFloat cellWidth = (SCREEN_WIDTH - 12) / 13;
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){cellWidth+1,cellWidth*7+6 -20,cellWidth*5+6,cellWidth * 5 + 6}];
    [label addGestureRecognizer:doubleTap];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"用手涂满灰色格子\n双击此处退出";
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14.0];
    label.userInteractionEnabled = YES;

    [sonCollectionView addSubview:label];

    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    backView = [[UIView alloc]initWithFrame:self.view.window.frame];
    
    backView.backgroundColor = [UIColor whiteColor];
    [self.view.window addSubview:backView];
    [self.view.window addSubview:sonCollectionView];
    
    //弹出提示窗
    FingerView *fingerView = [FingerView setFingerView];
    [sonCollectionView addSubview:fingerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC *0.7), dispatch_get_main_queue(), ^{
        
        [fingerView removeFromSuperview];
        
    });

 
}

//双击空白区域取消屏幕滑动测试

-(void)cancelTouchTest:(UITapGestureRecognizer *)sender{
    
    if ([sender.view isKindOfClass:[UILabel class]]) {
        
        [HGTools showMessage:@"退出检测"];

        [backView removeFromSuperview];
        [sonCollectionView removeFromSuperview];
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        
        
    }
    
}


//退出屏幕检测(完成或者用户中断)
-(void)removeTheCollectionViewWithMessage:(NSString *)message{
    
    [HGTools showMessage:message];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC *0.5), dispatch_get_main_queue(), ^{

        [sonCollectionView removeFromSuperview];
        [backView removeFromSuperview];
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        
    });
    

}

-(void)panMoved:(UIPanGestureRecognizer *)sender{
    
    
    if (addIndex == 105) {
        [self removeTheCollectionViewWithMessage:@"屏幕完好"];
        return;
    }
    
    CGFloat pointX = [sender locationInView:sonCollectionView].x;
    CGFloat pointY = [sender locationInView:sonCollectionView].y;
    
    
    for (TouchCollectionViewCell *cell in sonCollectionView.visibleCells) {
        CGFloat cellLeft = cell.frame.origin.x;
        CGFloat cellRight = cellLeft + cell.frame.size.width;
        CGFloat cellUp = cell.frame.origin.y;
        CGFloat cellDown = cellUp + cell.frame.size.height;
        
        //判断点击点在不在cell区域内
        
        
        if (pointX >= cellLeft && pointX <= cellRight && pointY >= cellUp && pointY <= cellDown ) {

            if (!cell.touch) {
                cell.touch = YES;
                addIndex++;
                cell.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX];
   
                sonCollectionView.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX alpha:addIndex*(1.0/105)];
            }
 
        }
        
    }
    
}

-(void)touchWithIndexPath:(NSIndexPath *)indexPath
              secondTitle:(NSString *)secondTitle
            rightIconName:(NSString *)iconName
        middleButtonTitle:(NSString *)middleButtonTitle
             middleAction:(selectMiddle)middleAction{
    NSDictionary *section = [self sectionWithKey:_titleArray[indexPath.item]];
    
    if (section == nil) {//防止文字没有对应上，取出空值，直接跳出
        return;
    }

    //包含按钮名字及对应的id值
    NSArray *optionsArray = [section objectForKey:@"options"];
    //按钮名字
    NSMutableArray *buttonArray = [NSMutableArray new];
    //按钮id
    NSMutableArray *buttonIdArray = [NSMutableArray new];
    for (NSDictionary *dic in optionsArray) {
        NSString *buttonName = dic[@"subTitle"];
        id buttonId = dic[@"subId"];
        [buttonArray addObject:buttonName];
        [buttonIdArray addObject:buttonId];
    }
    
    //针对进水问题，由于数据排序有问题，好的选项排在了下面，为了不影响目前检测端使用，暂时特殊处理，后续后台改正时一起修复
    
    if (indexPath.item == 8) {
        
       buttonIdArray =  [[buttonIdArray reverseObjectEnumerator] allObjects].mutableCopy;
        buttonArray =  [[buttonArray reverseObjectEnumerator] allObjects].mutableCopy;
    }
    

    //当前操作的id值，点击后赋值类似[99,471]
    NSNumber *sectionId = [section objectForKey:@"id"];
    
    
    HGAertView *alertView = [HGAertView hgAlertView];
   
    
    //如果indexPath是4，则确认是在选择颜色
    BOOL phoneColor = NO;
    if (indexPath.item == 4) {
        phoneColor = YES;
    }
    
    
    [alertView newSelectTextTitle:_titleArray[indexPath.item] rightIconName:iconName phoneColor:phoneColor secondTitle:secondTitle middleButtonTitle:middleButtonTitle thirdTitle:nil selectMiddle:^(UIButton *middleButton) {
        
        middleAction(middleButton);
        
    } buttonNameArray:buttonArray selectOther:^(UIButton *selectButton, NSString *selectTitle) {
        
        int flag = 0;//标记选择的是第几个按钮
        
        for (int i =0 ; i<buttonArray.count; i++) {
            
            if ([selectTitle isEqualToString:buttonArray[i]]) {
                
                [self.dataList setObject:buttonIdArray[i] forKey:sectionId];
                flag = i;
                break;
            }
            
            
        }
        
       
        
        
        
        NSLog(@"self.okBadArray----%@",self.okBadArray);
        NSLog(@"待提交列表%@",self.dataList);
        
        
        //手机颜色
        if (indexPath.item == 4) {
            
            NSString *color;
            
            switch (flag) {
                case 0:
                    color = @"manualTest_Black";
                    break;
                case 1:
                    color = @"manualTest_Gold";
                    break;
                case 2:
                    color = @"manualTest_RoseGold";
                    break;
                case 3:
                    color = @"manualTest_White";
                    break;
                default:
                    color = @"manualTest_Failure";
                    break;
            }

            [self.okBadArray replaceObjectAtIndex:indexPath.item withObject:color];
        }else{
            
            NSString *image;
            
            switch (flag) {
                case 0:
                    image = @"manualTest_Success";
                    break;
                case 1:
                    image = @"manualTest_Failure";
                    break;
                default:
                    image = @"manualTest_Bad";
                    break;
            }
            
            [self.okBadArray replaceObjectAtIndex:indexPath.item withObject:image];
            
            
        }

        
        
        if (self.dataList.count == self.estimateOptions.count) {
            
            _nextButton.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX];
            
        }
        
        [self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        if ([selectTitle isEqualToString:BULBTITLE]) {//用户点击了查看报告按钮
            
            [self seeSampleImages:indexPath];
            
        }

        
    }];
    
     [alertView myShow:self];
    
}


//指纹选项，特殊处理
-(void)fingerWithIndexPath:(NSIndexPath *)indexPath
              secondTitle:(NSString *)secondTitle
             rightIconName:(NSString *)iconName
        middleButtonTitle:(NSString *)middleButtonTitle
             middleAction:(selectMiddle)middleAction{
    NSDictionary *section = [self sectionWithKey:_titleArray[indexPath.item]];
    
    if (section == nil) {//防止文字没有对应上，取出空值，直接跳出
        return;
    }
    
    //包含按钮名字及对应的id值
    NSArray *optionsArray = [section objectForKey:@"options"];
    //按钮名字
    NSMutableArray *buttonArray = [NSMutableArray new];
    //按钮id
    NSMutableArray *buttonIdArray = [NSMutableArray new];
    for (NSDictionary *dic in optionsArray) {
        NSString *buttonName = dic[@"subTitle"];
        id buttonId = dic[@"subId"];
        [buttonArray addObject:buttonName];
        [buttonIdArray addObject:buttonId];
    }
    
   
    
    //当前操作的id值，点击后赋值类似[99,471]
    NSNumber *sectionId = [section objectForKey:@"id"];
    
    HGAertView *alertView = [HGAertView hgAlertView];
    
    

    
    [alertView newSelectTextTitle:_titleArray[indexPath.item] rightIconName:iconName phoneColor:NO secondTitle:secondTitle middleButtonTitle:middleButtonTitle thirdTitle:nil selectMiddle:^(UIButton *middleButton) {
        
        middleAction(middleButton);
        
    } buttonNameArray:@[@"不支持"] selectOther:^(UIButton *selectButton, NSString *selectTitle) {
        
        
       [self.dataList setObject:buttonIdArray[0] forKey:sectionId];
               
                
     
        
        [self.okBadArray replaceObjectAtIndex:indexPath.item withObject:@"manualTest_Failure"];
        
        NSLog(@"self.okBadArray----%@",self.okBadArray);
        NSLog(@"待提交列表%@",self.dataList);
        
        
        if (self.dataList.count == self.estimateOptions.count) {
            
            _nextButton.backgroundColor = [UIColor colorWithHexString:SYSTEM_HEX];
            
        }
        
        [self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        if ([selectTitle isEqualToString:BULBTITLE]) {//用户点击了查看报告按钮
            
            [self seeSampleImages:indexPath];
            
        }
        
        
    }];
    
    [alertView myShow:self];
    
}
/**
 查看不良图册
 */
-(void)seeSampleImages:(NSIndexPath *)indexPath{
    
   
    
    NSDictionary *imageDic,*titleDic;
    
    NSInteger item = indexPath.item;
    
    if (item == 11) {
        
        [self jumpToSetUpWithUrl:CHECK_COVERAGE];
 
        
        
        
        return;
    }
    
    
    
    
    
    imageDic = @{@"display":@[@"display0.jpg",@"display1.jpg",@"display2.jpg",@"display3.jpg",@"display4.jpg",@"display5.jpg"],
                 @"surface":@[@"surface0.jpg",@"surface1.jpg",@"surface2.jpg",@"surface3.jpg"],
                 @"backboard":@[@"backboard0.jpg",@"backboard1.jpg",@"backboard2.jpg",@"backboard3.jpg",@"backboard4.jpg"]};
    
    titleDic = @{@"display":@[@"错乱",@"色差",@"色斑",@"漏液",@"亮点/坏点",@"发黄"],
                 @"surface":@[@"裂屏",@"轻微划痕",@"严重划痕",@"碎角"],
                 @"backboard":@[@"背板划痕",@"背板破损",@"背板弯曲",@"磕碰",@"严重弯曲"]};
    
    NSString *key;
    
    //indexPath  2液晶显示，3外观，边框背板5
    switch (item) {
            
        case 2:
            key = @"display";
            break;
            
        case 3:
            key = @"surface";
            break;
            
        case 5:
            key = @"backboard";
            break;
            
        default:
            break;
    }
    

    
    
    SDCycleScrollView *view = [SDCycleScrollView cycleScrollViewWithFrame:self.view.window.bounds imageNamesGroup:imageDic[key]];
    
    
    NSArray *titleArray = titleDic[key];
    
    
    view.titlesGroup = titleArray;
    view.delegate = self;
    view.autoScroll = NO;
    
    [self.view.window addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSampleView:)];
    [view addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

-(void)closeSampleView:(UITapGestureRecognizer *)sender{
    
    [sender.view removeFromSuperview];
     [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    
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
