//
//  AlexStartApplication.m
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import "AlexStartApplication.h"
#import "ApplicationTools.h"
#import "BaseAppDelegate.h"
#import "ZipArchive.h"
#import <GameKit/GameKit.h>
#import "VSUtils.h"
#import "CJSONDeserializer.h"

@implementation AlexStartApplication

@synthesize superAdImageData;
@synthesize remoteNotificationMessageIndex;
@synthesize actionLinkForRemoteNotification;
@synthesize databaseFileIndex;
@synthesize databaseSyncInProgress;

@synthesize wallPosted, reviewLeft;
@synthesize shkPostingType;
@synthesize shkPostingWallNetwork;

@synthesize appPrefix;
@synthesize mainLanguage;
@synthesize appActiveCount;
@synthesize runCount;
@synthesize lastActiveDate;

@synthesize appName;
@synthesize appID;
@synthesize defaultBundle;

@synthesize showGuide;
@synthesize paused;

// Music playing
@synthesize audioPlayers;
@synthesize audioPlayer2;
@synthesize soundEnable;

#if defined GAME_CENTER
// Game Center
@synthesize achievmentsGot;
@synthesize achievmentsAll;
@synthesize globalPlayerScore;
@synthesize score;
@synthesize delegate;
@synthesize scoresReceived;
@synthesize achievmentsLoaded;
@synthesize gcGlobalScoresTableID;
@synthesize gcLocalScoresTableID;
@synthesize sharingAchievmentEnabled;
@synthesize itunesGCAppSuffix;
@synthesize gcLoginWasCancelled;
@synthesize gcLoadPlace;

#endif


@synthesize mainFont;
@synthesize mainFontIPad;
@synthesize feedbackScreenWasShown;
@synthesize screenShowCount;

@synthesize appVersion;

-(void) loadConfigurationData
{
    remoteNotificationMessageIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"remoteNotificationMessageIndex"];
    
    appActiveCount = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"appActiveCount"] integerValue];
    runCount = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"runCount"] integerValue];
    oldAppVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    lastActiveDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastActiveDate"];
    screenShowCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"screenShowCount"];
    feedbackScreenWasShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"feedbackScreenWasShown"];
    
#if defined GAME_CENTER
    gcLoginWasCancelled = [[NSUserDefaults standardUserDefaults] boolForKey:@"gcLoginWasCancelled"];
#endif
}

-(void) saveConfigurationData
{
    [[NSUserDefaults standardUserDefaults] setInteger:remoteNotificationMessageIndex forKey:@"remoteNotificationMessageIndex"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger: appActiveCount] forKey:@"appActiveCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: (int)runCount] forKey:@"runCount"];
    [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"appVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:lastActiveDate forKey:@"lastActiveDate"];
    [[NSUserDefaults standardUserDefaults] setInteger:screenShowCount forKey:@"screenShowCount"];
    
    [[NSUserDefaults standardUserDefaults] setBool:feedbackScreenWasShown forKey:@"feedbackScreenWasShown"];

#if defined GAME_CENTER
    [[NSUserDefaults standardUserDefaults] setBool:gcLoginWasCancelled forKey:@"gcLoginWasCancelled"];
#endif
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) initEnvironment
{
    shkFacebook = [[SHKFacebook alloc] init];
    shkFacebook.shareDelegate = self;
    
    shkTwitter = [[SHKTwitter alloc] init];
    shkTwitter.shareDelegate = self;
    
    shkVKontakte= [[SHKVkontakte alloc] init];
    shkVKontakte.shareDelegate = self;

    
#if defined GAME_CENTER
    achievmentsLoaded = NO;
    self.achievmentsAll = [[NSMutableArray alloc] init];
    self.achievmentsGot = [[NSMutableArray alloc] init];
    
    [self createAchievments];
#endif
    
    audioPlayers = [[NSMutableArray alloc] init];
    
}

- (void) dealloc
{
    [appName release];
    [appVersion release];
    [appID release];
    [super dealloc];
}

- (void) superAdRequest
{
    
#ifdef SUPER_AD_URL
    
    if([VSUtils isConnectedToInternet:NO] && !superAdRequestInProgress)
    {
        superAdRequestInProgress = YES;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
        dispatch_async(downloadQueue, ^{
            
            NSString *imageName = [VSUtils getImageNamePNG:@"superad"];
            NSURL *superAdImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SUPER_AD_URL,imageName]];
            NSData *data = [NSData dataWithContentsOfURL:superAdImageUrl];
            self.superAdImageData = data;
            
            superAdRequestInProgress = NO;
            
            [[NSNotificationCenter defaultCenter]
                postNotificationName:@"superAdWasLoaded" object:nil];
        });
        dispatch_release(downloadQueue);
    }
