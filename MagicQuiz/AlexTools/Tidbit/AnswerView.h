//
//  AnswerView.h
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidbitView.h"
#import "Question.h"
#import "VSButton.h"

@interface AnswerView : TidbitView 
{
	IBOutlet UILabel *lbResult;
	IBOutlet UILabel *lbPublished;
    IBOutlet UILabel *lbExtraInfo;
	IBOutlet UILabel *lbCorrectAnswerTitle;
	IBOutlet UILabel *lbCorrectAnswer;
    IBOutlet UILabel *lbUnlockedTitle;
	IBOutlet VSButton *btNext,*btContinue,*btBuy;
}

@property (nonatomic, retain) UILabel *lbResult;

-(void) setGUIForQuestion:(Question*)question result:(BOOL)result;

@end
