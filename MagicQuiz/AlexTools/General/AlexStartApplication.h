//
//  AlexStartApplication.h
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKiOSFacebook.h"
#import "SHKVkontakte.h"



#ifdef REVMOB_ID
//#import <RevMobAds/RevMobAds.h>
#import <Revmob/Revmob.h>
#endif

#if defined GAME_CENTER
#import "Achievment.h"
#endif

#if defined (ChartsBoostsAppID)
#import <Chartboost/Chartboost.h>
#endif

#ifdef PLAYHAVAN_TOKEN
//#import "PlayHavenSDK.h"
#endif


#define ALEXSTART_MANAGING_TIMER_INTERVAL 30
#define ALEXSTART_NOTIFICATION_POPUP_SIMPLE_TAG 300
#define ALEXSTART_NOTIFICATION_POPUP_ACTION_TAG 301

typedef enum {
	MCTimer = 0,
    MCsoundRightAnswer,
	MCsoundWrongAnswer,
	MCsoundButtonClick,
	MCsoundPopup,
    MCsoundBeep1,
    MCsoundBeep2,
    MCBUZZ1,
    MCBUZZ2,
    MCBUZZ_OHNO,
    MCBUZZ_WOMAN_SCREAM
} MCsounds;

typedef enum {
	GC_MAIN = 0,
	GC_SCORES,
	GC_ACHIEVMENTS
} GC_LOAD_PLACE;

typedef enum {
	SHK_PT_WALL_PROMO = 1,
} SHK_POSTING_TYPE;

typedef enum {
	SHK_PT_WALL_SOCIAL_NETWORK_FB = 1,
    SHK_PT_WALL_SOCIAL_NETWORK_VK = 2,
    SHK_PT_WALL_SOCIAL_NETWORK_TW = 3
} SHK_PT_WALL_SOCIAL_NETWORK;

@protocol GameCenterMainDelegate <NSObject>
- (void) gotScores;
- (void) userWasLogged:(GC_LOAD_PLACE)gcLoadPlace;
- (void) gameCenterError:(GC_LOAD_PLACE)gcLoadPlace;
@end

@interface AlexStartApplication : NSObject <SHKSharerDelegate, ChartboostDelegate>
{
#ifdef PLAYHAVAN_TOKEN
//    PHNotificationView *_notificationView;
#endif
    
    NSString *mainLang;
    // Super ad
    NSData *superAdImageData;
    BOOL superAdRequestInProgress;
    
    // Remote Notification
    NSString *actionLinkForRemoteNotification;
    NSInteger remoteNotificationMessageIndex;
    BOOL remoteNotificationRequestInProgress;
    
    // DB Sync
    NSInteger databaseFileIndex;
    BOOL databaseSyncInProgress;
    
    NSTimer  *managingTimer;
    
    
    
    
    
    SHK_POSTING_TYPE shkPostingType;
    SHK_PT_WALL_SOCIAL_NETWORK shkPostingWallNetwork;
    
    SHKFacebook   *shkFacebook;
    SHKTwitter    *shkTwitter;
    SHKVkontakte  *shkVKontakte;
    
    BOOL wallPosted;
    BOOL reviewLeft;
    
    NSString *mainLanguage;
    
    // Music playing
    AVAudioPlayer *audioPlayer, *audioPlayer2;
    NSMutableArray *audioPlayers;
    BOOL soundEnable;
    
    NSString *appPrefix;

    
    NSString                *oldAppVersion;
    NSString				*appVersion;
    NSBundle                *defaultBundle;
    NSString                *appName,*appID;
    
#if defined GAME_CENTER
    // Game Center
    NSMutableArray *achievmentsAll;
	NSMutableArray *achievmentsGot;
	id<GameCenterMainDelegate> delegate;
	NSInteger globalPlayerScore;
    NSInteger score;
    
    GC_LOAD_PLACE gcLoadPlace;
	
	BOOL scoresReceived;
	BOOL achievmentsLoaded;
    BOOL sharingAchievmentEnabled;
    
    BOOL gcLoginWasCancelled;
    
    NSString *gcGlobalScoresTableID;
    NSString *gcLocalScoresTableID;
    NSString *itunesGCAppSuffix;
#endif    
    
    
#if defined (ChartsBoostsAppID)
    Chartboost *cb;
#endif
    
    
    UIFont *mainFont;
    UIFont *mainFontIPad;
    
    BOOL feedbackScreenWasShown;
    BOOL showGuide;
    BOOL paused;
    
