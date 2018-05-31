//
//  VSUtils.h
//
//  Created by Alexei Rudak on 18/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@interface VSUtils : NSObject {

}
+ (NSString*) getXibNameForController:(NSString*) file;
+ (NSString*) getImageNameJPG:(NSString*)file;
+ (NSString*) getImageNamePNG:(NSString*)file;
+ (BOOL) isPortraitOrientation;
+ (BOOL) isIPad;
+ (BOOL)  isIPhone5Screen;
+ (BOOL) isJailBroken;
+ (BOOL) isSystemVersionGreaterThanOrEqualTo:(NSString *)version;
+ (NSString *) platform;
+ (NSString *) platformString;
+ (BOOL) isGameCenterAvailable;
+ (void) showMessage:(NSString*)text;
+ (BOOL) isConnectedToInternet:(BOOL) showMessage;
+ (BOOL) isConnectedToInternetWithMessage:(NSString*) messageText;


+ (NSString*) getPassedTime:(NSDate *) created;
+ (void) setTextFieldError:(UITextField*)textField isError:(BOOL)isError type:(NSInteger) type;
+(double) getSystemVersion;
+ (NSString*) optimiseText:(NSString*) text;
+ (NSString*) trimString:(NSString*) string;
+(NSString*) formatScores:(NSInteger) scores;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIView *)loadViewFromNib:(NSString *)nibName forClass:(Class)forClass;
+ (BOOL) areEqual:(double) a b:(double)b;
+ (void) runAfterDelay:(CGFloat)delay block:(void (^)())block;
+ (BOOL)connectedToNetwork:(BOOL)includeDataNetwork;
+ (BOOL)connectedTo3GNetwork;
+ (BOOL)isFileExists:(NSString *)filename;
+ (BOOL)dialNumber:(NSString *)phoneNumber;
+ (NSString *)getLocalLanguage;
+(NSString*) formatScores:(NSInteger) scores useComma:(BOOL) useComma;




+ (void) moveViewVertical:(UIView*) view offset:(NSInteger) offset delay:(CGFloat) delay;
+ (void) moveViewVertical:(UIView*) view offset:(NSInteger) offset delay:(CGFloat) delay block:(void (^)()) block;

+ (CGRect) convertRect:(CGRect) rect;
+(unsigned int) getRandomNumber:(NSInteger) maxValue;
+(unsigned int) getRandomNumber:(NSInteger) minValue :(NSInteger) maxValue;

@end
