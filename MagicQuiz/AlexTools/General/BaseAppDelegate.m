//
//  BaseAppDelegate.m
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import "BaseAppDelegate.h"
#import "UAirship.h"
#import "UAPush.h"
#import "ApplicationTools.h"
#import "Localization.h"

@implementation BaseAppDelegate

//@synthesize window;//
@synthesize navigationController;

static IMP gOringinalWillMoveToSuperview = nil;

static id newMoveToSuperviewPlusSettingExclusiveTouch(id self,SEL selector,...)
{
    va_list arg_list;
    va_start( arg_list,selector);
    gOringinalWillMoveToSuperview(self,selector,arg_list);
    [self setExclusiveTouch:YES];
    return nil;
}

-(void)addSettingExclusiveTouchToAllUIViewMethodWillMoveToSuperview
{
    gOringinalWillMoveToSuperview = class_getMethodImplementation([UIButton class], @selector(willMoveToSuperview:));
    class_replaceMethod([UIButton class], @selector(willMoveToSuperview:), &newMoveToSuperviewPlusSettingExclusiveTouch, "v@:");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    [Appirater appLaunched:YES];
//    [Appirater setDaysUntilPrompt:1];
//    [Appirater setUsesUntilPrompt:2];
//    [Appirater setSignificantEventsUntilPrompt:-1];
//    [Appirater setTimeBeforeReminding:2];
//    [Appirater setDelegate:self];
    
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
	// APS Setup
    
    /*
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    [UAirship takeOff:takeOffOptions];
    
    [[UAPush shared] resetBadge];
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
    
    
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                       applicationState:application.applicationState]; */
    
    //Push Notification
    [self registerForRemoteNotifications];
    
    return YES;
}

#pragma mark - AppiraterDelegate

-(void)appiraterDidDisplayAlert:(Appirater *)appirater
{
    [[ApplicationTools sharedInstance] eventHappened:@"Appirater : DidDisplayAlert" label:nil value:0];
}

-(void)appiraterDidDeclineToRate:(Appirater *)appirater
{
    [[ApplicationTools sharedInstance] eventHappened:@"Appirater: DidDeclineToRate" label:nil value:0];
}

-(void)appiraterDidOptToRate:(Appirater *)appirater
{
    [[ApplicationTools sharedInstance] eventHappened:@"Appirater: DidOptToRate" label:nil value:0];
}

-(void)appiraterDidOptToRemindLater:(Appirater *)appirater
{
    [[ApplicationTools sharedInstance] eventHappened:@"Appirater: DidOptToRemindLater" label:nil value:0];
}

#pragma mark - Push Notification
- (void) registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    }
    else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //[[UAPush shared] registerDeviceToken:deviceToken];
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"APNS Registered, Device Token: %@", deviceTokenStr);
    
    [[ApplicationTools sharedInstance] eventHappened:@"UA Push: Token registered" label:nil value:0];
}

- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"APNS Failed %@",str);
    
   [[ApplicationTools sharedInstance] eventHappened:@"UA Push: Failed" label:nil value:0];
   
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     NSDictionary *dict = [userInfo objectForKey:@"aps"];
     NSString *text = [dict objectForKey:@"alert"];
    
    
    NSLog(@"Push Received with text %@",text);
    
    //Loc(@"_Loc_Info")
     UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @""
     message:text
     delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: NULL] autorelease];
     [alert show];
    
    [[ApplicationTools sharedInstance] eventHappened:@"UA Push: Received" label:nil value:0];
    
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    
//    [[UAPush shared] handleNotification:userInfo applicationState:appState];
//    [[UAPush shared] resetBadge];
    
    
    [UAirship setLogLevel:UALogLevelTrace];
    UAConfig *config = [UAConfig defaultConfig];
    [UAirship takeOff:config];
    UA_LDEBUG(@"Config:\n%@", [config description]);
    [[UAirship push] resetBadge];
    
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

#pragma mark - Life cycle functions
- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
	[[ApplicationTools sharedInstance] appGoToBackgound];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[ApplicationTools sharedInstance] appGoToForeground];
    [Appirater appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UAirship push] resetBadge];
//     [[UAPush shared] resetBadge];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [UAirship land];
     [[ApplicationTools sharedInstance] appTerminate];
}

- (void)dealloc {
	
	[navigationController release];
	[super dealloc];
}

@end
