//
//  TidbitGame.h
//
//  Created by Alexei Rudak on 11/9/12.
//
//

#import <Foundation/Foundation.h>

#import "Question.h"
#import "AlexStartApplication.h"



typedef enum {
	TD_TEXT = 0,
	TD_IMAGE = 1,
	TD_VIDEO = 2,
	TD_SOUND = 3
} TIDBIT_ENGINE_TYPE;

typedef enum {
	OGP_LINK = 0,
	OGP_VIEW = 1
} OTHER_GAMES_PROMO;



@interface TidbitGame : AlexStartApplication <AVAudioPlayerDelegate>
{
    BOOL packWasBought;
    
    NSMutableArray *questionArray;
	NSMutableArray *actorArray;
	
	Question *currentQuestion;
	NSInteger currentQuestionIndex;
	NSInteger rightQuestionsAnswered;
	
	NSInteger gameNum;
	NSInteger cumulativeCorrectAnswersCount;
	NSInteger strikeCorrectAnswersCount;
    NSInteger strikeNum;
	
	NSInteger secondsPassed;
	
	
	BOOL gameInProgress;
    BOOL gameCompleted;
	BOOL wasPreviousAnswerCorrect;
	
	NSTimer *timer;
	
    
    NSString *gameQuestionColor;
    
    TIDBIT_ENGINE_TYPE tidbitEngineType;
    OTHER_GAMES_PROMO otherGamesPromo;
    
    
    CGFloat leftCapWidth;
    CGFloat topCapHeight;
    
    UIFont *questionFont;
    UIFont *questionFontIPad;
    UIFont *answerFont;
    UIFont *answerFontIPad;
    
    BOOL buyTidbitItemModeEnabled;
    
    NSString *facebookLink;
    NSString *moreGamesLink;
}

@property (nonatomic, retain) NSString *facebookLink;
@property (nonatomic, retain) NSString *moreGamesLink;

@property (nonatomic, assign) BOOL packWasBought;



@property (nonatomic, retain) NSMutableArray *questionArray;
@property (nonatomic, retain) NSMutableArray *actorArray;
@property (nonatomic, retain) Question *currentQuestion;
@property (nonatomic, assign) NSInteger currentQuestionIndex;
@property (nonatomic, assign) NSInteger cumulativeCorrectAnswersCount;
@property (nonatomic, assign) NSInteger strikeCorrectAnswersCount;
@property (nonatomic, assign) NSInteger strikeNum;

@property (nonatomic, assign) NSInteger gameNum;
@property (nonatomic, assign) NSInteger rightQuestionsAnswered;
@property (nonatomic, assign) NSInteger secondsPassed;

@property (nonatomic, assign) BOOL gameInProgress;

@property (nonatomic, assign) BOOL gameCompleted;
@property (nonatomic, assign) BOOL wasPreviousAnswerCorrect;


@property (nonatomic, retain) NSString *gameQuestionColor;

@property (nonatomic, retain) UIFont *questionFont;
@property (nonatomic, retain) UIFont *questionFontIPad;
@property (nonatomic, retain) UIFont *answerFont;
@property (nonatomic, retain) UIFont *answerFontIPad;

@property (nonatomic, assign) TIDBIT_ENGINE_TYPE tidbitEngineType;
@property (nonatomic, assign) OTHER_GAMES_PROMO otherGamesPromo;


@property (nonatomic, assign) CGFloat leftCapWidth;
@property (nonatomic, assign) CGFloat topCapHeight;

@property (nonatomic, assign) BOOL buyTidbitItemModeEnabled;

+ (TidbitGame *) sharedInstance;



- (void) initEnvironment;

-(void) startNewGame;
-(void) nextQuestion;
-(void) endGame;
-(void) loadGameData;
-(void) saveGameData;
-(void) saveUserProperties;
-(void) loadUserProperties;
-(void) mixQuestions;


+(BOOL) isAnsweredForTidBitName:(NSString*) indexName;
+(NSString*) getRightBoxName:(NSString*) indexName;

- (void)playSound:(MCsounds)snd;

- (void)stopSounds;

-(void) enableSounds:(BOOL) enable;



- (NSString*) getPrefixNameForType;


@end
