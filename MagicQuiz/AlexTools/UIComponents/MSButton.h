//
//  MSButton.h
//
//  Created by testbest on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLabel.h"

@interface MSButton : UIButton
{
    int _lineHeight;
    BOOL _anchorBottom;
    MSLabel *textlabel;
}

@property (nonatomic, assign) int lineHeight;
@property (nonatomic, assign) BOOL anchorBottom;
@property (nonatomic, retain) MSLabel *textlabel;

- (void)setLineHeight:(int)lineHeight;


@end
