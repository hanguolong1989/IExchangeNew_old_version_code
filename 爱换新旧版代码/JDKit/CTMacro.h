//
//  CTMacro.h
//  GZCT
//
//  Created by Hind on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#ifndef GZCT_CTMacro_h
#define GZCT_CTMacro_h

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define APP_FRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
#define APP_FRAME_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)


#define JDURL(urlString) ([NSURL URLWithString:urlString])

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])


#define MSG_NETWORK_ERROR @"请求失败"

#define MSG_NETWORK_SEND_ERROR @"发送失败"



#endif
