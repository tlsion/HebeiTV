//
//  LPService.h
//  LPPushSDK
//
//  Created by 文夕 on 13-3-6.
//  Copyright (c) 2013年 danchwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern NSString * const LPAPNetworkDidSetupNotification;          // 建立连接
extern NSString * const LPAPNetworkDidCloseNotification;          // 关闭连接
extern NSString * const LPAPNetworkDidRegisterNotification;       // 注册成功
extern NSString * const LPAPNetworkDidLoginNotification;          // 登录成功
extern NSString * const LPAPNetworkDidReceiveMessageNotification; // 收到消息(非APNS)
@interface LPService : NSObject
{

}
//required
+ (void)setupWithOption:(NSDictionary *)launchingOption;      // 初始化
+ (void)registerForRemoteNotificationTypes:(int)types;        // 注册APNS类型
+ (void)registerDeviceToken:(NSData *)deviceToken;            // 向服务器上报Device Token
//optional
/**
 *  设置别名
 *
 *  @param alias 别名只能设置一个
 *  @param proHander 回调block
 */
+ (void)setAlias:(NSString *)alias callBackHandler:(void (^)(BOOL isSucess,NSString *info))proHander;

/**
 *  取消别名
 *
 *  @param alias 别名只能设置一个
 *  @param proHander 回调block
 */
+ (void)cancelAlias:(void (^)(BOOL isSucess,NSString *info))cancelHander;

/**
 *  设置标签
 *
 *  @param tags tag串，多个tag用,号分开
 *  @param proHander 回调block
 */
+(void)setTags:(NSString *)tags callBackHandler:(void (^)(BOOL isSucess,NSString *info))proHander;

/**
 *  发送位置信息，进行区域推送,限制至少两小时修改一次
 *
 *  @param lng 经度
 *  @param lat 维度
 *  @param t   类型:1、gps；2、百度；3、谷歌
 *  @param proHander 回调block
 */
+(void)sendLbsInfo:(double)lng latVlaue:(double)lat type:(int)t callBackHandler:(void (^)(BOOL isSucess,NSString *info))proHander;
@end
