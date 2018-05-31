    //
//  TidBitViewController.m
//
//  Created by Alexei Rudak on 25/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TidBitViewController.h"
#import "UIView-Expanded.h"
#import "TidbitGame.h"
#import "VSUtils.h"

@implementation TidBitViewController

-(IBAction) onBack
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    
}

- (void)dealloc
{
    [super dealloc];
}



- (void)viewDidLoad 
{
    [super viewDidLoad];
}






@end
