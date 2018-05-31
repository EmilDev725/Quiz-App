//
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NTGAppDelegate.h"
#import "NTGRootViewController.h"
#import "MagicQuiz.h"
#import "VSUtils.h"
#import "CrossPromotionManager.h"
#import "ShareKitNTGConfigurator.h"
#import "SHKConfiguration.h"
#import "Appirater.h"

@implementation NTGAppDelegate

@synthesize window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    
    DefaultSHKConfigurator *configurator = [[ShareKitNTGConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    [configurator release];
    
    [Appirater setAppId:@"884588902"];
    
    [self addSettingExclusiveTouchToAllUIViewMethodWillMoveToSuperview];
    
    
    //[Appirater setDebug:YES];
    
    [[MagicQuiz sharedInstance] initEnvironment];
    [[MagicQuiz sharedInstance] appStart];
    
    
    //[[CrossPromotionManager sharedInstance] requestItemsWithLang:nil andId:4];
    //[[MagicQuiz sharedInstance] showChartboostAdsWithName:@"AppStart"];
    //[[MagicQuiz sharedInstance] showPlayhavenAds];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSString *nibName;
    if([VSUtils isIPad])
        nibName =  @"NTGRootViewControllerIPad";
    else
    {
        if([VSUtils isIPhone5Screen])
            nibName = @"NTGRootViewController-IPhone5";
        else
            nibName = @"NTGRootViewController";
    }
    
    NTGRootViewController *rootViewController = [[[NTGRootViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]] autorelease];
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [super application:application didFinishLaunchingWithOptions:launchOption];
    
    return YES;
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
    [[MagicQuiz sharedInstance] showChartboostAdsWithName:@"AppForeground"];
    
    [super applicationWillEnterForeground:application];
}

@end

