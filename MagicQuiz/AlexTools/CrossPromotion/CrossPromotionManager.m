//
//  CrossPromotionManager.m
//
//  Created by Alexei Rudak on 10/9/12.
//
//

#import "CrossPromotionManager.h"
#import "CJSONDeserializer.h"
#import "CrossPromotionItem.h"
#import "VSUtils.h"



@implementation CrossPromotionManager

@synthesize items;

@synthesize crossPromotionItemFont;
@synthesize crossPromotionItemDescriptionFont;

@synthesize crossPromotionItemFontIPad;
@synthesize crossPromotionItemDescriptionFontIPad;

@synthesize currentApplicationId;
@synthesize requestInProgress;
@synthesize loadOnlyDefaultJSON;

static CrossPromotionManager *sharedInstance = nil;

+ (CrossPromotionManager *)sharedInstance
{
	@synchronized(self) {
		if (sharedInstance == nil)
			sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

-(id)init
{
	if(self = [super init])
	{
        items = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
    [items release];
    [super dealloc];
}

-(NSInteger) itemCount
{
    return [items count];
}

-(void) loadJSONDatabase:(NSData*) returnData
{
    NSError *error = nil;
    NSDictionary *rootDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:returnData error:&error];
    
    if(error == nil)
    {
        [items removeAllObjects];
        
        NSArray *itemsJSON = [rootDictionary objectForKey:@"items"];
        for(NSDictionary *itemJSON in itemsJSON)
        {
            CrossPromotionItem *crossPromotionItem = [[CrossPromotionItem alloc] init];
            
            crossPromotionItem.identifier = [itemJSON objectForKey:@"index"];
            crossPromotionItem.name = [itemJSON objectForKey:@"name"];
            crossPromotionItem.description = [itemJSON objectForKey:@"description"];
            
            
            
            crossPromotionItem.imageUrl = [itemJSON objectForKey:@"imageUrl"];
            crossPromotionItem.imageFile = [itemJSON objectForKey:@"imageUrl"];
            
            crossPromotionItem.appstoreUrl = [itemJSON objectForKey:@"appstoreUrl"];
            
            NSInteger ident = [crossPromotionItem.identifier integerValue];
            
            if(currentApplicationId!=ident)
            {
                [items addObject:crossPromotionItem];
            }
            
            [crossPromotionItem release];
        }
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"crossPromotionItemsReceived" object:nil];
        
        
    }
}

-(void) loadDefaultJSONWithLang:(NSString*) language
{
    NSString *jsonString = [NSString stringWithFormat:@"CrossPromotion_%@",language];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonString ofType:@"json"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    
    [self loadJSONDatabase:htmlData];
}

-(void) requestItemsWithLang:(NSString*) lang loadDefault:(BOOL)loadDefaultVal
                       andId:(NSInteger)appId
{
    self.loadOnlyDefaultJSON = loadDefaultVal;
    [self requestItemsWithLang:lang andId:appId];
}

-(void) requestItemsWithLang:(NSString*) lang andId:(NSInteger)appId
{
    

    
    @synchronized(self)
    {
        if(!requestInProgress)
        {
            requestInProgress = YES;
            
            self.currentApplicationId = appId;
            
            // Locale info.
            NSLocale *locale = [NSLocale currentLocale];
            
            NSString *language;
            if ([[NSLocale preferredLanguages] count] > 0)
                language = [[NSLocale preferredLanguages] objectAtIndex:0];
            else
                language = [locale objectForKey:NSLocaleLanguageCode];
            
            
            if(lang == nil)
            {
                if(![language isEqualToString:@"en"] && ![language isEqualToString:@"ru"])
                    language = @"en";
            }
            else
            {
                language = lang;
            }
            
            if([VSUtils isConnectedToInternet:NO] && !self.loadOnlyDefaultJSON)
            {
                
            }
            else
            {
                [self loadDefaultJSONWithLang:language];
                
                requestInProgress = NO;
            }
            
            
            
        }
    }
       
   
}





@end