#endif
}

- (void) startRemoteNotificationRequest
{
    
#ifdef AS_NOTIFICATIONS_URL
    
    if([VSUtils isConnectedToInternet:NO] && !remoteNotificationRequestInProgress)
    {
        remoteNotificationRequestInProgress = YES;
        
        NSMutableString *fullPath = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",AS_NOTIFICATIONS_URL]]; // imac development
        
        
        NSURL *url = [NSURL URLWithString:fullPath];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse*r, NSData* returnData, NSError* serverError) {
            
            remoteNotificationRequestInProgress = NO;
            
            if(serverError == nil)
            {
                NSError *error = nil;
                NSDictionary *rootDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:returnData error:&error];
                
                if(error == nil)
                {
                    NSNumber *index = [rootDictionary objectForKey:@"index"];
                    if([index integerValue] != -1)
                    {
                        NSDictionary *dialog = [rootDictionary objectForKey:@"dialog"];
                        if([index integerValue] != remoteNotificationMessageIndex)
                        {
                            remoteNotificationMessageIndex = [index integerValue];
                            
                            [[NSUserDefaults standardUserDefaults] setInteger:remoteNotificationMessageIndex forKey:@"remoteNotificationMessageIndex"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            NSDictionary *localizedDialog = [dialog objectForKey:mainLang];
                            
                            NSString *message = [localizedDialog objectForKey:@"message"];
                            NSString *butOKTitle = [localizedDialog objectForKey:@"but_ok"];
                            NSString *butCancelTitle = [localizedDialog objectForKey:@"but_cancel"];
                            NSString *butActionTitle = [localizedDialog objectForKey:@"but_action"];
                            
                            self.actionLinkForRemoteNotification = [localizedDialog objectForKey:@"link"];
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                                           {
                                               if([self.actionLinkForRemoteNotification length] > 0)
                                               {
                                                   UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:butCancelTitle otherButtonTitles:butActionTitle, nil];
                                                   [alert setTag:ALEXSTART_NOTIFICATION_POPUP_ACTION_TAG];
                                                   [alert show];
                                                   [alert release];
                                               }
                                               else
                                               {
                                                   UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:butOKTitle otherButtonTitles: nil];
                                                   [alert setTag:ALEXSTART_NOTIFICATION_POPUP_SIMPLE_TAG];
                                                   [alert show];
                                                   [alert release];
                                               }
                                               
                                               
                                           }
                                           );
                        }
                    }
                    
                }
         
            }
            
        }];
        [request release];
        [fullPath release];
        [queue release];
    }
#endif
    
}

- (void) managingTimerFunction
{
    [self startRemoteNotificationRequest];
}

- (void) startManagingTimerWithLang:(NSString*) mainLangVal
{
    mainLang = mainLangVal;
    managingTimer = [NSTimer scheduledTimerWithTimeInterval:ALEXSTART_MANAGING_TIMER_INTERVAL
                                                     target:self selector:@selector(managingTimerFunction)
                                                   userInfo:nil repeats:YES];
    [managingTimer setFireDate:[NSDate date]];
}


