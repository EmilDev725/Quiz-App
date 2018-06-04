//
//  RootViewController.h
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidbitGame.h"
#import "TidBitViewController.h"
#import <GameKit/GameKit.h>

@interface TidbitRootViewController : TidBitViewController <GameCenterMainDelegate, GKGameCenterControllerDelegate>
{
	UIButton *btAchievments,*btScores,*btSound;
    UILabel *lbCopyright;
    
}

@property (nonatomic, retain) IBOutlet UIButton *btAchievments,*btScores,*btSound;
@property (nonatomic, retain) IBOutlet UILabel *lbCopyright;

-(void) showGameViewController;
-(IBAction) startGame;


- (BOOL) isGameCenterSuport;

-(IBAction) showInApps;

-(IBAction) showGameKitScores;
-(IBAction) showAchievments;
-(IBAction) showFacebook;
-(IBAction) showOtherGames;

-(IBAction) resetAchievments;


-(void) enableGUIForGC:(BOOL) enable;


@end
