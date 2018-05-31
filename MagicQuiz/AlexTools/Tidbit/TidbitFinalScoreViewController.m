//
//  FinalScoreViewController.m
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TidbitFinalScoreViewController.h"
#import "TidbitGame.h"
#import "Question.h"
#import "TidbitImageGameViewController.h"
#import "VSUtils.h"
#import "Localization.h"
#import "ApplicationTools.h"

@implementation TidbitFinalScoreViewController

@synthesize imStrike1,imStrike2,imStrike3;
@synthesize btMenu;
@synthesize imResult;
@synthesize lbTopTitle;
@synthesize lbResult;
@synthesize lbScore;
@synthesize btPlayAgain;
@synthesize btPromo;
@synthesize btRate;

- (void)dealloc
{
    [imStrike1 release];
    [imStrike2 release];
    [imStrike3 release];
    [btMenu release];
    [imResult release];
    [lbTopTitle release];
    [lbResult release];
    [lbScore release];
    [btPlayAgain release];
    
    [super dealloc];
}



-(IBAction) onPlayAgain
{
    [[ApplicationTools sharedInstance] eventHappened:@"FinalScoreViewController: Play Again clicked" label:nil value:0];
    
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
    [[TidbitGame sharedInstance] endGame];
	[[TidbitGame sharedInstance] startNewGame];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
    NSString *strikeName = [VSUtils isIPad] ? @"strike_ipad.png":@"strike.png";
	
	if([TidbitGame sharedInstance].strikeNum > 0)
		[imStrike1 setImage:[UIImage imageNamed:strikeName]];
	
	if([TidbitGame sharedInstance].strikeNum > 1)
		[imStrike2 setImage:[UIImage imageNamed:strikeName]];
	
	if([TidbitGame sharedInstance].strikeNum > 2)
		[imStrike3 setImage:[UIImage imageNamed:strikeName]];
	
	
	
	if([TidbitGame sharedInstance].strikeNum <3 && [TidbitGame sharedInstance].rightQuestionsAnswered >= 20)
	{
        
	}
	else
	{
		
    }
    
    [Localization localizeView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *resizeFile = @"btn_resizable.png";
    if([VSUtils isIPad])
        resizeFile = @"btn_resizable_ipad.png";
    
    if([btMenu respondsToSelector:@selector(setImageResizingByCentralPixelWithFile:)])
        [btMenu setImageResizingByCentralPixelWithFile:resizeFile];
    
    
    
    
    [Localization localizeView:self.view];
    
  
}

-(IBAction) backToMenu
{
    [[TidbitGame sharedInstance] playSound:MCsoundButtonClick];
	[[TidbitGame sharedInstance] endGame];
	[self.navigationController popToRootViewControllerAnimated:YES];
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
