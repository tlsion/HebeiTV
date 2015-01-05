//
//  AppDelegate.m
//  HebeiTV
//
//  Created by Pro on 5/13/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#define BaiduMapAppKey @"rf9TpoAK1IBshFOeIehE4OCP"
#define UmengAppkey @"5399063256240b79940b7681"
#define WeChatAppkey @"wx4dfdc7225d90dad5"
#define QQAppId @"1101508990"
#define QQAppkey @"T817P1qsG9achWUc"
#define LinkAddress @"http://www.zmh-tech.com"
#import "AppDelegate.h"
#import <ZYPush/LPService.h>
#import "UIView+Action.h"
#import "HBAlertView.h"

#import "UMSocial.h"
//#import "MobClick.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.userDefaults=[NSUserDefaults standardUserDefaults];
    application.statusBarStyle=UIStatusBarStyleLightContent;
    
    [LPService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [LPService setupWithOption:launchOptions];
    [self setZhiyouPush];

    
    [self youmenShake];
    [self getAppManagerupdateApk];
    // Override point for customization after application launch.
    return YES;
}
#pragma mark -- 友盟分享
-(void)youmenShake{
    //打开调试log的开关
    [UMSocialData openLog:NO];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WeChatAppkey url:LinkAddress];
    
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES appRedirectUrl:nil];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppkey url:LinkAddress];
    
    [UMSocialQQHandler setSupportQzoneSSO:YES];
    
    
    //使用友盟统计
//    [MobClick startWithAppkey:UmengAppkey];
    

}
#pragma mark -- 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [LPService registerDeviceToken:deviceToken];
}
-(void)setZhiyouPush{
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:@"LPAPNetworkDidSetupNotification" object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:@"LPAPNetworkDidCloseNotification" object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:@"LPAPNetworkDidRegisterNotification" object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:@"LPAPNetworkDidLoginNotification" object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:@"LPAPNetworkDidReceiveMessageNotification" object:nil];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}
- (void)networkDidSetup:(NSNotification *)notification {
}

- (void)networkDidClose:(NSNotification *)notification {
}

- (void)networkDidRegister:(NSNotification *)notification {
}

- (void)networkDidLogin:(NSNotification *)notification {
    
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *resultDic =[notification object];
//    NSString *tempStr = [NSString stringWithFormat:@"title:%@\ncontent:%@",[resultDic objectForKey:@"title"],[resultDic objectForKey:@"details"]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma end mark
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    application.applicationIconBadgeNumber=0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HebeiTV" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HebeiTV.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)updateUserInfo:(NSDictionary *)userInfo{
    if (userInfo) {
        [self.userDefaults setObject:[userInfo objectForKey:@"phone"] forKey:@"phone"];
        [self.userDefaults setObject:[userInfo objectForKey:@"password"] forKey:@"password"];
        [self.userDefaults setObject:[userInfo objectForKey:@"age"] forKey:@"age"];
        [self.userDefaults setObject:[userInfo objectForKey:@"sex"] forKey:@"sex"];
        [self.userDefaults setObject:[userInfo objectForKey:@"type"] forKey:@"type"];
        [self.userDefaults setObject:[userInfo objectForKey:@"userId"] forKey:@"userId"];
        [self.userDefaults setObject:[userInfo objectForKey:@"userimages"] forKey:@"userimages"];
        [self.userDefaults setObject:[userInfo objectForKey:@"username"] forKey:@"username"];
        [self.userDefaults setBool:YES forKey:@"islogin"];
        [self.userDefaults synchronize];
        
        [self getUserInfogetBean];
        
        [LPService setAlias:[NSString stringWithFormat:@"%@",[self.userDefaults objectForKey:@"userId"]] callBackHandler:^(BOOL isSucess, NSString *info) {
        }];
    }
}
#pragma mark -- httpService
-(void)getUserInfogetBean{
    NSString * userIdStr=[self.userDefaults objectForKey:@"userId"];
    if (userIdStr) {
        NSDictionary * paramDic=@{@"userId":[self.userDefaults objectForKey:@"userId"]};
        [HBHTTPService requestGetMethod:@"ImplUserInfogetBean.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            if (service.status==1) {
                NSInteger newBeansCount=[[service.allDataDic objectForKey:@"beans"] intValue];
                [self.userDefaults setInteger:newBeansCount forKey:@"beanscount"];
                [self.userDefaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_NEW_BEANS" object:nil];
            }
        }andServiceFailBlock:^(void){
            
        }];
    }
}
-(void)getAppManagerupdateApk{
    NSDictionary
    * paramDic=@{@"appDesc": @"ios"};
    [HBHTTPService requestGetMethod:@"ImplAppManagerupdateApk.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        AppDelegate * app=APP;
        [app getUserInfogetBean];
        if (service.status==1) {
            if (service.allLists.count>=1) {
                NSDictionary * dic=[service.allLists objectAtIndex:0];
                int appVersion=[[dic objectForKey:@"appVersion"] intValue];
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                
                int appBuild = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
                if (appVersion>appBuild) {
                    HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"目前有最新版本，是否升级?" leftButtonTitle:@"取消" rightButtonTitle:@"升级"];
                    [av show];
                    av.rightBlock=^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DownLoadURL]];
                        
                    };
                }
                
            }
        }
        
    }andServiceFailBlock:^(void){
        
    }];
}
@end
