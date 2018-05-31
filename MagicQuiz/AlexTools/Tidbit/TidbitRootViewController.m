//
//  RootViewController.m
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TidbitRootViewController.h"
#import "TidbitGameViewController.h"
#import "TidbitGame.h"
#import "AlexStartApplication.h"

#import "VSUtils.h"
#import "AlexStartApplication.h"
#import "ApplicationTools.h"
#import "Localization.h"

@implementation TidbitRootViewController

@synthesize btAchievments,btScores,btSound;
@synthesize lbCopyright;



#pragma mark -
#pragma mark View lifecycle

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
   
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
	[self dismissModalViewControllerAnimated:YES];
}

-(void) enableGUIForGC:(BOOL) enable
{
    btScores.enabled = enable;
    btAchievments.enabled = enable;
}

- (void)viewDidLoad {
    
   
    
    [super viewDidLoad];

	
	
    if(![self isGameCenterSuport])
    {
        [self enableGUIForGC:NO];
    }
    
    [self enableGUIForGC:NO];
    
    [Localization localizeView:self.view];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[TidbitGame sharedInstance] setDelegate:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([TidbitGame sharedInstance].soundEnable)
    {
        //[btSound 
        NSString *fileName = [VSUtils isIPad] ? @"btn_sound_ipad@2x.png":@"btn_sound@2x.png";
        [btSound setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    }
    else
    {
        NSString *fileName = [VSUtils isIPad] ? @"btn_soundoff_ipad@2x.png":@"btn_soundoff@2x.png";
        [btSound setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    }
    
    
    
	if([VSUtils isConnectedToInternet:NO] && [VSUtils isGameCenterAvailable])
	{
		[btScores setEnabled:YES];
		[btAchievments setEnabled:YES];
		
        if(![TidbitGame sharedInstance].gcLoginWasCancelled)
        {
            if(![TidbitGame sharedInstance].scoresReceived)
            {
                //[self showLoadingHUD];
                
                [[TidbitGame sharedInstance] setDelegate:self];
                [[TidbitGame sharedInstance] startGameKit:GC_MAIN];
            }
        }
        else
        {
            
        }
		
	}
	else 
	{
		[btScores setEnabled:NO];
		[btAchievments setEnabled:NO];
	}
}

-(IBAction) showInApps
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    [self pushControllerWithName:@"InAppsViewController"];
}

-(IBAction) resetAchievments
{
	[[TidbitGame sharedInstance] resetGameCenterProgress];
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

- (void) gameCenterError:(GC_LOAD_PLACE)gcLoadPlace
{
    
        switch (gcLoadPlace) {
        case GC_SCORES:
        {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: @"Game Center Login Error"
                                                             message: @""
                                                            delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: NULL] autorelease];
            [alert show];
            break;
        }
        case GC_ACHIEVMENTS:
        {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: @"Game Center Login Error"
                                                             message: @""
                                                            delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: NULL] autorelease];
            [alert show];
            break;
        }
        default:
            break;
    }
    
	[self hideLoadingHUD];
}

-(void) gotScores
{
	[self hideLoadingHUD];
}

-(void) showGameViewController
{
    
}


-(IBAction) startGame
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Start Game clicked" label:nil value:0];
    
    //[[TidbitGame sharedInstance] resetGameCenterProgress];
	[self showGameViewController];
}



- (void) userWasLogged:(GC_LOAD_PLACE)gcLoadPlace
{
    switch (gcLoadPlace) {
        case GC_SCORES:
        {
            GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
            if (leaderboardController != nil)
            {
                leaderboardController.leaderboardDelegate = self;
                [self presentModalViewController: leaderboardController animated: YES];
            }
            break;
        }
        case GC_ACHIEVMENTS:
        {
            GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
            if (achievements != NULL)
            {
                achievements.achievementDelegate = self;
                [self presentModalViewController: achievements animated: YES];
            }
            break;
        }
        default:
            break;
    }
    
}

-(IBAction) showGameKitScores
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Leaderboard button clicked." label:nil value:0];
    
	[[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternetWithMessage:@"Application is having trouble connecting to the server. Please check your internet connection"])
    {
    
        if([[TidbitGame sharedInstance] isUserLogin])
        {
            GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
            if (leaderboardController != nil)
            {
                leaderboardController.leaderboardDelegate = self;
                [self presentModalViewController: leaderboardController animated: YES];
            }
        }
        else
        {
            /*
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: @"Game Center Login Required" 
                                                            message: @""
                                                           delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: NULL] autorelease];
            [alert show];*/
            
            [[TidbitGame sharedInstance] setDelegate:self];
            [[TidbitGame sharedInstance] startGameKit:GC_SCORES];
        }
    }
	
}

-(IBAction) showAchievments
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Achievments button clicked." label:nil value:0];
    
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternetWithMessage:@"Application is having trouble connecting to the server. Please check your internet connection"])
    {
        
        if([[TidbitGame sharedInstance] isUserLogin])
        {
            GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
            if (achievements != NULL)
            {
                achievements.achievementDelegate = self;
                [self presentModalViewController: achievements animated: YES];
            }
        }
        else
        {
            /*
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: @"Game Center Login Required" 
                                                             message: @""
                                                            delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: NULL] autorelease];
            [alert show];*/
            
            [[TidbitGame sharedInstance] setDelegate:self];
            [[TidbitGame sharedInstance] startGameKit:GC_ACHIEVMENTS];
        }
    }

}



-(IBAction) showFacebook
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Facebook link button clicked." label:nil value:0];
    
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternetWithMessage:@"Application is having trouble connecting to the server. Please check your internet connection"])
    {
        
        if([TidbitGame sharedInstance].facebookLink!=nil &&
           [[TidbitGame sharedInstance].facebookLink length] > 0)
        {
            [[ApplicationTools sharedInstance] eventHappened:@"Main: Facebook link clicked." label:nil value:0];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[TidbitGame sharedInstance].facebookLink]];
        }
    }
}

-(IBAction) showOtherGames
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Other Apps button clicked." label:nil value:0];
    
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternetWithMessage:@"Application is having trouble connecting to the server. Please check your internet connection"])
    {
        [self pushControllerWithName:@"OtherAppsViewController"];
    }
}

-(IBAction) turnSounds
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Other games button clicked." label:nil value:0];
    
    [TidbitGame sharedInstance].soundEnable = ![TidbitGame sharedInstance].soundEnable;
    
    [[TidbitGame sharedInstance] saveUserProperties];
    
    if([TidbitGame sharedInstance].soundEnable)
    {
        //[btSound 
        NSString *fileName = [VSUtils isIPad] ? @"btn_sound_ipad@2x.png":@"btn_sound@2x.png";
        [btSound setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    }
    else
    {
        NSString *fileName = [VSUtils isIPad] ? @"btn_soundoff_ipad@2x.png":@"btn_soundoff@2x.png";
        [btSound setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    }
    
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [btAchievments release];
    [btScores release];
    [btSound release];
    [lbCopyright release];
    [super dealloc];
}


@end

