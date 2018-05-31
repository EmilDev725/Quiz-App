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





@interface BaseAppDelegate : NSObject <AppiraterDelegate> 
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