- (void)sharerStartedSending:(SHKSharer *)sharer;
{
    
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin;
{
    
}
- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    
}
- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    
}
- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    switch (shkPostingType) {
        case SHK_PT_WALL_PROMO:
        {
            NSString *network = @"";
            switch (shkPostingWallNetwork) {
                case SHK_PT_WALL_SOCIAL_NETWORK_FB:
                    network = @"FB";
                    break;
                case SHK_PT_WALL_SOCIAL_NETWORK_TW:
                    network = @"TW";
                    break;
                case SHK_PT_WALL_SOCIAL_NETWORK_VK:
                    network = @"VK";
                    break;
                default:
                    break;
            }
            
            NSString *text = [NSString stringWithFormat:@"Wall posted successfully to %@",network];
            [[ApplicationTools sharedInstance] eventHappened:text label:nil value:0];
            
            [[NSNotificationCenter defaultCenter]
                            postNotificationName:@"wallPosted" object:nil];
            break;
        }
        default:
            break;
    }
    
    [self saveConfigurationData];
}

- (void) postAppPromotionToFBWithText:(NSString*) text
{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/student-1-uspesnaa-uceba-v/id547887995?mt=8"];
    SHKItem *item = [SHKItem URL:url title:text contentType:SHKURLContentTypeWebpage];
    
    shkPostingType = SHK_PT_WALL_PROMO;
    shkPostingWallNetwork = SHK_PT_WALL_SOCIAL_NETWORK_FB;
    shkFacebook.item = item;
    
    [shkFacebook share];
}

- (void) postAppPromotionToTwitterWithText:(NSString*) text
{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/student-1-uspesnaa-uceba-v/id547887995?mt=8"];
    SHKItem *item = [SHKItem URL:url title:text contentType:SHKURLContentTypeWebpage];
    
    shkPostingType = SHK_PT_WALL_PROMO;
    shkPostingWallNetwork = SHK_PT_WALL_SOCIAL_NETWORK_TW;
    shkTwitter.item = item;
    
    [shkTwitter share];
}

- (void) postAppPromotionToVKontakteWithText:(NSString*) text
{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/student-1-uspesnaa-uceba-v/id547887995?mt=8"];
    SHKItem *item = [SHKItem URL:url title:text contentType:SHKURLContentTypeWebpage];
    
    shkPostingType = SHK_PT_WALL_PROMO;
    shkPostingWallNetwork = SHK_PT_WALL_SOCIAL_NETWORK_VK;
    shkVKontakte.item = item;
    
    [shkVKontakte share];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALEXSTART_NOTIFICATION_POPUP_ACTION_TAG:
            switch (buttonIndex)
            {
                case 0:
                    [[ApplicationTools sharedInstance] eventHappened:@"AS Notication Action Cancelled" label:nil value:0];
                    break;
                case 1:
                    [[ApplicationTools sharedInstance] eventHappened:@"AS Notication Action Opened" label:nil value:0];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionLinkForRemoteNotification]];
                    break;
            }
            break;
        default:
            break;
    }
}

- (void) loadJSONDatabaseWithRootNode:(NSDictionary*) rootNode
{
    
}

-(void) increaseAppActiveCount
{
	self.appActiveCount++;
    self.lastActiveDate = [NSDate date];
}

-(void) increaseRunCount
{
	runCount++;
}

