//
//  NTGImageGameViewController.m
//
//  Created by Alexei Rudak on 3/3/13.
//
//

#import "NTGImageGameViewController.h"
#import "NTGFinalScoreViewController.h"
#import "MagicQuiz.h"
#import "VSUtils.h"
#import "Localization.h"
#import "ApplicationTools.h"

@implementation NTGImageGameViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(btPromo)
    {
        NSString *lang = [VSUtils getLocalLanguage];
        if([lang isEqualToString:@"ru"])
        {
            NSString *imgFilePromo = @"promo_games_ru.png";
            [btPromo setImage:[UIImage imageNamed:imgFilePromo] forState:UIControlStateNormal];
        }
    }
}

-(IBAction) onPromo
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if([VSUtils isConnectedToInternet:YES])
    {
        [[ApplicationTools sharedInstance] eventHappened:@"Game Promo: Other Apps clicked" label:nil value:0];
        
        [self pushControllerWithName:@"OtherAppsViewController"];
    }
}

-(void) showFinalScoreViewController
{
    [self pushControllerWithName:@"NTGFinalScoreViewController"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    static int runCount = 0;
    runCount++;
    
    if(runCount > 0)
    {
        if(runCount%2 == 0)
        {
            [[MagicQuiz sharedInstance] showChartboostAdsWithName:@"GameStartScreen"];
        }
        
//        if(runCount%3 == 0)
//        {
//            [[MagicQuiz sharedInstance] showPlayhavenAds];
//        }
    }
    
}

-(void) showAnswerView:(UIButton*)sender
{
    BOOL result = (sender.tag == 0) ? NO : YES;
	
	for(int a =0;a<4;a++)
	{
		UIButton *answerButton = [answerButtonsArray objectAtIndex:a];
		[answerButton setHidden:YES];
	}
	
	if(![answerView superview])
	{
		[inView addSubview:answerView];
        
        questionSituation = Q_ANSWERED;
        
        [self hideAnswerButtons:YES];
		[answerView setGUIForQuestion:[TidbitGame sharedInstance].currentQuestion result:result];
        
        if([VSUtils isIPad])
            [answerView setFrame:CGRectMake(111, 341, 552, 380)];
        else
        {
            if([VSUtils isIPhone5Screen])
                [answerView setFrame:CGRectMake(21, 170, 276, 190)];
            else
                [answerView setFrame:CGRectMake(21, 156, 276, 196)];
        }
	}
    
    [Localization localizeView:answerView];
}

@end
