//
//  TidbitAppDelegate.m
//
//  Created by Alexei Rudak on 11/10/12.
//
//

#import "TidbitAppDelegate.h"
#import "TidbitGame.h"
#import "VSUtils.h"

@implementation TidbitAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    
    [super application:application didFinishLaunchingWithOptions:launchOption];
    
    
	
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
	[[TidbitGame sharedInstance] endGame];
    
    [super applicationWillTerminate:application];
}

@end