/*! Must be called once at application startup */
-(void) appStart
{
    [[ApplicationTools sharedInstance] startTools];
    
    NSString *launchType = nil;
	
	if([self runCount]==0)
	{
		launchType = @"FirstLaunch";
	}else
	{
		launchType = @"AppLaunch";
	}
	
	UIDevice *device = [UIDevice currentDevice];
	NSString *deviceInfo = [[VSUtils platformString] stringByAppendingFormat:@"-%@",device.systemVersion];
	if([VSUtils isJailBroken])
		deviceInfo = [deviceInfo stringByAppendingString:@"-JB"];
    
	[[ApplicationTools sharedInstance] sysEventHappened:launchType label:deviceInfo value:0];
    
	[self updateVersionData];
    [self loadConfigurationData];
    
    
     NSString *language;
     if(!mainLanguage)
         language = [VSUtils getLocalLanguage];
     else
         language = mainLanguage;
    
    [self startManagingTimerWithLang:language];
    
	if(oldAppVersion!=nil && ![appVersion isEqualToString:oldAppVersion])
	{
        [[ApplicationTools sharedInstance] sysEventHappened:[NSString stringWithFormat:@"Update from %@ to %@",oldAppVersion, appVersion] label:@"" value:0];
	}
	[self increaseRunCount];
    [self increaseAppActiveCount];
    
#ifdef REVMOB_ID
    [Revmob initWithAppId: REVMOB_ID];
    
//    [RevMobAds startSessionWithAppID:REVMOB_ID];
#endif
    
#if defined (ChartsBoostsAppID)
    [Chartboost startWithAppId:ChartsBoostsAppID
                  appSignature:ChartBoostsAppSignature
                      delegate:self];
    [Chartboost cacheInterstitial:@"Menu"];
#endif    
    
#ifdef PLAYHAVAN_TOKEN
    [[PHPublisherContentRequest requestForApp: PLAYHAVAN_TOKEN secret: PLAYHAVAN_SECRET placement:PLAYHAVAN_PLACE delegate:self] preload]; //level_complete
    
    if(!_notificationView)
    {
        _notificationView = [[PHNotificationView alloc] initWithApp:PLAYHAVAN_TOKEN secret:PLAYHAVAN_SECRET placement:PLAYHAVAN_PLACE];
        _notificationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
#endif  
    
    [self saveConfigurationData];
}

- (void) createAchievments
{
    
}

- (void)didDismissInterstitial:(NSString *)location {
    
}


- (void)didFailToLoadInterstitial:(NSString *)location;
{
    NSLog(@"%@",location);
}

-(void) showPlayhavenAds
{
#ifdef PLAYHAVAN_TOKEN
    PHPublisherContentRequest *request = [PHPublisherContentRequest requestForApp: PLAYHAVAN_TOKEN secret: PLAYHAVAN_SECRET placement:PLAYHAVAN_PLACE delegate:self];
    [request send];
#endif
}

#pragma mark - Chartboost
-(void) showChartboostAdsWithName:(NSString*) placeName
{
#if defined (ChartsBoostsAppID)
    [Chartboost showInterstitial:placeName];
#endif
}

-(void) showChartboostAds
{
#if defined (ChartsBoostsAppID)
    [Chartboost showInterstitial:@"Menu"];
#endif
}

-(void) updateVersionData
{
	NSDictionary *info  = [[NSBundle mainBundle] infoDictionary];
    
    appName = [[info objectForKey:@"CFBundleName"] retain];
	appVersion =  [[info objectForKey:@"CFBundleVersion"] retain];
    appID  =  [[info objectForKey:@"CFBundleIdentifier"] retain];
}

#ifdef GAME_CENTER

-(NSString*) getImageForAchievment:(NSString*)identifier
{
    for(Achievment *achievment in achievmentsAll)
	{
        if([achievment.identifier isEqualToString:identifier])
		{
			return achievment.name;
		}
	}
	return nil;
}

-(void) checkForAchievments
{
	
	
}

- (void) reportGCLocalScore
{
    [self reportValue:gcLocalScoresTableID value:score];
}
- (void) reportGCGlobalScore
{
    [self reportValue:gcGlobalScoresTableID value:globalPlayerScore];
}

- (void) closeView:(UIImageView*)imageV
{
	BaseAppDelegate *pDelegate = (BaseAppDelegate*)[UIApplication sharedApplication].delegate;
	UIViewController *controller = pDelegate.navigationController.topViewController;
	
	CGRect rect = controller.view.frame;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:imageV  cache:NO];
	
	if([VSUtils isIPad])
	{
		imageV.frame = CGRectMake((rect.size.width - 568) / 2.0, -90, 568, 88);
	}
	else
	{
		imageV.frame = CGRectMake((rect.size.width - 284) / 2.0, -45, 284, 44);
	}
    
	[UIView commitAnimations];
}

