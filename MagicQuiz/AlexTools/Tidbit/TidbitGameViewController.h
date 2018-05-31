//
//  GameViewController.h
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidBitViewController.h"
#import "Achievment.h"
#import "AchievmentView.h"
#import "AnswerView.h"
#import "ExitGameView.h"
#import "VSButton.h"

typedef enum {
	Q_LOADED = 0,
	Q_ANSWERED
} QUESTION_SITUATION;

@interface TidbitGameViewController :  TidBitViewController <AchievmentViewDelegate>
{
	UILabel *lbQuestionNum,*lbScore,*lbQuestionText;
	UIButton *btAnswer1,*btAnswer2,*btAnswer3,*btAnswer4;
    VSButton *btMenu;
	AnswerView *answerView;
	ExitGameView *exitGameView;
	UIView *inView;
	NSMutableArray *answerButtonsArray;
	UIImageView *imStrike1,*imStrike2,*imStrike3;
    AchievmentView *achievmentView;
    
    QUESTION_SITUATION questionSituation;
    
    UIButton *btPromo;
}

@property (nonatomic, retain) IBOutlet UILabel *lbQuestionNum,*lbScore,*lbQuestionText;
@property (nonatomic, retain) IBOutlet UIButton *btAnswer1,*btAnswer2,*btAnswer3,*btAnswer4;
@property (nonatomic, retain) IBOutlet VSButton *btMenu;
@property (nonatomic, retain) IBOutlet AnswerView *answerView;
@property (nonatomic, retain) IBOutlet ExitGameView *exitGameView;
@property (nonatomic, retain) IBOutlet UIView *inView;
@property (nonatomic, retain) IBOutlet UIImageView *imStrike1,*imStrike2,*imStrike3;
@property (nonatomic, retain) NSMutableArray *answerButtonsArray;
@property (nonatomic, retain) IBOutlet AchievmentView *achievmentView;
@property (nonatomic, retain) IBOutlet UIButton *btPromo;

-(IBAction) backToMenu;
-(IBAction) pressContinue;
-(IBAction) pressAnswerButton:(id) sender;
-(IBAction) onMoreGames;
-(void) hideAnswerButtons:(BOOL) hide;
-(IBAction) onYES;
-(IBAction) onNO;

-(void) loadGUIForQuestion;
-(void) enableAnswerButtons:(BOOL)enable;
-(void) showAchievmentView:(Achievment*) achievment;
-(void) showFinalScoreViewController;

@end
