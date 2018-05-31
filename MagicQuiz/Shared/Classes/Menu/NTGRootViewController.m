//
//  NTGRootViewController.m
//
//  Created by Alexei Rudak on 11/16/12.
//
//

#import "NTGRootViewController.h"
#import "VSUtils.h"
#import "MagicQuiz.h"
#import "NTGImageGameViewController.h"
#import "ApplicationTools.h"
#import "OtherAppsViewController.h"

@implementation NTGRootViewController

-(void) showGameViewController
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    [[TidbitGame sharedInstance] startNewGame];
	
    [self pushControllerWithName:@"NTGImageGameViewController"];
}

-(IBAction) rateApp
{
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Rate clicked." label:nil value:0];
    
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternetWithMessage:@"Application is having trouble connecting to the server. Please check your internet connection"])
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=884588902&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
    }
}

-(IBAction) startGame
{
    //[[TidbitGame sharedInstance] resetGameCenterProgress];
    
    [[ApplicationTools sharedInstance] eventHappened:@"Main: Game Start" label:nil value:0];
    [self showGameViewController];
}





@end
