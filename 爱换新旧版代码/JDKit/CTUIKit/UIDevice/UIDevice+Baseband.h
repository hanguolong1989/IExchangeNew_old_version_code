//
//  UIDevice+Baseband.h
//  IExchangeNew
//
//  Created by Hind on 16/7/11.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SUPPORTS_IOKIT_EXTENSIONS    1

@interface UIDevice(BAseband)


//私有API，获取序列号，越狱获取
+ (NSString *)serialNumber;
//CPU架构
+ (NSString *)cpuArchitecture;
//设备基带版本，越狱获取
+ (NSString *)basebandFirmwareVersion;
//设备固件版本
+ (NSString *)deviceFirmwareVersion;
//型号
+ (NSString *)modelNumber;
//销售范围
+ (NSString *)regionCode;
//销售地区
+ (NSString *)regionInfo;
//设备构建版本
+ (NSString *)deviceBuildVersion;
//设备颜色
+ (NSString *)deviceColor;

@end
