//
//  Localization.m
//
//

#import "Localization.h"


@implementation LocalizationTableInfo

@synthesize tableBundle;
@synthesize tableName;


-(void) dealloc
{
    [tableName release];
    [tableBundle release];
    [super dealloc];
}


@end


static Localization* sharedInstance = nil;

@implementation Localization



@synthesize tables;

-(void) addLocalizationTable:(LocalizationTableInfo *)table
{
    for (LocalizationTableInfo *val in tables)
    {
        if(val.tableBundle == table.tableBundle && [val.tableName isEqualToString:table.tableName])
        {
            return;
        }
    }
    //NSLog(@"Added localization table:%@",table.tableName);
    [tables addObject:table];
}

-(void) scanBundleForLocalizationTables:(NSBundle *)bundle curDir:(NSString *)dir
{
    NSArray *dirContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    for (NSString *file in dirContent) 
    {
        if([[file pathExtension] isEqualToString:@"strings"]) 
        {
            LocalizationTableInfo *info = [[LocalizationTableInfo alloc] init];
            info.tableBundle = bundle;
            info.tableName = [file stringByDeletingPathExtension];
            [self addLocalizationTable:info];
            [info release];
        }
        if([[file pathExtension] isEqualToString:@"lproj"])
        {
            [self scanBundleForLocalizationTables:bundle curDir:[dir stringByAppendingPathComponent:file]];
        }
    }  
}

-(void) scanBundleForLocalizationTables:(NSBundle *)bundle
{
    [self scanBundleForLocalizationTables:bundle curDir:[bundle bundlePath]];
}

-(id) init
{
    if( (self = [super init]) )
    {
        tables = [[NSMutableArray alloc] init];
        [self scanBundleForLocalizationTables:[NSBundle mainBundle]];
    }
    return self;
}

+ (Localization*) sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil){
			sharedInstance = [[Localization alloc] init];
		}
	}
    return sharedInstance;
}

-(NSString *) expandTemplateParams:(NSString *)string
{
    NSString *appName = @"A";
    NSString *appVersion = @"V";
    
    NSString *rv = [string stringByReplacingOccurrencesOfString:@"%appname%" withString:appName];
    rv = [rv stringByReplacingOccurrencesOfString:@"%appversion%" withString:appVersion];
    return rv;
}



-(NSString *) localizationForKey:(NSString *)key
{
    for (LocalizationTableInfo *table in tables)
    {
        NSString *val = [table.tableBundle localizedStringForKey:key value:nil table:table.tableName];
        if(val != key)
        {
            if([key hasSuffix:@"_Tmpl"])
            {
                return [self expandTemplateParams:val];
            }else
            {
                return val;
            }
        }
    }
    //NSLog(@"Failed to find localization for key:%@",key);
    return key;
}

+(void)localizeView:(UIView *)baseView recursive:(BOOL)recursive
{
	for(UIView *view in baseView.subviews)
	{
		if(recursive)
			[self localizeView:view recursive:YES];
		
		if([view respondsToSelector:@selector(text)] && [view respondsToSelector:@selector(setText:)])
		{
            
            //NSLog(@"%@",[view text]);
            
			NSString *locKey = [view performSelector:@selector(text)];
			if([locKey hasPrefix:@"_Loc_"])
			{
				NSString *locText = Loc(locKey);
				[view performSelector:@selector(setText:) withObject:locText];
			}
		}
		
		if([view isKindOfClass:[UIButton class]])
		{
			UIButton *tView = (UIButton *)view;
			NSString *defKey = [tView titleForState:UIControlStateNormal];
			if([defKey hasPrefix:@"_Loc_"])
			{
				NSString *locText = Loc(defKey);
				[tView setTitle:locText forState:UIControlStateNormal];
			}
		}
	}
}


+ (void) localizeView:(UIView *)view
{
	[self localizeView:view recursive:YES];
}

@end
