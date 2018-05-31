//
//  VSUtils.m
//
//  Created by Alexei Rudak on 18/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VSUtils.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "Reachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

#define DEFAULT_VOID_COLOR [UIColor whiteColor];

@implementation VSUtils

+ (NSString*) getImageNameJPG:(NSString*)file
{
    NSString *namePart = file;
    NSString *suffix = @"";
    if([VSUtils isIPad])
        suffix = @"_ipad";
    
    NSString *res = [NSString stringWithFormat:@"%@%@.jpg",namePart,suffix];
    return res;
}

+ (NSString*) getImageNamePNG:(NSString*)file
{
    NSString *namePart = file;
    NSString *suffix = @"";
    if([VSUtils isIPad])
        suffix = @"_ipad";
    
    NSString *res = [NSString stringWithFormat:@"%@%@.png",namePart,suffix];
    return res;
}

+(NSString*) getLocalLanguage
{
    NSLocale *locale = [NSLocale currentLocale];
	
	NSString *language;
	if ([[NSLocale preferredLanguages] count] > 0)
	{
		language = [[NSLocale preferredLanguages] objectAtIndex:0];
	}
	else
	{
		language = [locale objectForKey:NSLocaleLanguageCode];
	}
    
    return language;
}

+ (BOOL) isPortraitOrientation
{
    return (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]));
}

+ (void)runBlock:(void (^)())block
{
    block();
}
+ (void)runAfterDelay:(CGFloat)delay block:(void (^)())block
{
    void (^block_)() = [block copy];
    [self performSelector:@selector(runBlock:) withObject:block_ afterDelay:delay];
    [block release];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



+ (BOOL) isGameCenterAvailable
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}

+ (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+(NSString*) formatScores:(NSInteger) scores useComma:(BOOL) useComma
{
	NSString *s_scores = [NSString stringWithFormat:@"%i",scores];
	
	if ([s_scores length] > 3) {
		
		NSString *str1 = [s_scores substringToIndex:[s_scores length]-3];
		NSString *str2 = [s_scores substringFromIndex:[s_scores length]-3];
		
        
		NSString *commar = @",";
        
        if(!useComma)
            commar = @"";
		
		if([s_scores length] == 4 && scores <0)
			commar = @"";
		
		s_scores = [NSString stringWithFormat:@"%@%@%@", str1, commar, str2];
	}
	
	return s_scores;
}

+(NSString*) formatScores:(NSInteger) scores
{
	NSString *s_scores = [NSString stringWithFormat:@"%i",scores];
	
	if ([s_scores length] > 3) {
		
		NSString *str1 = [s_scores substringToIndex:[s_scores length]-3];
		NSString *str2 = [s_scores substringFromIndex:[s_scores length]-3];
		
		NSString *commar = @",";
		
		if([s_scores length] == 4 && scores <0)
			commar = @"";
		
		s_scores = [NSString stringWithFormat:@"%@%@%@", str1, commar, str2];
	}
	
	return s_scores;
}


+ (BOOL) isIPad {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}


+(BOOL) isIPhone5Screen
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        UIScreen *mainScreen = [UIScreen mainScreen];
        
        
        if (mainScreen.scale == 2.0f && mainScreen.bounds.size.height == 568)
            
        {
            return YES;
                
            
        }
    }
    return NO;
}

+ (BOOL) isJailBroken
{
	for (NSString *file in [NSArray arrayWithObjects:
							@"/Applications/Cydia.app",
							@"/Applications/limera1n.app",
							@"/Applications/greenpois0n.app",
							@"/Applications/blackra1n.app",
							@"/Applications/blacksn0w.app",
							@"/Applications/redsn0w.app",
							nil
							])
	{
		if ([[NSFileManager defaultManager] fileExistsAtPath:file])
		{
			return YES;
		}
	}
	return NO;
}

+ (BOOL) isSystemVersionGreaterThanOrEqualTo:(NSString *)version
{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: version
                                                                       options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
        return YES;
    else
        return NO;
}

+ (NSString *) platformString {
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

+ (BOOL) areEqual:(double) a b:(double)b
{
    return fabs(a - b) < 0.01;
}





+(NSString*) getXibNameForController:(NSString*) file
{
    NSString *nibName;
    
    if([VSUtils isIPad])
    {
        nibName = [NSString stringWithFormat:@"%@IPad",file];
    }
    else
    {
        if([VSUtils isIPhone5Screen])
            nibName = [NSString stringWithFormat:@"%@-IPhone5",file];
        else
            nibName = file;
    }
    
    return nibName;
}

+ (UIView *)loadViewFromNib:(NSString *)nibName forClass:(Class)forClass
{
	NSArray *topLevelObjects = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] retain];
	for(id currentObject in topLevelObjects)
	{
		if([currentObject isKindOfClass:forClass])
		{
			[currentObject retain];
			[topLevelObjects release];
			return [currentObject autorelease];
		}
	}
	return nil;
}

+(BOOL) isConnectedToInternet:(BOOL) showMessage{
	static Reachability *internetReach;
	
	if(!internetReach)
	{
		internetReach = [[Reachability reachabilityForInternetConnection] retain];
		[internetReach startNotifier];
	}
	
	switch ([internetReach currentReachabilityStatus]){
        case NotReachable:{
			if(showMessage)
				[VSUtils showMessage:@"Application is having trouble connecting to the server. Please check your internet connection"];
			return NO;
        }
        default:
            break;
    }
	
	return YES;
}

