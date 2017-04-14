//
//  UIDevice+CTDevice.h
//  IExchangeNew
//
//  Created by Hind on 16/7/5.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice(CTDevice)

//获取设备型号代码
+ (NSString *)machineCode;

+ (long long)freeDiskSpaceInBytes;

+ (long long)allDiskSpaceInBytes;

//检查麦克风可用性的正确方法
+ (BOOL) microphoneAvailable;

//检测陀螺仪是否存在
+ (BOOL)gyroscopeAvailable;

//检测拨打电话功能
+ (BOOL)canMakePhoneCalls;

//检测加速感应器
+ (BOOL)accelerometerAvailable;

//检测扬声器
+ (BOOL)speakerAvailable;

//检测听筒
+ (BOOL)receiverAvailable;

//是否越狱
+ (BOOL)isJailBreak;

//获取idfa
+ (NSString *)idfa;

//获取运营商
+ (NSString *)carrier;

//设置APNS token
+ (void)setAPNSToken:(NSString *)token;
//获取APNS token
+ (NSString *)APNSToken;

@end
