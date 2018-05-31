//
//  TidbitGame.m
//
//  Created by Alexei Rudak on 11/9/12.
//
//

#import "TidbitGame.h"
#import "VSUtils.h"
#import "Achievment.h"
#import <GameKit/GameKit.h>
#import "CJSONDeserializer.h"
#import "BaseAppDelegate.h"
#import "TidbitGameViewController.h"

@implementation TidbitGame

@synthesize facebookLink;
@synthesize moreGamesLink;

@synthesize packWasBought;


@synthesize leftCapWidth;
@synthesize topCapHeight;
@synthesize gameCompleted;




@synthesize questionArray;
@synthesize currentQuestionIndex;
@synthesize secondsPassed;
@synthesize currentQuestion;
@synthesize gameInProgress;
@synthesize strikeNum;
@synthesize actorArray;
@synthesize gameNum;
@synthesize rightQuestionsAnswered;
@synthesize wasPreviousAnswerCorrect;
@synthesize strikeCorrectAnswersCount;
@synthesize tidbitEngineType;
@synthesize questionFont;
@synthesize questionFontIPad;
@synthesize answerFont;
@synthesize answerFontIPad;
@synthesize gameQuestionColor;
@synthesize cumulativeCorrectAnswersCount;
@synthesize otherGamesPromo;

@synthesize buyTidbitItemModeEnabled;


static TidbitGame *sharedInstance = nil;

+ (TidbitGame *)sharedInstance
{
    
	@synchronized(self) {
		if (sharedInstance == nil)
			sharedInstance = [[self alloc] init]; // assignement not done here
	}
	return sharedInstance;
}

- (void) initEnvironment
{
    [super initEnvironment];
    
    questionArray = [[NSMutableArray alloc] init];
    actorArray = [[NSMutableArray alloc] init];
    
    [self loadGameData];
    
}

- (NSString*) getPrefixNameForType
{
    NSArray *array = [NSArray arrayWithObjects:@"Tidbit",@"TidbitImage",@"TidbitVideo",nil];
    return [array objectAtIndex:tidbitEngineType];
}

-(void) checkForAchievments
{
	// *********************************** //
	
	int correctNum = 0;
	for(Question *question in questionArray)
	{
		if(question.answeredCorrectly == YES)
		{
			correctNum++;
		}
	}
    
    if(strikeCorrectAnswersCount >= 5)
        [self reportAchievementIdentifier:[NSString stringWithFormat:@"HighFive%@",itunesGCAppSuffix] percentComplete:100];
	
	if(strikeCorrectAnswersCount >= 10)
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"HangTen%@",itunesGCAppSuffix] percentComplete:100];
    
    if(strikeCorrectAnswersCount >= 20)
	{
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"Perfection%@",itunesGCAppSuffix] percentComplete:100];
    }
    
    if(correctNum == [questionArray count])
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"WiseGuy%@",itunesGCAppSuffix] percentComplete:100];
    
	
	if(cumulativeCorrectAnswersCount >= 100)
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"CenturyClub%@",itunesGCAppSuffix] percentComplete:100];
    
	if(cumulativeCorrectAnswersCount >= 200)
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"DoubleCentury%@",itunesGCAppSuffix] percentComplete:100];
	
	if(cumulativeCorrectAnswersCount >= 500)
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"GrandMaster%@",itunesGCAppSuffix] percentComplete:100];
    
    
	if(rightQuestionsAnswered >=10 && secondsPassed<60)
	{
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"SpeedDemon%@",itunesGCAppSuffix] percentComplete:100];
	}
	
	if(rightQuestionsAnswered >=10 && secondsPassed<30)
	{
		[self reportAchievementIdentifier:[NSString stringWithFormat:@"SuperSpeedDemon%@",itunesGCAppSuffix] percentComplete:100];
	}
	
	
	// *********************************** //
	
	
	if(globalPlayerScore >= 10000)
	{
        [self reportAchievementIdentifier:[NSString stringWithFormat:@"10KClub%@",itunesGCAppSuffix] percentComplete:100];
	}
	
	if(globalPlayerScore >= 100000)
	{
        [self reportAchievementIdentifier:[NSString stringWithFormat:@"100KClub%@",itunesGCAppSuffix] percentComplete:100];
	}
	
	if(globalPlayerScore >= 1000000)
	{
        [self reportAchievementIdentifier:[NSString stringWithFormat:@"MillionaireClub%@",itunesGCAppSuffix] percentComplete:100];
	}
	
	
	
	
}

