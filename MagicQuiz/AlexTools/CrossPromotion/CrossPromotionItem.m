//
//  CrossPromotionItem.m
//
//  Created by Alexei Rudak on 10/9/12.
//
//

#import "CrossPromotionItem.h"

@implementation CrossPromotionItem

@synthesize identifier,name,description,imageUrl,appstoreUrl,imageFile;

- (void) dealloc
{
    [identifier release];
    [name release];
    [description release];
    [imageUrl release];
    [appstoreUrl release];
    [super dealloc];
}


@end
