//
//  FinalScoreViewController.h
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidBitViewController.h"
#import "VSButton.h"

@interface TidbitFinalScoreViewController : TidBitViewController 
{
	UIImageView *imStrike1,*imStrike2,*imStrike3;
    
    UIImageView *imResult;
    UILabel *lbTopTitle;
    UILabel *lbResult;
    UILabel *lbScore;
    VSButton *btPlayAgain;
    VSButton *btMenu;
    UIButton *btPromo;
    UIButton *btRate;
}

@property (nonatomic, retain) IBOutlet UIImageView *imStrike1,*imStrike2,*imStrike3;

@property (nonatomic, retain) IBOutlet UIImageView *imResult;
@property (nonatomic, retain) IBOutlet UILabel *lbTopTitle;
@property (nonatomic, retain) IBOutlet UILabel *lbResult;
@property (nonatomic, retain) IBOutlet UILabel *lbScore;
@property (nonatomic, retain) IBOutlet VSButton *btPlayAgain;
@property (nonatomic, retain) IBOutlet VSButton *btMenu;
@property (nonatomic, retain) IBOutlet UIButton *btPromo;
@property (nonatomic, retain) IBOutlet UIButton *btRate;

-(IBAction) onPlayAgain;
-(IBAction) backToMenu;


@end