-(void) showShareAchievmentView:(NSString*) achievmentIdentifier
{
	if(achievmentIdentifier!=nil)
	{
        Achievment *achievment = [self getAchievmentForIdentifier:achievmentIdentifier];
        if(achievment!=nil)
        {
            BaseAppDelegate *pDelegate = (BaseAppDelegate*)[UIApplication sharedApplication].delegate;
            UIViewController *controller = pDelegate.navigationController.topViewController;
            
            if([controller isKindOfClass:[TidbitGameViewController class]])
            {
                TidbitGameViewController *gameViewController = (TidbitGameViewController*)controller;
                [gameViewController showAchievmentView:achievment];
                
                CGRect rect = gameViewController.achievmentView.frame;
                
                if([VSUtils isIPad])
                {
                    gameViewController.achievmentView.frame = CGRectMake(rect.origin.x,-rect.size.height,rect.size.width,rect.size.height);
                }
                else
                {
                    gameViewController.achievmentView.frame = CGRectMake(rect.origin.x,-rect.size.height,rect.size.width,rect.size.height);
                }
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:1.0f];
                [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:gameViewController.achievmentView  cache:NO];
                
                if([VSUtils isIPad])
                {
                    gameViewController.achievmentView.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
                }
                else
                {
                    gameViewController.achievmentView.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
                }
                
                
                
                [UIView commitAnimations];
            }
        }
    }
	
}

- (void) resetGameCenterProgress
{
    globalPlayerScore = 0;
    
    strikeCorrectAnswersCount = 0;
    strikeNum = 0;
    rightQuestionsAnswered = 0;
    cumulativeCorrectAnswersCount = 0;
    gameCompleted = NO;
    
	[achievmentsGot removeAllObjects];
	
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
	 {
		 if (error != nil)
         {
             NSLog(@" ");
         }
		 // handle errors
	 }];
}


#pragma mark -
#pragma mark Sounds

-(void) enableSounds:(BOOL) enable
{
    soundEnable = enable;
    
    for(AVAudioPlayer *p in audioPlayers)
    {
        p.volume = soundEnable;
    }
    
    // audioPlayer2.volume = soundEnable;
    
}


- (void)playSound:(MCsounds)snd {
	
    if(soundEnable)
    {
        NSString *path = nil;
        
        switch (snd) {
            case MCsoundRightAnswer:
                path = [[NSBundle mainBundle] pathForResource:@"SFX_Answer_Right" ofType:@"aif"];
                break;
            case MCsoundWrongAnswer:
                path = [[NSBundle mainBundle] pathForResource:@"SFX_Answer_Wrong" ofType:@"aif"];
                break;
            case MCsoundButtonClick:
                path = [[NSBundle mainBundle] pathForResource:@"SFX_ButtonBeep_01" ofType:@"aif"];
                break;
            default:
                break;
        }
        
        if(path) {
            AVAudioPlayer *audioPlayerMC =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
            
            //audioPlayerMC.volume = [userDefaults floatForKey:@"SoundEnable"];
            [audioPlayerMC setDelegate:self];
            [audioPlayerMC play];
            
            [audioPlayers addObject:audioPlayerMC];
        }
        
    }
	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	[audioPlayers removeObject:player];
	[player release];
	
}

- (void)stopSounds {
	for(AVAudioPlayer *p in audioPlayers){
		[p stop];
	}
	//[audioPlayer2 stop];
}




-(void) asyncFileDownload:(NSString*) name
{
    //NSString *fullPath = [NSString stringWithFormat:@"%@/%@",TRAILER_SERVER_PATH,name];
}

