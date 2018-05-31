//
//  GameViewController.m
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TidbitImageGameViewController.h"
#import "AnswerView.h"
#import "ExitGameView.h"
#import "TidbitGame.h"
#import "Question.h"
#import "TidbitFinalScoreViewController.h"
#import "VSUtils.h"

@implementation TidbitImageGameViewController

@synthesize imQuestion;


- (void)dealloc
{
	[imQuestion release];
    [super dealloc];
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
        NSString *s = [TidbitGame sharedInstance].currentQuestion.imageUrl;
		[imQuestion setImage:[UIImage imageNamed:s]];
		
		for(int a =0;a<4;a++)
		{
			UIButton *answerButton = [answerButtonsArray objectAtIndex:a];
			
			NSString *fileName = [VSUtils isIPad] ? @"btn_answers_ipad.png":@"btn_answers.png";
			
			[answerButton setBackgroundImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
            
            [answerButton setTitle:[[TidbitGame sharedInstance].currentQuestion.asnwers objectAtIndex:a] forState:UIControlStateNormal];
			
			NSString *answer = [[TidbitGame sharedInstance].currentQuestion.asnwers objectAtIndex:a];
			if([[TidbitGame sharedInstance].currentQuestion.rightAnswer isEqualToString:answer])
				[answerButton setTag:1];
			else
				[answerButton setTag:0];
			
			[lbQuestionNum setText:[NSString stringWithFormat:@"#%i",[TidbitGame sharedInstance].currentQuestionIndex]];
		}
		
		[self enableAnswerButtons:YES];
        
        questionSituation = Q_LOADED;
		   
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(IBAction) pressBuyGame:(id) sender
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    
    NSLog(@"url = %@",[TidbitGame sharedInstance].currentQuestion.buyUrl);
   
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:[TidbitGame sharedInstance].currentQuestion.buyUrl]]; 
}





@end
