//
//  BCConfig.h
//  cycling
//
//  Created by Pro on 3/4/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#ifndef cycling_BCConfig_h
#define cycling_BCConfig_h
#import "AppDelegate.h"
#import "HBHTTPService.h"
#import  "HBAlertView.h"

#define DownLoadURL @"http://www.testflightapp.com"

#define APP (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define LuckyNoticeCount 10
#define LuckyTimer 3

#define TIMER 120
//导航栏高度
#define NAV_HEIGHT 44.0f
#define STA_HERGHT 20.0f
#define NAV_HEI_64 64.0f
//屏幕的比率
#define ScaleWidth [UIScreen mainScreen].bounds.size.width / 320.0
#define ScaleHeight [UIScreen mainScreen].bounds.size.height / 480.0

#define SCREEN_MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

#define VIEW_MAX_HEIGHT [UIScreen mainScreen].bounds.size.height-20

//#define PIC_SCALE_WIDTH 320.0/480
//#define PIC_SCALE_HEIGHT [UIScreen mainScreen].bounds.size.height/800

//字体
#define FONTSIZES(x) [UIFont fontWithName:@"Heiti SC" size:x]
#define FONTBOLD(x) [UIFont boldSystemFontOfSize:x]
#define FONT_BIG [UIFont boldSystemFontOfSize:12]
#define FONT_MID [UIFont boldSystemFontOfSize:9]
#define FONT_SMA [UIFont boldSystemFontOfSize:6]
//#define FONT_BESTBIG [UIFont fontWithName:@"Heiti SC" size:20]
//颜色
#define YAHEI [UIColor colorWithRed:61.0/255 green:61.0/255 blue:61.0/255 alpha:1]
#define GRAY [UIColor colorWithRed:169.0/255 green:169.0/255 blue:169.0/255 alpha:1]
#define CLEAR [UIColor clearColor]
#define WHITE [UIColor whiteColor]
#define setX(V) V.frame.origin.x+V.frame.size.width
#define setY(V) V.frame.origin.y+V.frame.size.height

//版本
#define SYSTEM_VERSION_COUNT [[[UIDevice currentDevice]systemVersion]floatValue]
//提示
//#define ALERT(msg)  [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil \
cancelButtonTitle:@"确定" otherButtonTitles:nil,nil] show]

#define ALERT(msg)  [[[HBAlertView alloc]initWithMessage:msg] show]
//打包时自动去除NSLog
//#ifdef DEBUG
//
//#define BCLog(...)  NSLog(__VA_ARGS__)
//
//#else

#define  SystemVersion [[[UIDevice currentDevice]systemVersion]floatValue]
//#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//#define MYBUNDLE_NAME @ "mapapi.bundle"
//#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
//#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


#define SERVICE_URL @"http://123.56.95.33:8080/HeBeiTV"
//#define SERVICE_URL @"http://59.61.92.182:85/HeBeiTV"

#define IMG_URL(path) [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVICE_URL,path]]

#endif
