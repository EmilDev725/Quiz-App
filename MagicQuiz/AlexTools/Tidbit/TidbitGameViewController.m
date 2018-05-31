//
//  GameViewController.m

//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TidbitGameViewController.h"
#import "AnswerView.h"
#import "ExitGameView.h"
#import "Question.h"
#import "TidbitGame.h"
#import "TidbitFinalScoreViewController.h"
#import "VSUtils.h"
#import "Localization.h"

@implementation TidbitGameViewController

@synthesize lbQuestionNum,lbScore,lbQuestionText,answerView,exitGameView,achievmentView;
@synthesize btAnswer1,btAnswer2,btAnswer3,btAnswer4,btMenu;
@synthesize answerButtonsArray,inView;
@synthesize imStrike1,imStrike2,imStrike3;
@synthesize btPromo;

- (void)dealloc
{
	[answerButtonsArray release];
    [lbQuestionNum release];
    [lbScore release];
    [lbQuestionText release];
    [btAnswer1 release];
    [btAnswer2 release];
    [btAnswer3 release];
    [btAnswer4 release];
    [inView release];
    [imStrike1 release];
    [imStrike2 release];
    [imStrike3 release];
    [achievmentView release];
    [exitGameView release];
    [answerView release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	self.answerButtonsArray = [[NSMutableArray alloc] init];
		
	[answerButtonsArray addObject:btAnswer1];
	[answerButtonsArray addObject:btAnswer2];
	[answerButtonsArray addObject:btAnswer3];
	[answerButtonsArray addObject:btAnswer4];
	
	btAnswer1.titleLabel.textAlignment = NSTextAlignmentCenter;
    btAnswer2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btAnswer3.titleLabel.textAlignment = NSTextAlignmentCenter;
    btAnswer4.titleLabel.textAlignment = NSTextAlignmentCenter;
    
	
    
    
    
    
    
    
    
#ifdef LITE_VERSION
    if(![TidbitGame sharedInstance].packWasBought)
    {
        if([VSUtils isIPhone5Screen])
            [self showBannerAdvertismentAtPoints:CGPointMake(0,473)
                                       ipadCoord:CGPointMake(0,924)];
    }
    
#endif
    
    NSString *resizeFile = @"btn_resizable.png";
    if([VSUtils isIPad])
        resizeFile = @"btn_resizable_ipad.png";
    
    [btMenu setImageResizingByCentralPixelWithFile:resizeFile];
    
    [Localization localizeView:self.view];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void) hideAnswerButtons:(BOOL) hide
{
    for(UIButton *bt in answerButtonsArray)
    {
        [bt setHidden:hide];
    }
}

-(void) showAchievmentView:(Achievment*) achievment
{
    [inView setHidden:YES];
    
    [self.view addSubview:achievmentView];
    [achievmentView setDelegate:self];
    [achievmentView setData:achievment];
    
    [Localization localizeView:achievmentView];
}

 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 
     [TidbitGame sharedInstance].screenShowCount++;
     
     
     if(![VSUtils isIPad])
         [lbQuestionText setFont:[TidbitGame sharedInstance].questionFont];
     else {
         [lbQuestionText setFont:[TidbitGame sharedInstance].questionFontIPad];
     }
     
	 [self loadGUIForQuestion];
}

