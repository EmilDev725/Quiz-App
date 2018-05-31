//
//  ApplicationTools.h
//
//  Created by Alexei Rudak on 2/14/13.
//
//

#import <Foundation/Foundation.h>
#import "GAI.h"

@interface ApplicationTools : NSObject
{
    NSString *visibleItem;
    id<GAITracker> tracker;
}

@property (nonatomic, retain) NSString *visibleItem;
@property (nonatomic, assign) id<GAITracker> tracker;

+ (ApplicationTools *) sharedInstance;

-(void) startTools;

-(void) eventHappened:(NSString *)event label:(NSString *)label value:(NSInteger)value;
-(void) sysEventHappened:(NSString *)event label:(NSString *)label value:(NSInteger)value;

-(void) appTerminate;
-(void) appGoToBackgound;
-(void) appGoToForeground;

-(void) itemAppear:(id)item;
-(void) itemDisappear:(id)item;

@end