    NSInteger screenShowCount;
}


// Super ad
@property (nonatomic, retain) NSData *superAdImageData;

// Remote Notification
@property (nonatomic, assign) NSInteger remoteNotificationMessageIndex;
@property (nonatomic, retain) NSString *actionLinkForRemoteNotification;

// DB Sync
@property (nonatomic, assign) NSInteger databaseFileIndex;
@property (nonatomic, assign) BOOL databaseSyncInProgress;



@property (nonatomic, assign) SHK_POSTING_TYPE shkPostingType;
@property (nonatomic, assign) SHK_PT_WALL_SOCIAL_NETWORK shkPostingWallNetwork;
@property (nonatomic, assign) BOOL wallPosted;
@property (nonatomic, assign) BOOL reviewLeft;


@property (nonatomic, retain) NSString *mainLanguage;
@property (nonatomic, retain) NSString *appPrefix;

@property (nonatomic, assign) BOOL showGuide;
@property (nonatomic, assign) BOOL paused;

// Music playing
@property (nonatomic, retain) AVAudioPlayer *audioPlayer2;
@property (nonatomic, retain) NSMutableArray *audioPlayers;
@property (nonatomic, assign) BOOL soundEnable;

@property (readonly) NSString   *appName;
@property (readonly) NSString   *appVersion;
@property (readonly) NSString   *appID;
@property (nonatomic, retain) NSDate     *lastActiveDate;
@property (nonatomic, assign) NSInteger  runCount;
@property (nonatomic, assign) NSInteger  appActiveCount;
@property (retain) NSBundle     *defaultBundle;




@property (nonatomic, retain) UIFont *mainFont;
@property (nonatomic, retain) UIFont *mainFontIPad;

@property (nonatomic, strong) UIViewController *currentViewController;



#if defined GAME_CENTER
// Game Center
@property (nonatomic, retain) NSMutableArray *achievmentsGot;
@property (nonatomic, retain) NSMutableArray *achievmentsAll;
@property (nonatomic, assign) NSInteger globalPlayerScore;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) id<GameCenterMainDelegate> delegate;
@property (nonatomic, assign) GC_LOAD_PLACE gcLoadPlace;
@property (nonatomic, assign) BOOL scoresReceived;
@property (nonatomic, assign) BOOL achievmentsLoaded;
@property (nonatomic, assign) BOOL sharingAchievmentEnabled;
@property (nonatomic, assign) BOOL gcLoginWasCancelled;
@property (nonatomic, retain) NSString *gcGlobalScoresTableID;
@property (nonatomic, retain) NSString *gcLocalScoresTableID;
@property (nonatomic, retain) NSString *itunesGCAppSuffix;
#endif

@property (nonatomic, assign) NSInteger screenShowCount;
@property (nonatomic, assign) BOOL feedbackScreenWasShown;

//+ (AlexStartApplication *) sharedInstance;

- (void) superAdRequest;
- (void) startRemoteNotificationRequest;
- (void) startManagingTimerWithLang:(NSString*) mainLangVal;

- (void) loadConfigurationData;
- (void) saveConfigurationData;
- (void) appStart;

#if defined GAME_CENTER
// Game Center
- (BOOL) isGameCenterSuport;
- (BOOL) isUserLogin;
- (void) reportValue:(NSString*)leaderboard value:(int64_t)value;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (NSString*) getImageForAchievment:(NSString*)identifier;
- (void) startGameKit:(GC_LOAD_PLACE)gcLoadPlaceVal;

- (void) checkForAchievments;
- (void) showFromImageName:(NSString*)name;
- (Achievment*) getAchievmentForIdentifier:(NSString*)identifier;
- (void) showShareAchievmentView:(NSString*) achievmentIdentifier;
- (void) closeView:(UIImageView*)imageV;
- (void) resetGameCenterProgress;
- (void) createAchievments;

- (void) reportGCLocalScore;
- (void) reportGCGlobalScore;
#endif

- (void) showChartboostAds;
- (void) showPlayhavenAds;
- (void) showChartboostAdsWithName:(NSString*) placeName;
- (void) initEnvironment;

- (void) postAppPromotionToFBWithText:(NSString*) text;
- (void) postAppPromotionToTwitterWithText:(NSString*) text;
- (void) postAppPromotionToVKontakteWithText:(NSString*) text;

- (void) loadJSONDatabaseWithRootNode:(NSDictionary*) rootNode;

- (void) setCurrentViewController:(UIViewController *)currentViewController;

@end