+(BOOL) isConnectedToInternetWithMessage:(NSString*) messageText{
	static Reachability *internetReach;
	
	if(!internetReach)
	{
		internetReach = [[Reachability reachabilityForInternetConnection] retain];
		[internetReach startNotifier];
	}
	
	switch ([internetReach currentReachabilityStatus]){
        case NotReachable:{
			[VSUtils showMessage:messageText];
			return NO;
        }
        default:
            break;

    }
	
	return YES;
}




+(NSString*) trimString:(NSString*) string
{
	return [string stringByTrimmingCharactersInSet:
									  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}




+ (void) showMessage:(NSString*)text
{
	UIAlertView* dialog = [[[UIAlertView alloc] init] autorelease];
	[dialog setTitle:@""];
	[dialog setMessage:text];
	[dialog addButtonWithTitle:@"OK"];
	
	[dialog show];
}
+(void) setTextFieldError:(UITextField*)textField isError:(BOOL)isError type:(NSInteger) type
{
	if(isError)
	{
		if(type == 1)
		{
			textField.placeholder = @"Please fill this field";
			//
			//[textField setText:@"Please fill this field"];
			
			[textField setValue:[UIColor redColor] 
							forKeyPath:@"_placeholderLabel.textColor"];
		}
		//[textField setTextColor:[UIColor redColor]];
	}
	else 
	{
		[textField setTextColor:[UIColor blackColor]];
	}
}

+ (NSString*) optimiseText:(NSString*) text
{
	if([text length] <= 15)
		return text;
	else {
		return [NSString stringWithFormat:@"%@...",[text substringToIndex:15]];
	}

}

+ (NSString*) getPassedTime:(NSDate *) created
{
	NSDate *now = [NSDate date];
	NSDate *old = created;
	
	double nowSec = [now timeIntervalSince1970];
	double oldSec = [old timeIntervalSince1970];
	
	NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
	int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:now] / 3600;
	
	
	NSInteger passed = nowSec - (oldSec + 3600*timeZoneOffset);
	
	NSString *type;
	
	if(passed < 3600)
	{
		passed = passed/60;
		if(passed == 1)
			type = @"minute";
		else
			type = @"minutes";
	}
	else if (passed < 3600*24)
	{
		passed = passed/3600;
		if(passed == 1)
			type = @"hour";
		else
			type = @"hours";
	}
	else if (passed < 3600*24*7)
	{
		passed = passed/(3600*24);
		if(passed == 1)
			type = @"day";
		else
			type = @"days";
	}
	else if (passed < 3600*24*30)
	{
		passed = passed/(84600*7);
		if(passed == 1)
			type = @"week";
		else
			type = @"weeks";
	}
	else if (passed/(3600*24*30*12) < 1)
	{
		passed = passed/(84600*30);
		if(passed == 1)
			type = @"month";
		else
			type = @"months";
	}
	else 
	{
		passed = passed/(84600*30*12);
		if(passed == 1)
			type = @"year";
		else
			type = @"years";
	}
	
	
	
	
	return [NSString stringWithFormat:@" %i %@ ago",passed,type];
}

+(double) getSystemVersion
{
	return [[UIDevice currentDevice].systemVersion doubleValue];
}

+ (BOOL)connectedToNetwork:(BOOL)includeDataNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network wifi reachability flags\n");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return ((isReachable && !needsConnection) || (includeDataNetwork && nonWiFi)) ? YES : NO;
}

+ (BOOL)connectedTo3GNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network wifi reachability flags\n");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return (isReachable && !needsConnection && nonWiFi);
}

+ (BOOL)isFileExists:(NSString *)filename
{
	return [[NSFileManager defaultManager] fileExistsAtPath:filename];
}

+ (BOOL)dialNumber:(NSString *)phoneNumber
{
	
    
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
	return [[UIApplication sharedApplication] openURL:url];
}



+ (void) moveViewVertical:(UIView*) view offset:(NSInteger) offset delay:(CGFloat) delay
{
    [self moveViewVertical:view offset:offset delay:delay block:nil];
}

+ (void) moveViewVertical:(UIView*) view offset:(NSInteger) offset delay:(CGFloat) delay block:(void (^)()) block
{
    
    [UIView animateWithDuration:delay delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         view.frame = CGRectMake(view.frame.origin.x, offset, view.frame.size.width, view.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             
                             if(block!=nil)
                                 block();
                                 
                         }
                         
                     }
     ];
    
   
}

+(CGRect) convertRect:(CGRect) rect{
	return CGRectMake(rect.origin.x - rect.size.width/2,
					  rect.origin.y - rect.size.height/2,rect.size.width, rect.size.height);
}



// Generatite random number
+(unsigned int) getRandomNumber:(NSInteger) maxValue{
	return arc4random()%maxValue;
}

// Generatite random number
+(unsigned int) getRandomNumber:(NSInteger) minValue :(NSInteger) maxValue {
	int a = arc4random()%maxValue;
	if(a>minValue)
		return a;
	else
		[self getRandomNumber:minValue :maxValue];
	
	return -1;
}


@end
