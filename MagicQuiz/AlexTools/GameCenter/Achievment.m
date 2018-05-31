//
//  Achievment.m
//
//  Created by Alexei Rudak on 21/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Achievment.h"
#import "VSUtils.h"

#if defined GAME_CENTER
#import "TidbitGame.h"
#endif

@implementation Achievment

@synthesize identifier,imagePath,name;



+(Achievment*) createItem:(NSString*)_identifier name:(NSString*) _name
{
    Achievment *achievment = [[Achievment alloc] init];

#if defined GAME_CENTER
	achievment.identifier = [NSString stringWithFormat:@"%@%@",_identifier,[TidbitGame sharedInstance].itunesGCAppSuffix];
#endif
	achievment.name = _name;
    return achievment;
}

+(Achievment*) createItem:(NSString*)_identifier name:(NSString*) _name
        imagePath:(NSString*)_imagePath
{
	Achievment *achievment = [[Achievment alloc] init];
    
#if defined GAME_CENTER
	achievment.identifier = [NSString stringWithFormat:@"%@%@",_identifier,[TidbitGame sharedInstance].itunesGCAppSuffix];
#endif
	achievment.name = _name;
    achievment.imagePath = _imagePath;
	return achievment;
}

@end
