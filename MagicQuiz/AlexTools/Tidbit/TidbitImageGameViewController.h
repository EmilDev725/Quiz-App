//
//  GameViewController.h
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidbitGameViewController.h"


@interface TidbitImageGameViewController : TidbitGameViewController 
{
	UIImageView *imQuestion;
}

@property (nonatomic, retain) IBOutlet UIImageView *imQuestion;



@end
