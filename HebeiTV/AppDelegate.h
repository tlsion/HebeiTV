//
//  AppDelegate.h
//  HebeiTV
//
//  Created by Pro on 5/13/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic) NSUserDefaults * userDefaults;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)updateUserInfo:(NSDictionary *)userInfo;
-(void)getUserInfogetBean;
@end
