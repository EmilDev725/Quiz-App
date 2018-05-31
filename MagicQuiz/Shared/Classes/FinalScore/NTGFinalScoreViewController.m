//
//  NTGFinalScoreViewController.m
//
//  Created by Alexei Rudak on 3/6/13.
//
//

#import "NTGFinalScoreViewController.h"
#import "NTGImageGameViewController.h"
#import "TidbitGame.h"
#import "VSUtils.h"
#import "ApplicationTools.h"
#import "MagicQuiz.h"
#import "Localization.h"

@implementation NTGFinalScoreViewController


- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *resizeFile = @"btn_resizable.png";
    if([VSUtils isIPad])
        resizeFile = @"btn_resizable_ipad.png";
    
    [btPlayAgain setImageResizingByCentralPixelWithFile:resizeFile];
    
    
    
    
    [Localization localizeView:self.view];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(btPromo)
    {
        NSString *lang = [VSUtils getLocalLanguage];
        if([lang isEqualToString:@"ru"])
        {
            NSString *imgFilePromo = @"promo_games_ru.png";
            NSString *imgFileRate = @"rate_button_ru.png";
            
            [btPromo setImage:[UIImage imageNamed:imgFilePromo] forState:UIControlStateNormal];
            [btRate setImage:[UIImage imageNamed:imgFileRate] forState:UIControlStateNormal];
        }
    }
	
    
	
	NSString *strikeName = [VSUtils isIPad] ? @"strike_ipad.png":@"strike.png";
	
	if([TidbitGame sharedInstance].strikeNum > 0)
		[imStrike1 setImage:[UIImage imageNamed:strikeName]];
	
	if([TidbitGame sharedInstance].strikeNum > 1)
		[imStrike2 setImage:[UIImage imageNamed:strikeName]];
	
	if([TidbitGame sharedInstance].strikeNum > 2)
		[imStrike3 setImage:[UIImage imageNamed:strikeName]];
	
	
    
    NSInteger secForBonus = (300 - [TidbitGame sharedInstance].secondsPassed) > 0 ?
    (300 - [TidbitGame sharedInstance].secondsPassed):0;
    
	
	
	[lbScore setText:[VSUtils formatScores:[TidbitGame sharedInstance].score + secForBonus*5]];
	
	
    [TidbitGame sharedInstance].globalPlayerScore+=secForBonus*5;
    [TidbitGame sharedInstance].score+= secForBonus*5;
    
    [[TidbitGame sharedInstance] reportGCGlobalScore];
    [[TidbitGame sharedInstance] reportGCLocalScore];
    
	
	if([TidbitGame sharedInstance].strikeNum <3 && [TidbitGame sharedInstance].rightQuestionsAnswered >= 20)
	{
        [lbTopTitle setText:@"_Loc_20_Correct"];
        [lbResult setText:@"_Loc_You_Win"];
        [imResult setImage:[UIImage imageNamed:@"ac_chicken.png"]];
        
	}
	else
	{
        [lbTopTitle setText:@"_Loc_Three_Strikes"];
        [lbResult setText:@"_Loc_Game_Over"];
        [imResult setImage:[UIImage imageNamed:@"ac_cow.png"]];
    }
    
    
    [Localization localizeView:self.view];
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


-(IBAction) onPromo
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternet:YES])
    {
        [[ApplicationTools sharedInstance] eventHappened:@"Final Promo: Other Apps clicked" label:nil value:0];
        
        [self pushControllerWithName:@"OtherAppsViewController"];
    }
}

@end
