//
//  BaseAppDelegate.h
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import "iRate.h"
#include "Appirater.h"
#import <objc/runtime.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface BaseAppDelegate : NSObject <AppiraterDelegate, UNUserNotificationCenterDelegate> 
{
    UINavigationController *navigationController;
}

@property (nonatomic, retain) UINavigationController *navigationController;

-(void)addSettingExclusiveTouchToAllUIViewMethodWillMoveToSuperview;

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
