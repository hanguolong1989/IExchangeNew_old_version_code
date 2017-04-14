//
//  CoreTelephony.h
//  IExchangeNew
//
//  Created by Hind on 16/7/12.
//  Copyright © 2016年 Hind. All rights reserved.
//

#ifndef CoreTelephony_h
#define CoreTelephony_h


struct CTServerConnection
{
    int a;
    int b;
    CFMachPortRef myport;
    int c;
    int d;
    int e;
    int f;
    int g;
    int h;
    int i;
};

struct CTResult
{
    int flag;
    int a;
};

struct CTServerConnection * _CTServerConnectionCreate(CFAllocatorRef, void *, int *);

void _CTServerConnectionCopyMobileIdentity(struct CTResult *, struct CTServerConnection *, NSString **);

extern NSString* CTSIMSupportCopyMobileSubscriberIdentity();


#endif /* CoreTelephony_h */
