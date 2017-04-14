//
//  UIDevice+Baseband.m
//  IExchangeNew
//
//  Created by Hind on 16/7/11.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "UIDevice+Baseband.h"
#import <Foundation/Foundation.h>
#import <termios.h>
#import <time.h>
#import <sys/ioctl.h>
#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>
#import "CoreTelephony.h"


@implementation UIDevice(BAseband)

extern CFTypeRef MGCopyAnswer(CFStringRef);

//+ (NSFileHandle *)baseBand {
//    NSFileHandle *baseBand = [NSFileHandle fileHandleForUpdatingAtPath:@"/dev/dlci.spi-baseband.extra_0"];
//    if (baseBand == nil) {
//        NSLog(@"Can't open baseband.");
//        return nil;
//    }
//    
//    int fd = [baseBand fileDescriptor];
//    
//    ioctl(fd, TIOCEXCL);
//    fcntl(fd, F_SETFL, 0);
//    
//    static struct termios term;
//    
//    tcgetattr(fd, &term);
//    
//    cfmakeraw(&term);
//    cfsetspeed(&term, 115200);
//    term.c_cflag = CS8 | CLOCAL | CREAD;
//    term.c_iflag = 0;
//    term.c_oflag = 0;
//    term.c_lflag = 0;
//    term.c_cc[VMIN] = 0;
//    term.c_cc[VTIME] = 0;
//    tcsetattr(fd, TCSANOW, &term);
//
//    return baseBand;
//}
//
//+ (NSString *)sendATCommand:(NSString *)atCommand {
//    
//    NSFileHandle *baseBand = [UIDevice baseBand];
//    if (baseBand == nil) {
//        NSLog(@"Can't get the baseband.");
//    } else {
//        
//        NSLog(@"SEND AT: %@", atCommand);
//        [baseBand writeData:[atCommand dataUsingEncoding:NSASCIIStringEncoding]];
//        NSMutableString *result = [NSMutableString string];
//        NSData *resultData = [baseBand availableData];
//        while ([resultData length]) {
//            [result appendString:[[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding]];
//            if ([result hasSuffix:@"OK\r\n"]||[result hasSuffix:@"ERROR\r\n"]) {
//                NSLog(@"RESULT: %@", result);
//                return [NSString stringWithString:result];
//            }
//            else{
//                resultData = [baseBand availableData];
//            }
//        }
//    }
//    
//    return nil;
//}
//
//+ (NSString *)IMEI {
//    
//    NSString *result = [UIDevice sendATCommand:@"AT+CGSN\r"];
//    return result;
//    
//}
//
//
//+ (NSString *)IMSI {
//    
//    NSString *result = [UIDevice sendATCommand:@"AT+CIMI\r"];
//    return result;
//    
//}
//
//
//+ (NSString *)ICCID {
//    
//    NSString *result = [UIDevice sendATCommand:@"AT+CCID\r"];
//    return result;
//    
//}

+ (NSString *)serialNumber
{
    NSString *serialNumber = nil;
    
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (IOKit)
    {
        mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
        CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
        kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
        
        if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
        {
            mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
            if (platformExpertDevice)
            {
                CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
                if (platformSerialNumber && CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
                {
                    serialNumber = [NSString stringWithString:(__bridge NSString *)platformSerialNumber];
                    CFRelease(platformSerialNumber);
                }
                IOObjectRelease(platformExpertDevice);
            }
        }
        dlclose(IOKit);
    }
    
    return serialNumber;
}

+ (NSString *)cpuArchitecture {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("CPUArchitecture"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}

+ (NSString *)basebandFirmwareVersion {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("BasebandFirmwareVersion"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}


+ (NSString *)deviceFirmwareVersion {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("FirmwareVersion"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}

+ (NSString *)modelNumber {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("ModelNumber"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}

+ (NSString *)regionInfo {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("RegionInfo"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}


+ (NSString *)regionCode {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("RegionCode"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}




+ (NSString *)deviceBuildVersion {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("BuildVersion"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}


+ (NSString *)deviceColor {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("DeviceColor"));
    if (tmp) {
        retVal = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
        CFRelease(tmp);
    }
    return retVal;
}





@end