- (void) nextQuestion
{
	if(strikeNum <3 && rightQuestionsAnswered < 20)
	{
		currentQuestion = nil;
		for(Question *question in questionArray)
		{
		
             /*
             static BOOL t = false;
             if([question.identifier isEqualToString:@"0098"] && !t)
             {
             currentQuestion = question;
             currentQuestion.priority = [NSNumber numberWithInt:3];
             
             t = true;
             
             break;
             }*/
            
            
			
			if([question.priority isEqualToNumber:[NSNumber numberWithInt:1]])
			{
                currentQuestion = question;
                currentQuestion.priority = [NSNumber numberWithInt:3];
			}
		}
		
		if(currentQuestion == nil)
		{
			NSInteger priority3Count = 0;
			NSArray *priorities = [questionArray valueForKeyPath:@"priority"];
			for(NSNumber *number in priorities)
			{
				if([number isEqualToNumber:[NSNumber numberWithInt:3]])
					priority3Count++;
                
			}
            
			if(priority3Count == [priorities count])
			{
				for(Question *question in questionArray)
					question.priority = [NSNumber numberWithInt:2];
			}
			
			for(Question *question in questionArray)
			{
				if([question.priority isEqualToNumber:[NSNumber numberWithInt:2]])
				{
					currentQuestion = question;
					currentQuestion.priority = [NSNumber numberWithInt:3];
					break;
				}
				
			}
		}
		
		
		NSMutableArray *answersArray = currentQuestion.asnwers;
		
		srandom((int)time(NULL));
		NSUInteger count = [answersArray count];
		for (NSUInteger i = 0; i < count; ++i) {
			int nElements = (int)(count - i);
			int n = (int)((arc4random() % nElements) + i);
			[answersArray exchangeObjectAtIndex:i withObjectAtIndex:n];
		}
		
		currentQuestion.asnwers = answersArray;
		
		currentQuestionIndex++;
	}
	else {
		gameInProgress = NO;
		gameCompleted = YES;
	}
}

+(BOOL) isAnsweredForTidBitName:(NSString*) tidbitName
{
	for(Question *question in [TidbitGame sharedInstance].questionArray)
	{
		if([question.tidbitname isEqualToString:tidbitName] && question.answeredCorrectly)
		{
			return YES;
		}
	}
	return NO;
}



+(NSString*) getRightBoxName:(NSString*) indexName
{
	for(Question *question in [TidbitGame sharedInstance].questionArray)
	{
		if([question.indexName isEqualToString:indexName])
		{
			return question.rightBoxName;
		}
	}
	return nil;
}



-(void) timerCalled
{
	secondsPassed++;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	
	if(localPlayer.authenticated && achievmentsLoaded)
		[self checkForAchievments];
	
}


-(void) mixQuestions
{
    srandom((int)time(NULL));
    NSUInteger count = [questionArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = (int)(count - i);
        int n = (int)((random() % nElements) + i);
        [questionArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(void) startNewGame
{
	
    // Init
    secondsPassed = 0;
    gameInProgress = YES;
    currentQuestionIndex = 0;
    rightQuestionsAnswered = 0;
    strikeCorrectAnswersCount = 0;
    strikeNum = 0;
    score = 0;
    gameNum++;
    
    gameCompleted = NO;
    
    srandom((int)time(NULL));
    NSUInteger count = [questionArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = (int)(count - i);
        int n = (int)((random() % nElements) + i);
        [questionArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    if(timer == nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self
                                               selector:@selector(timerCalled) userInfo:nil repeats:YES];
    }
    
    /*for(Question *question in questionArray)
     {
     NSMutableArray *answersArray = question.asnwers;
     
     srandom(time(NULL));
     NSUInteger count = [answersArray count];
     for (NSUInteger i = 0; i < count; ++i) {
     int nElements = count - i;
     int n = (arc4random() % nElements) + i;
     [answersArray exchangeObjectAtIndex:i withObjectAtIndex:n];
     }
     
     question.asnwers = answersArray;
     }*/
		
	
}

-(void) saveUserProperties
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)cumulativeCorrectAnswersCount] forKey:@"cumulativeCorrectAnswersCount"];
    
    [[NSUserDefaults standardUserDefaults] setBool:soundEnable forKey:@"soundEnable"];
    [[NSUserDefaults standardUserDefaults] setBool:packWasBought forKey:@"packWasBought"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) loadUserProperties
{
	NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"cumulativeCorrectAnswersCount"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"soundEnable"] == nil)
        soundEnable = YES;
    else
        soundEnable =  [[NSUserDefaults standardUserDefaults] boolForKey:@"soundEnable"];
    
    packWasBought = [[NSUserDefaults standardUserDefaults] boolForKey:@"packWasBought"];
    
	cumulativeCorrectAnswersCount = [value intValue];
}