- (void) showFromImageName:(NSString*)name
{
	if(name!=nil)
	{
		BaseAppDelegate *pDelegate = (BaseAppDelegate*)[UIApplication sharedApplication].delegate;
		UIViewController *controller = pDelegate.navigationController.topViewController;
		
		CGRect rect = controller.view.frame;
		
        UILabel *labelAchievmentName = [[UILabel alloc] init];
        UILabel *labelAchievmentText = [[UILabel alloc] init];
        
        
        NSString *imageName = @"achievement.png";
        
        if([VSUtils isIPad])
            imageName = @"achievement_ipad.png";
            
		UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		[imageV autorelease];
		
		if([VSUtils isIPad])
		{
			imageV.frame = CGRectMake((rect.size.width - 568) / 2.0, -90, 568, 88);
		}
		else
		{
			imageV.frame = CGRectMake((rect.size.width - 284) / 2.0, -45, 284, 44);
		}
        
        [labelAchievmentName setBackgroundColor:[UIColor clearColor]];
        [labelAchievmentName setTextColor:[UIColor colorWithRed:255/255.0f green:204/255.0f blue:0 alpha:1]];
        [labelAchievmentName setText:name];
        [labelAchievmentName setFont:[UIFont fontWithName:labelAchievmentName.font.fontName size:[VSUtils isIPad]?28:15]];
         
        [labelAchievmentName setTextAlignment:NSTextAlignmentCenter];
        [labelAchievmentName setFrame:CGRectMake(0,imageV.frame.size.height*0.333f,imageV.frame.size.width,imageV.frame.size.height*(0.66f))];
        
        [labelAchievmentText setBackgroundColor:[UIColor clearColor]];
        [labelAchievmentText setTextColor:[UIColor whiteColor]];
        [labelAchievmentText setText:@"Achievment:"];
        [labelAchievmentText setFont:[UIFont fontWithName:labelAchievmentName.font.fontName size:[VSUtils isIPad]?28:15]];
        [labelAchievmentText setTextAlignment:NSTextAlignmentCenter];
        [labelAchievmentText setFrame:CGRectMake(0,imageV.frame.size.height*0.1f,imageV.frame.size.width,imageV.frame.size.height*0.333f)];
        
        [imageV addSubview:labelAchievmentName];
        [imageV addSubview:labelAchievmentText];
        [labelAchievmentName release];
        [labelAchievmentText release];
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:imageV  cache:NO];
		
		if([VSUtils isIPad])
		{
			imageV.frame = CGRectMake((rect.size.width - 568) / 2.0, 10, 568, 88);
		}
		else
		{
			imageV.frame = CGRectMake((rect.size.width - 284) / 2.0, 10, 284, 44);
		}
        
		[UIView commitAnimations];
		[controller.view addSubview:imageV];
		
		[self performSelector:@selector(closeView:) withObject:imageV afterDelay:3.4];
	}
	
}
-(Achievment*) getAchievmentForIdentifier:(NSString*)identifier
{
	for(Achievment *achievment in achievmentsAll)
	{
		if([achievment.identifier isEqualToString:identifier])
		{
			return achievment;
		}
	}
	
	return nil;
}

