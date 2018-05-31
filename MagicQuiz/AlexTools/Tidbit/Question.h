//
//  Question.h
//
//  Created by Alexei Rudak on 09/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Question : NSObject <NSCoding> 
{
	NSString *identifier;
	NSNumber *identifierNum;
	NSString *text;
	NSString *rightAnswer;
	NSString *indexName;
	
	NSString *indexBody;
	NSString *indexMovie;
	
	NSString *extraInfo;
	
	NSString *tidbitnumber;
	NSString *tidbitname;
	NSString *tidbit;
	NSString *rightBoxName;
    NSMutableArray *asnwers;
    
	BOOL answered;
	BOOL answeredCorrectly;
	NSNumber *priority;
    
    NSInteger type;
    NSInteger pack;
    
    // NTG
    NSString *buyUrl;
    NSString *publisher;
    NSString *imageUrl;
    
    // Video 
    NSInteger startVideoPlayTime;
    NSInteger endVideoPlayTime;
    NSString *videoUrl;
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSNumber *identifierNum;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *rightAnswer;
@property (nonatomic, retain) NSString *indexName;

@property (nonatomic, retain) NSString *indexBody;
@property (nonatomic, retain) NSString *indexMovie;

@property (nonatomic, retain) NSString *extraInfo;
@property (nonatomic, retain) NSString *tidbitnumber;
@property (nonatomic, retain) NSString *tidbitname;
@property (nonatomic, retain) NSString *tidbit;

@property (nonatomic, retain) NSString *rightBoxName;
@property (nonatomic, retain) NSMutableArray *asnwers;
@property (nonatomic, assign) BOOL answered;
@property (nonatomic, assign) BOOL answeredCorrectly;
@property (nonatomic, retain) NSNumber *priority;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger pack;

// NTG
@property (nonatomic, retain) NSString *publisher;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *buyUrl;

// Video 
@property (nonatomic, assign) NSInteger startVideoPlayTime;
@property (nonatomic, assign) NSInteger endVideoPlayTime;
@property (nonatomic, retain) NSString *videoUrl;

+(Question*) createQuestionFromJSON:(NSDictionary*) questionJSON;

@end
