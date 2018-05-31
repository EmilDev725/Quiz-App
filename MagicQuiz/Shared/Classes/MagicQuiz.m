//
//
//  Created by Alexei Rudak on 09/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MagicQuiz.h"
#import "CJSONDeserializer.h"
#import "Question.h"
#import "VSUtils.h"
#import <GameKit/GameKit.h>
#import "Achievment.h"
#import "NTGAppDelegate.h"
#import "CrossPromotionManager.h"
#import "GlobalVariables.h"

extern UIFont *globalFont;
extern UIFont *globalFontIPad;
extern CGFloat fontSizeRatio;

@implementation MagicQuiz




- (void) createAchievments
{
    NSString *prefix = @"";
    if([VSUtils isIPad])
        prefix = @"_ipad";
    
    
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.HighFive" name:@"High-Five" imagePath:@"ac_first.png"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.HangTen" name:@"Hang Ten" imagePath:@"ac_up.png"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.Perfection" name:@"Perfection" imagePath:@"ac_star.png"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.WiseGuy" name:@"Wise Guy" imagePath:@"ac_gold.png"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.CenturyClub" name:@"Century Club" imagePath:@"v_star1.jpg"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.DoubleCentury" name:@"Double Century" imagePath:@"v_star2.jpg"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.GrandMaster" name:@"Grand Master" imagePath:@"v_star3.jpg"]];
    
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.SpeedDemon" name:@"Speed Demon" imagePath:@"v_star4.jpg"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.SuperSpeedDemon" name:@"Super Speed Demon" imagePath:@"v_star5.jpg"]];
    
    
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.10KClub" name:@"10KClub" imagePath:@"v_star6.jpg"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.100KClub" name:@"100KClub" imagePath:@"v_star7.jpg"]];
    [achievmentsAll addObject:[Achievment createItem:@"gl.kalak.uumasoq2.MillionaireClub" name:@"Millionaire Club" imagePath:@"ac_crown.png"]];
    
    
}

-(void) initEnvironment
{
    self.mainFont = [UIFont fontWithName: @"HelveticaNeue-CondensedBlack" size: 18];
    self.facebookLink = @"https://www.facebook.com/uumasoq.sunaava/";
    self.appPrefix = @"https://s5.mzstatic.com/us/r30/Purple4/v4/c5/3e/4f/c53e4ffe-014d-6ca1-f5dc-2da76db349e9/icon170x170.png";
    self.sharingAchievmentEnabled = YES;
    
    fontSizeRatio = 1.0f;
    globalFont = [UIFont fontWithName: @"HelveticaNeue-CondensedBlack" size: 18];
    globalFontIPad = [UIFont fontWithName: @"HelveticaNeue-CondensedBlack" size: 36];
    
    
    

    self.gcGlobalScoresTableID = @"gl.kalak.uumasoq2.tamani";
    self.gcLocalScoresTableID = @"gl.kalak.uumasoq2.pinermi";
    self.itunesGCAppSuffix = @"gl.kalak.uumasoq2";
    
    
    
#if defined GAME_CENTER
    achievmentsLoaded = NO;
    self.achievmentsAll = [[NSMutableArray alloc] init];
    self.achievmentsGot = [[NSMutableArray alloc] init];
    
    [self createAchievments];
#endif

    
    
    self.questionArray = [[NSMutableArray alloc] init];
    
    [self loadGameData];
    
}


-(void) loadGameData
{
	[self loadUserProperties];
    
    
    
    
	NSData *returnData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]
                                                         stringByAppendingPathComponent:@"Database.json"]];
    
    
    //NSString *key = @"BFHJA26A71490437AA024E4FADD5B497FDFF1A8EA6FF12F6FB65AF2720B59CCF";
    //[self encryptAndSaveData:returnData withKey:key];
    //returnData = [self decryptData:returnData withKey:key];
    
   
    
    
    NSError *error = nil;
    NSDictionary *rootDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:returnData error:&error];
    
    if(error == nil)
    {
        NSDictionary *questionsJSON = [rootDictionary objectForKey:@"questions"];
        
        NSMutableDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        if(data != nil)
        {
            self.gameNum = [(NSNumber*)[data objectForKey:@"gameNum"] intValue];
            self.questionArray = [NSKeyedUnarchiver unarchiveObjectWithData:[data objectForKey:@"questions"]];
            [self.questionArray retain];
            
            for(NSDictionary *questionJSON in questionsJSON)
            {
                for(Question *question in self.questionArray)
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
                        
                        NSNumber* n_pack = [questionJSON objectForKey:@"pack"];
                        question.pack = [n_pack integerValue];
                        
                        NSNumber* n_type = [questionJSON objectForKey:@"type"];
                        question.type = [n_type integerValue];
                        
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
                NSArray *questionArrayIDs = [self.questionArray valueForKeyPath:@"identifier"];
                if(![questionArrayIDs containsObject:[questionJSON objectForKey:@"id"]])
                {
                    Question *question = [Question createQuestionFromJSON:questionJSON];
                    
                    /*
                    if([[InAppManager sharedInstance] isItemPurchased:InAppItem_BuyPack1])
                        [questionArray addObject:question];
                    else
                    {
                        if(question.pack == 1)
                        {
                            [questionArray addObject:question];
                        }
                    }*/
                    
                    [self.questionArray addObject:question];
                }
            }
            
            // Delete questions if not exist
            NSMutableArray *questionsForRemoving = [[NSMutableArray alloc] init];
            
            NSArray *jsonQuestinsIDs = [questionsJSON valueForKeyPath:@"id"];
            for(Question *question in self.questionArray)
            {
                if(![jsonQuestinsIDs containsObject:question.identifier])
                {
                    [questionsForRemoving addObject:question];
                }
            }
            
            [self.questionArray removeObjectsInArray:questionsForRemoving];
            
            //NSLog(@"%i",[questionArray count]);
            
            [questionsForRemoving release];
            
            
        }
        else
        {
            self.questionArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *questionJSON in questionsJSON)
            {
                Question *question = [Question createQuestionFromJSON:questionJSON];
                
                NSArray *allIDs = [self.questionArray valueForKeyPath:@"identifier"];
                if(![allIDs containsObject:question.identifier])
                {
                    
                    [self.questionArray addObject:question];
                }
            }
        }
        
        NSLog(@"%lu",(unsigned long)[self.questionArray count]);
        
        [self saveGameData];
    }
}



@end