-(void) showFinalScoreViewController
{
    
    NSString *nibName = [VSUtils isIPad] ? @"FinalScoreViewControllerIPad":@"FinalScoreViewController";
    
    TidbitFinalScoreViewController *finalScoreViewController = [[TidbitFinalScoreViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:finalScoreViewController animated:NO];
    [finalScoreViewController release];
}

-(void) questionMovingFinished
{
	[btMenu setEnabled:YES];
}

-(void) loadGUIForQuestion
{
	[[TidbitGame sharedInstance] nextQuestion];
	
	if([TidbitGame sharedInstance].gameInProgress)
	{
		[lbQuestionText setText:[TidbitGame sharedInstance].currentQuestion.text];
		
		for(int a =0;a<4;a++)
		{
			UIButton *answerButton = [answerButtonsArray objectAtIndex:a];
			
			NSString *fileName = [VSUtils isIPad] ? @"btn_answers_ipad.png":@"btn_answers.png";
			
			[answerButton setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
			[answerButton setTitle:[[TidbitGame sharedInstance].currentQuestion.asnwers objectAtIndex:a] forState:UIControlStateNormal];
            
            
            if(![VSUtils isIPad])
                 [answerButton.titleLabel setFont:[TidbitGame sharedInstance].answerFont];
            else {
                 [answerButton.titleLabel setFont:[TidbitGame sharedInstance].answerFontIPad];
            }
             
			
			NSString *answer = [[TidbitGame sharedInstance].currentQuestion.asnwers objectAtIndex:a];
			if([[TidbitGame sharedInstance].currentQuestion.rightAnswer isEqualToString:answer])
				[answerButton setTag:1];
			else
				[answerButton setTag:0];
			
            [lbQuestionNum setText:[NSString stringWithFormat:@"#%li",(long)[TidbitGame sharedInstance].currentQuestionIndex]];
            
            // [lbQuestionNum setTextAlignment:UITextAlignmentLeft];
		}
        
        questionSituation = Q_LOADED;
		
		[self enableAnswerButtons:YES];
		
		if(![VSUtils isIPad])
			[inView setFrame:CGRectMake(320, 44, 320, 394)];
		else {
			[inView setFrame:CGRectMake(773, 91, 773, 846)];
		}

		
		[UIView beginAnimations:@"MyAnimation" context:nil];
		[UIView setAnimationBeginsFromCurrentState:NO];
		[UIView setAnimationDuration:0.5f];
        [UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(questionMovingFinished)];
        
		if(![VSUtils isIPad])
			[inView setFrame:CGRectMake(0, 44, 320, 394)];
		else {
			[inView setFrame:CGRectMake(0, 91, 773, 846)];
		}
		
		[UIView commitAnimations];
	}
	else 
	{
		[self showFinalScoreViewController];
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
	}
    
    [Localization localizeView:answerView];
}

-(void) enableAnswerButtons:(BOOL)enable
{
	for(int a =0;a<4;a++)
	{
		UIButton *answerButton = [answerButtonsArray objectAtIndex:a];
		[answerButton setUserInteractionEnabled:enable];
	}
}

-(IBAction) onMoreGames
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    [self pushControllerWithName:@"OtherAppsViewController"];
}

-(IBAction) pressAnswerButton:(id) sender
{
    //[[TidbitGame sharedInstance] reportAchievementIdentifier:@"Arhitect" percentComplete:100];
    
	UIButton *answerButton = (UIButton*)sender;
	//answerButton.tag = 1;
	
	[TidbitGame sharedInstance].wasPreviousAnswerCorrect = answerButton.tag;
	if(answerButton.tag == 0)
	{
        [[TidbitGame sharedInstance] playSound:MCsoundWrongAnswer];
        
		NSString *fileName = [VSUtils isIPad] ? @"btn_answers_wrong_ipad.png":@"btn_answers_wrong.png";
		[answerButton setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
		
		[TidbitGame sharedInstance].strikeCorrectAnswersCount = 0;
		[TidbitGame sharedInstance].strikeNum++;
		
		NSString *strikeName = [VSUtils isIPad] ? @"strike_ipad.png":@"strike@2x.png";
		
		if([TidbitGame sharedInstance].strikeNum == 1)
			[imStrike1 setImage:[UIImage imageNamed:strikeName]];
		
		if([TidbitGame sharedInstance].strikeNum == 2)
			[imStrike2 setImage:[UIImage imageNamed:strikeName]];
		
		if([TidbitGame sharedInstance].strikeNum == 3)
			[imStrike3 setImage:[UIImage imageNamed:strikeName]];
		
		[TidbitGame sharedInstance].globalPlayerScore-=100;
		[TidbitGame sharedInstance].score-=100;
	}
	else 
	{
        [[TidbitGame sharedInstance] playSound:MCsoundRightAnswer];
        
		NSString *fileName = [VSUtils isIPad] ? @"btn_answers_right_ipad.png":@"btn_answers_right.png";
		[answerButton setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
		
		if(![TidbitGame sharedInstance].currentQuestion.answeredCorrectly)
			[[TidbitGame sharedInstance].currentQuestion setAnsweredCorrectly:YES];
		
		[TidbitGame sharedInstance].globalPlayerScore+=100;
		[TidbitGame sharedInstance].score+=100;
		[TidbitGame sharedInstance].rightQuestionsAnswered+=1;
		
		
		if([TidbitGame sharedInstance].wasPreviousAnswerCorrect)
			[TidbitGame sharedInstance].strikeCorrectAnswersCount++;
        
		
		[TidbitGame sharedInstance].cumulativeCorrectAnswersCount++;
	}
	
	[lbScore setText:[VSUtils formatScores:[TidbitGame sharedInstance].score]];
	[[TidbitGame sharedInstance] saveUserProperties];
	
	[self performSelector:@selector(showAnswerView:) withObject:answerButton afterDelay:0.5f];
	[self enableAnswerButtons:NO];
}

-(void) leftAnimFinished
{
	[answerView removeFromSuperview];
	
	for(int a =0;a<4;a++)
	{
		UIButton *answerButton = [answerButtonsArray objectAtIndex:a];
		[answerButton setHidden:NO];
	}
	
	[self loadGUIForQuestion];
}

-(IBAction) pressContinue
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    [btMenu setEnabled:NO];
    
	[UIView beginAnimations:@"MyAnimation" context:nil];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(leftAnimFinished)];
	
	if(![VSUtils isIPad])
		[inView setFrame:CGRectMake(-320, 44, 320, 394)];
	else {
		[inView setFrame:CGRectMake(-773, 91, 773, 846)];
	}
	
	[UIView commitAnimations];
	
}


-(IBAction) onYES
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    
    if(questionSituation == Q_LOADED)
    {
        [self hideAnswerButtons:NO];
    }
    else if(questionSituation == Q_ANSWERED)
    {
        answerView.hidden = NO;
    }
    
	[exitGameView removeFromSuperview];
	[[TidbitGame sharedInstance] endGame];
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction) onNO
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if(questionSituation == Q_LOADED)
    {
        [self hideAnswerButtons:NO];
    }
    else if(questionSituation == Q_ANSWERED)
    {
        answerView.hidden = NO;
    }
    
	[exitGameView removeFromSuperview];
}

-(IBAction) backToMenu
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    if(![exitGameView superview])
	{
		[self.view addSubview:exitGameView];
        
        [exitGameView resizeButtonsWithImage:@"btn_resizable"];
        if(questionSituation == Q_LOADED)
        {
            [self hideAnswerButtons:YES];
        }
        else if(questionSituation == Q_ANSWERED)
        {
            answerView.hidden = YES;
        }
    }
    [Localization localizeView:exitGameView];
}




-(void) viewFinished
{
    [inView setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}




@end