-(void) endGame
{
	[timer invalidate];
	timer = nil;
	
	gameInProgress = NO;
	
	[self saveGameData];
}

-(void) loadGameData
{
	[self loadUserProperties];
    
	NSData *returnData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]
                                                         stringByAppendingPathComponent:@"Database.json"]];
    NSError *error = nil;
    NSDictionary *rootDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:returnData error:&error];
    
    if(error == nil)
    {
        NSDictionary *questionsJSON = [rootDictionary objectForKey:@"questions"];
        
        NSMutableDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        if(data != nil)
        {
            gameNum = [(NSNumber*)[data objectForKey:@"gameNum"] intValue];
            questionArray = [NSKeyedUnarchiver unarchiveObjectWithData:[data objectForKey:@"questions"]];
            [questionArray retain];
            
            for(NSDictionary *questionJSON in questionsJSON)
            {
                for(Question *question in questionArray)
                {
                    if([question.identifier isEqualToString:[questionJSON objectForKey:@"id"]])
                    {
                        question.rightAnswer= [questionJSON objectForKey:@"right"];
                        question.indexName= [questionJSON objectForKey:@"indexname"];
                        question.rightBoxName = [questionJSON objectForKey:@"rightboxname"];
                        question.indexMovie = [questionJSON objectForKey:@"indexmovie"];
                        question.indexBody = [questionJSON objectForKey:@"indexbody"];
                        question.asnwers = [NSMutableArray arrayWithArray:[questionJSON objectForKey:@"answers"]];
                        question.text = [questionJSON objectForKey:@"text"];
                        question.publisher = [questionJSON objectForKey:@"publisher"];
                        question.imageUrl = [questionJSON objectForKey:@"imageUrl"];
                        
                        //
                        NSString *path = [NSString stringWithFormat:@"%@",question.imageUrl];
                        UIImage *im = [UIImage imageNamed:path];
                        if(im)
                        {
                            
                        }
                        else
                        {
                            NSLog(@"%@",path);
                        }
                        
                        
                        //
                        
                        question.startVideoPlayTime = [[questionJSON objectForKey:@"startVideoPlayTime"] intValue];
                        question.endVideoPlayTime = [[questionJSON objectForKey:@"endVideoPlayTime"] intValue];
                        question.videoUrl = [questionJSON objectForKey:@"videoUrl"];
                        
                        
                        
                        question.tidbit = [questionJSON objectForKey:@"tidbit"];
                        question.tidbitname = [questionJSON objectForKey:@"tidbitname"];
                        question.tidbitnumber = [questionJSON objectForKey:@"tidbitnumber"];
                    }
                }
                
                // Add new questions if exist
                NSArray *questionArrayIDs = [questionArray valueForKeyPath:@"identifier"];
                if(![questionArrayIDs containsObject:[questionJSON objectForKey:@"id"]])
                {
                    Question *question = [Question createQuestionFromJSON:questionJSON];
                    [questionArray addObject:question];
                }
            }
            
            // Delete questions if not exist
            NSMutableArray *questionsForRemoving = [[NSMutableArray alloc] init];
            
            NSArray *jsonQuestinsIDs = [questionsJSON valueForKeyPath:@"id"];
            for(Question *question in questionArray)
            {
                if(![jsonQuestinsIDs containsObject:question.identifier])
                {
                    [questionsForRemoving addObject:question];
                }
            }
            
            [questionArray removeObjectsInArray:questionsForRemoving];
            
            //NSLog(@"%i",[questionArray count]);
            
            [questionsForRemoving release];
            
            
        }
        else
        {
            questionArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *questionJSON in questionsJSON)
            {
                Question *question = [Question createQuestionFromJSON:questionJSON];
                
                NSArray *allIDs = [questionArray valueForKeyPath:@"identifier"];
                if(![allIDs containsObject:question.identifier])
                {
                    [questionArray addObject:question];
                }
            }
        }
        
        [self saveGameData];
    }
}

-(void) saveGameData
{
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	[data setObject:[NSKeyedArchiver archivedDataWithRootObject:questionArray] forKey:@"questions"];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)gameNum] forKey:@"gameNum"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    [data release];
}

@end
