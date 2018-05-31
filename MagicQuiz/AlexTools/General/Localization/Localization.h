//
//  Localization.h
//  
//
//

#import <Foundation/Foundation.h>

#define Loc(str) [[Localization sharedInstance] localizationForKey:str]

@interface LocalizationTableInfo : NSObject 
{
    NSBundle *tableBundle;
    NSString *tableName;
}

@property(retain) NSBundle *tableBundle;
@property(retain) NSString *tableName;

@end


@interface Localization : NSObject 
{
    NSMutableArray  *tables;
}

@property(nonatomic,retain) NSMutableArray *tables;

+(Localization *) sharedInstance;

+(void) localizeView:(UIView *)view recursive:(BOOL)recursive;
+(void) localizeView:(UIView *)view;

-(NSString *) localizationForKey:(NSString *)key;
-(void) scanBundleForLocalizationTables:(NSBundle *)bundle;

@end
