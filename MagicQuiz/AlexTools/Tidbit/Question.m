//
//  Question.m
//
//  Created by Alexei Rudak on 09/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Question.h"


@implementation Question

@synthesize identifier,rightAnswer,asnwers,text,answered,answeredCorrectly,indexName,rightBoxName,indexBody,indexMovie,priority;
@synthesize extraInfo,tidbitnumber,tidbitname,tidbit;
@synthesize identifierNum;
@synthesize type;
@synthesize pack;

// NTG
@synthesize imageUrl;
@synthesize buyUrl;
@synthesize publisher;

// Video
@synthesize startVideoPlayTime;
@synthesize endVideoPlayTime;
@synthesize videoUrl;

- (void)dealloc
{
    [identifier release];
    [rightAnswer release];
    [asnwers release];
    [text release];
    [indexName release];
    [rightBoxName release];
    [indexBody release];
    [indexMovie release];
    [extraInfo release];
    [tidbitnumber release];
    [tidbitname release];
    [tidbit release];
    [identifierNum release];
    
    // NTG
    [imageUrl release];
    [buyUrl release];
    [publisher release];
    
    [super dealloc];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder 
{
	[encoder encodeObject:identifier forKey:@"identifier"];
	[encoder encodeObject:identifierNum forKey:@"identifierNum"];
	[encoder encodeObject:text forKey:@"text"];
	[encoder encodeObject:rightAnswer forKey:@"rightAnswer"];
	[encoder encodeObject:indexName forKey:@"indexName"];
	
	[encoder encodeObject:indexBody forKey:@"indexBody"];
	[encoder encodeObject:indexMovie forKey:@"indexMovie"];
	
	[encoder encodeObject:extraInfo forKey:@"extraInfo"];
	[encoder encodeObject:tidbitnumber forKey:@"tidbitnumber"];
	[encoder encodeObject:tidbitname forKey:@"tidbitname"];
	[encoder encodeObject:tidbit forKey:@"tidbit"];
	
	[encoder encodeObject:rightBoxName forKey:@"rightBoxName"];
	[encoder encodeObject:asnwers forKey:@"asnwers"];
	[encoder encodeObject:[NSNumber numberWithInt:answered] forKey:@"answered"];
	[encoder encodeObject:[NSNumber numberWithInt:answeredCorrectly] forKey:@"answeredCorrectly"];
	[encoder encodeObject:priority forKey:@"priority"];
    
    [encoder encodeObject:[NSNumber numberWithInt:pack] forKey:@"pack"];
    [encoder encodeObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    
    // NTG
	[encoder encodeObject:buyUrl forKey:@"buyUrl"];
    [encoder encodeObject:publisher forKey:@"publisher"];
    [encoder encodeObject:imageUrl forKey:@"imageUrl"];
    
    // Video
    
    [encoder encodeObject:[NSNumber numberWithInt:startVideoPlayTime] forKey:@"startVideoPlayTime"];
	[encoder encodeObject:[NSNumber numberWithInt:endVideoPlayTime] forKey:@"endVideoPlayTime"];
    [encoder encodeObject:videoUrl forKey:@"videoUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if(self = [super init]) 
	{
		self.identifier = [decoder decodeObjectForKey:@"identifier"];
		self.identifierNum = [decoder decodeObjectForKey:@"identifierNum"];
		self.text = [decoder decodeObjectForKey:@"text"];
		self.rightAnswer = [decoder decodeObjectForKey:@"rightAnswer"];
		self.indexName = [decoder decodeObjectForKey:@"indexName"];
		self.indexBody = [decoder decodeObjectForKey:@"indexBody"];
		self.indexMovie = [decoder decodeObjectForKey:@"indexMovie"];
		self.rightBoxName = [decoder decodeObjectForKey:@"rightBoxName"];
		self.asnwers = [decoder decodeObjectForKey:@"asnwers"];
		self.answered = [(NSNumber*)[decoder decodeObjectForKey:@"answered"] intValue];
		self.answeredCorrectly = [(NSNumber*)[decoder decodeObjectForKey:@"answeredCorrectly"] intValue];
		self.priority = [decoder decodeObjectForKey:@"priority"];
        
        self.pack = [(NSNumber*)[decoder decodeObjectForKey:@"pack"] intValue];
        self.type = [(NSNumber*)[decoder decodeObjectForKey:@"type"] intValue];
		
		self.extraInfo = [decoder decodeObjectForKey:@"extraInfo"];
		self.tidbitnumber = [decoder decodeObjectForKey:@"tidbitnumber"];
		self.tidbitname = [decoder decodeObjectForKey:@"tidbitname"];
		self.tidbit = [decoder decodeObjectForKey:@"tidbit"];
        
        // NTG
        self.publisher = [decoder decodeObjectForKey:@"publisher"];
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.buyUrl = [decoder decodeObjectForKey:@"buyUrl"];
        
         // Video
        self.videoUrl = [decoder decodeObjectForKey:@"videoUrl"];
        self.startVideoPlayTime = [(NSNumber*)[decoder decodeObjectForKey:@"startVideoPlayTime"] intValue];
		self.endVideoPlayTime = [(NSNumber*)[decoder decodeObjectForKey:@"endVideoPlayTime"] intValue];
	}
	return self;
}

+(Question*) createQuestionFromJSON:(NSDictionary*) questionJSON
{
    Question *question = [[Question alloc] init];
    question.identifier = [questionJSON objectForKey:@"id"];
    
    NSInteger iVal = [question.identifier intValue];
    question.identifierNum = [NSNumber numberWithInt:iVal];
    
    question.rightAnswer= [questionJSON objectForKey:@"right"]; 
    question.indexName= [questionJSON objectForKey:@"indexname"]; 
    question.rightBoxName = [questionJSON objectForKey:@"rightboxname"]; 
    question.indexMovie = [questionJSON objectForKey:@"indexmovie"]; 
    question.indexBody = [questionJSON objectForKey:@"indexbody"]; 
    question.asnwers = [NSMutableArray arrayWithArray:[questionJSON objectForKey:@"answers"]];
    question.text = [questionJSON objectForKey:@"text"];
    question.extraInfo = [questionJSON objectForKey:@"extrainfo"];
    question.priority = [NSNumber numberWithInt:1];
    
    question.tidbit = [questionJSON objectForKey:@"tidbit"];
    question.tidbitname = [questionJSON objectForKey:@"tidbitname"];
    question.tidbitnumber = [questionJSON objectForKey:@"tidbitnumber"];
    
    
    NSString* n_pack = [questionJSON objectForKey:@"pack"];
    
    NSInteger i_pack = [n_pack integerValue];
    question.pack = i_pack;
    
    NSNumber* n_type = [questionJSON objectForKey:@"type"];
    question.type = [n_type integerValue];
    
    // NTG
    question.publisher = [questionJSON objectForKey:@"publisher"];
    question.imageUrl = [questionJSON objectForKey:@"imageUrl"];
    question.buyUrl = [questionJSON objectForKey:@"buyUrl"];
    
    // Video
    question.startVideoPlayTime = [[questionJSON objectForKey:@"startVideoPlayTime"] intValue];
    question.endVideoPlayTime = [[questionJSON objectForKey:@"endVideoPlayTime"] intValue];
    question.videoUrl = [questionJSON objectForKey:@"videoUrl"];
    
    return [question autorelease];
}

@end
