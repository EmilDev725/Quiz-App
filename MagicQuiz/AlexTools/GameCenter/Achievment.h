//
//  Achievment.h
//
//  Created by Alexei Rudak on 21/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Achievment : NSObject 
{
	NSString *identifier;
	NSString *imagePath;
    NSString *name;
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *name;

+(Achievment*) createItem:(NSString*)_identifier name:(NSString*) _name
                imagePath:(NSString*)_imagePath;

+(Achievment*) createItem:(NSString*)_identifier name:(NSString*) _name;
                

@end
