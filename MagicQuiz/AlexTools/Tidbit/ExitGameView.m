//
//  ExitGameView.m
//
//  Created by Alexei Rudak on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExitGameView.h"
#import "VSUtils.h"

@implementation ExitGameView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void) resizeButtonsWithImage:(NSString*) name
{
    NSString *resizeFile = name;
    if([VSUtils isIPad])
        resizeFile = [NSString stringWithFormat:@"%@_ipad.png",name];
    else
        resizeFile = [NSString stringWithFormat:@"%@.png",name];
    
    [btYES setImageResizingByCentralPixelWithFile:resizeFile];
    [btNO setImageResizingByCentralPixelWithFile:resizeFile];
}

- (void)dealloc {
    [super dealloc];
}


@end