-(void) showShareAchievmentView:(NSString*) achievmentIdentifier
{
    
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    if ([self isUserLogin]) {
		
		for(GKAchievement *achievement in self.achievmentsGot){
			if([achievement.identifier isEqualToString:identifier])
				return;
		}
		
		
		GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
		if (achievement)
		{
			
			if(percent >= 100.0f)
			{
				[self showFromImageName:[self getImageForAchievment:identifier]];
                
                if(sharingAchievmentEnabled)
                {
                    if([VSUtils isSystemVersionGreaterThanOrEqualTo:@"6.0"])
                    {
                        [self showShareAchievmentView:identifier];
                    }
                    
                }
                
                [self.achievmentsGot addObject:[achievement retain]];
			}
			
			
			achievement.percentComplete = percent;
//            [achievement reportAchievementWithCompletionHandler:^(NSError *error)
//             {
//                 if (error != nil)
//                 {
//                     // Retain the achievement object and try again later (not shown).
//
//                 }
//
//             }];
            NSArray *achievements = [NSArray arrayWithObjects: achievement, nil];
            [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    
                }
            }];
            
		}
	}
}

- (BOOL) isGameCenterSuport
{
	// Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

- (void) resetGameCenterProgress
{
    globalPlayerScore = 0;
    
    
    
	[achievmentsGot removeAllObjects];
	
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
	 {
		 if (error != nil)
         {
             NSLog(@" ");
         }
		 // handle errors
	 }];
}

-(BOOL) isUserLogin
{
    return [GKLocalPlayer localPlayer].authenticated;
}

- (void) reportValue:(NSString*)leaderboard value:(int64_t)value
{
	
    if ([self isUserLogin])
    {
//        GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:leaderboard] autorelease];
        GKScore *scoreReporter = [[[GKScore alloc] initWithLeaderboardIdentifier:leaderboard] autorelease];
        scoreReporter.value = value;
//        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
//
//            if (error != nil)
//            {
//                // handle the reporting error
//            }
//        }];
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                
            }
        }];
    }
	
}


- (void) startGameKit:(GC_LOAD_PLACE)gcLoadPlaceVal
{
	if ([self isGameCenterSuport] == FALSE)
	{
        if ([delegate respondsToSelector:@selector(gameCenterError:)])
            [delegate gameCenterError:gcLoadPlaceVal];
        
		return;
	}
	
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        if(error == nil)
        {
            if (localPlayer.isAuthenticated)
            {
                gcLoginWasCancelled = NO;
                
                if ([delegate respondsToSelector:@selector(userWasLogged:)])
                    [delegate userWasLogged:gcLoadPlaceVal];
                
                [self saveConfigurationData];
                
                if(!achievmentsLoaded)
                {
                    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
                     {
                         if (error == nil)
                         {
                             if(achievements!=nil)
                                 self.achievmentsGot = [achievements mutableCopy];
                             
                             achievmentsLoaded = YES;
                         }
                         else
                         {
                             if ([delegate respondsToSelector:@selector(gameCenterError:)])
                                 [delegate gameCenterError:gcLoadPlaceVal];
                         }
                     }];
                }
                
                if(!scoresReceived)
                {
                    GKLeaderboard *board = [[[GKLeaderboard alloc] init] autorelease];
                    
                    if(board != nil) {
                        board.identifier = gcGlobalScoresTableID;
                        //                        board.category = gcGlobalScoresTableID;
                        board.timeScope = GKLeaderboardTimeScopeAllTime;
                        board.range = NSMakeRange(1, 1);
                        
                        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                            
                            scoresReceived = YES;
                            
                            if ([delegate respondsToSelector:@selector(gotScores)])
                                [delegate gotScores];
                            
                            if (error != nil) {
                                // handle the error.
                                NSLog(@"Error retrieving score.%@", error);
                                
                                if ([delegate respondsToSelector:@selector(gameCenterError:)])
                                    [delegate gameCenterError:gcLoadPlaceVal];
                            }
                            globalPlayerScore = board.localPlayerScore.value;
                        }];
                    }
                }
            }
        }
        else
        {
            if(error.code == 2)
            {
                gcLoginWasCancelled = YES;
                [self saveConfigurationData];
            }
            
            if ([delegate respondsToSelector:@selector(gameCenterError:)])
                [delegate gameCenterError:gcLoadPlaceVal];
        }
    };
}

#endif

@end
