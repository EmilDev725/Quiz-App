//
//  AnswerView.m
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnswerView.h"

#import "TidbitGame.h"
#import "VSUtils.h"
#import "Localization.h"

@implementation AnswerView

@synthesize lbResult;

-(id) initWithCoder:(NSCoder *)aCoder
{
    if(self = [super initWithCoder:aCoder])
    {
        [self initGUI];
    }
    return self;
}

- (void) initGUI
{
    
    
}

- (void)dealloc
{
    [lbResult release];
    [lbPublished release];
    [lbExtraInfo release];
    [lbCorrectAnswerTitle release];
    [lbCorrectAnswer release];
    [lbUnlockedTitle release];
    [btNext release];
    [btContinue release];
    [btBuy release];
    [super dealloc];
}

-(void) setGUIForQuestion:(Question*)question result:(BOOL)result
{
    NSString *resizeFile = @"btn_resizable.png";
    if([VSUtils isIPad])
        resizeFile = @"btn_resizable_ipad.png";
    
    
    [btNext setImageResizingByCentralPixelWithFile:resizeFile];
    [btContinue setImageResizingByCentralPixelWithFile:resizeFile];
    
    
    
    if(result)
	{
		[lbResult setText:Loc(@"_Loc_Right")];
		[lbCorrectAnswerTitle setHidden:YES];
		[lbCorrectAnswer setText:question.rightAnswer];
        
        
	}
	else 
	{
		[lbResult setText:Loc(@"_Loc_Wrong")];
		[lbCorrectAnswerTitle setHidden:NO];
		[lbCorrectAnswer setText:question.rightAnswer];
        [lbUnlockedTitle setText:@""];
	}
	
    NSLog(@"%li",(long)[TidbitGame sharedInstance].currentQuestionIndex);
	
	if([TidbitGame sharedInstance].strikeNum >= 3 || [TidbitGame sharedInstance].rightQuestionsAnswered>=20)
	{
		[btContinue setHidden:NO];
		[btNext setHidden:YES];
        
        if([TidbitGame sharedInstance].buyTidbitItemModeEnabled)
            [btBuy setHidden:YES];
    }
	else 
	{
		[btContinue setHidden:YES];
		[btNext setHidden:NO];
        
        if([TidbitGame sharedInstance].buyTidbitItemModeEnabled)
            [btBuy setHidden:NO];
	}

    
	if([VSUtils isIPad])
		[self setFrame:CGRectMake(111, 341, 552, 380)];
	else
        [self setFrame:CGRectMake(21, 156, 276, 190)];
}

@end
