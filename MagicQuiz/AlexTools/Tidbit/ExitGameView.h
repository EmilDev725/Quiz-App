//
//  ExitGameView.h
//
//  Created by Alexei Rudak on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TidbitView.h"
#import "VSButton.h"

@interface ExitGameView : TidbitView
{
    IBOutlet VSButton *btYES,*btNO;
}

- (void) resizeButtonsWithImage:(NSString*) name;

@end
