//
//  ApplicationTools.m
//
//  Created by Alexei Rudak on 2/14/13.
//
//

#import "ApplicationTools.h"


@implementation ApplicationTools

static ApplicationTools *sharedInstance = nil;

@synthesize visibleItem;
@synthesize tracker;

+ (ApplicationTools *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init]; 
    }
    return sharedInstance;
}

- (void)dealloc
{
    [tracker release];
    [super dealloc];
}

-(void) startTools
{
#ifdef GANTrackerID
    
    /*
     int dispatchPeriod = 10;
     [[GANTracker sharedTracker] startTrackerWithAccountID:GANTrackerID
     dispatchPeriod:dispatchPeriod
     delegate:nil];*/
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:GANTrackerID];
    
#endif
}

-(void) itemAppear:(id)item
{
	self.visibleItem = (NSStringFromClass([item class]));
	//dbgLog(@"Item Appear:%@",visibleItem);
    
#ifdef GANTrackerID
    
    /*
	NSError *error = 0;
	if(![[GANTracker sharedTracker] trackPageview:[@"/" stringByAppendingString:visibleItem] withError:&error])
	{
		//dbgLog(@"GANError: %@", error);
	}*/
    
    [[GAI sharedInstance].defaultTracker sendView:visibleItem];
    
#endif
}

-(void) itemDisappear:(id)item
{
	//dbgLog(@"Item dissappear:%@",item);
	if([visibleItem isEqualToString:NSStringFromClass([item class])])
	{
        [visibleItem release];
        visibleItem = nil;
	}
}

- (void) eventHappened:(NSString *)event label:(NSString *)label value:(NSInteger)value
{
	
#ifdef GANTrackerID
    /*
	NSError *error = 0;
	if(![[GANTracker sharedTracker] trackEvent:visibleItem action:event label:label value:value withError:&error])
	{
		//dbgLog(@"GANError: %@", error);
	}*/
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:visibleItem
                                                    withAction:event
                                                     withLabel:label
                                                     withValue:value];
    
   
#endif
}

-(void) sysEventHappened:(NSString *)event label:(NSString *)label value:(NSInteger)value
{
	
#ifdef GANTrackerID
    
    /*
	NSString *name = @"SystemEvent";
	NSError *error = 0;
	if(![[GANTracker sharedTracker] trackEvent:name action:event label:label value:value withError:&error])
	{
		//dbgLog(@"GANError: %@", error);
	}*/
    
    [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"SystemEvent"
                                                    withAction:event
                                                     withLabel:label
                                                     withValue:value];
#endif
}

/*! Must be called once at application terminate */
-(void) appTerminate
{
    [self sysEventHappened:@"AppTerminate" label:@"" value:0];
}

/*! Must be called when application goes to background */
-(void) appGoToBackgound
{
    //[[DataSource source] saveData];
    [self sysEventHappened:@"AppBackground" label:@"" value:0];
}

/*! Must be called when application goes to foreground */
-(void) appGoToForeground
{
    [self sysEventHappened:@"AppForeground" label:@"" value:0];
}

@end
