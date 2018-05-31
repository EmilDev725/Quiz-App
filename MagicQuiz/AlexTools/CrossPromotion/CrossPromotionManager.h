//
//  CrossPromotionManager.h
//
//  Created by Alexei Rudak on 10/9/12.
//
//

#import <Foundation/Foundation.h>



@interface CrossPromotionManager : NSObject
{
    BOOL requestInProgress;
    BOOL loadOnlyDefaultJSON;
    
    NSMutableArray *items;
    
    UIFont *crossPromotionItemFont;
    UIFont *crossPromotionItemDescriptionFont;
    
    UIFont *crossPromotionItemFontIPad;
    UIFont *crossPromotionItemDescriptionFontIPad;
    
    NSInteger currentApplicationId;
}

@property (nonatomic, retain) NSMutableArray *items;

@property (nonatomic, retain) UIFont *crossPromotionItemFont;
@property (nonatomic, retain) UIFont *crossPromotionItemDescriptionFont;

@property (nonatomic, retain) UIFont *crossPromotionItemFontIPad;
@property (nonatomic, retain) UIFont *crossPromotionItemDescriptionFontIPad;

@property (nonatomic, assign) NSInteger currentApplicationId;
@property (nonatomic, assign) BOOL requestInProgress;
@property (nonatomic, assign) BOOL loadOnlyDefaultJSON;

+ (CrossPromotionManager *) sharedInstance;

-(void) requestItemsWithLang:(NSString*) lang loadDefault:(BOOL)loadDefaultVal
                       andId:(NSInteger)appId;
-(void) requestItemsWithLang:(NSString*) lang andId:(NSInteger)appId;

-(NSInteger) itemCount;

@end
