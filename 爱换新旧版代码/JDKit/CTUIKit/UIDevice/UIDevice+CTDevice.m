//
//  UIDevice+CTDevice.m
//  IExchangeNew
//
//  Created by Hind on 16/7/5.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "UIDevice+CTDevice.h"
#import <sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "sys/utsname.h"
#import <dlfcn.h>
#include <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <CoreTelephony/CTCarrier.h>
#include <AdSupport/ASIdentifierManager.h>


@implementation UIDevice(CTDevice)

+ (long long)freeDiskSpaceInBytes {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
}

+ (long long)allDiskSpaceInBytes {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *total = [dictionary objectForKey:NSFileSystemSize];
        return [total unsignedLongLongValue];
    } else {
        return -1;
    }
}

//检测听筒
+ (BOOL)receiverAvailable {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;

    BOOL receiverResult = [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (!receiverResult || sessionError) {
        return NO;
    } else {
        return YES;
    }

}

//检测扬声器
+ (BOOL)speakerAvailable {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    
    BOOL receiverResult = [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    if (!receiverResult || sessionError) {
        return NO;
    } else {
        return YES;
    }
}

//检查麦克风可用性的正确方法
+ (BOOL)microphoneAvailable {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    return session.inputAvailable;
}

//检测陀螺仪是否存在
+ (BOOL)gyroscopeAvailable {
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    BOOL gyroAvailable = motionManager.gyroAvailable;
    return gyroAvailable;
}

//检测拨打电话功能
+ (BOOL)canMakePhoneCalls {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

+ (BOOL)accelerometerAvailable {
    CMMotionManager *manager = [[CMMotionManager alloc]init];
    return manager.accelerometerAvailable;
}

+ (NSString *)getSystemInfoWithName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *)machineCode
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}


+ (BOOL)isJailBreak
{
    NSArray *jailbreak_tool_pathes = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt"
    ];
    for (int i = 0; i < jailbreak_tool_pathes.count; i++) {
        NSString *path = [jailbreak_tool_pathes objectAtIndex:i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)carrier
{
    /*
     CTTelephonyNetworkInfo *tinfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
     CTCarrier *carrier = tinfo.subscriberCellularProvider;
     return carrier.carrierName ? carrier.carrierName : @"";
     */
    
    static Class CTTelephonyNetworkInfo_class = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        void *lib_handle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LOCAL);
        if (lib_handle) {
            CTTelephonyNetworkInfo_class = objc_getClass("CTTelephonyNetworkInfo");
            if (CTTelephonyNetworkInfo_class) {
                NSLog(@"[IMFDevice] 动态加载CoreTelephony成功");
                //if (dlclose(lib_handle) == 0) {
                //    IMFLog(@"[IMFDevice] 动态卸载CoreTelephony成功");
                //} else {
                //    IMFLog(@"[IMFDevice] 动态卸载CoreTelephony失败!");
                //}
            } else {
                NSLog(@"[IMFDevice] 动态加载CoreTelephony失败!");
            }
        } else {
            NSLog(@"[IMFDevice] 动态加载CoreTelephony失败!");
        }
    });
    
    
    if (CTTelephonyNetworkInfo_class) {
        CTTelephonyNetworkInfo *tinfo = [[CTTelephonyNetworkInfo_class alloc] init];
        CTCarrier *carrier = tinfo.subscriberCellularProvider;
        
        if (carrier) {
            return carrier.carrierName;
        } else {
            return @"";
        }
        
    } else {
        return @"";
    }
}

+ (NSString *)idfa
{
    ASIdentifierManager *asid = [ASIdentifierManager sharedManager];
    
    return asid.advertisingIdentifier.UUIDString;
}

#define KEY_APNSTOKEN @"PCAPNSTOKEN"
+ (void)setAPNSToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_APNSTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)APNSToken {
    NSString *apnsToken = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_APNSTOKEN];
    return apnsToken;
}


@end
