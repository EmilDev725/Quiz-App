//
//  MSButton.m
//
//  Created by testbest on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSButton.h"
#import "VSUtils.h"


@implementation MSButton

@synthesize lineHeight=_lineHeight;
@synthesize anchorBottom=_anchorBottom;
@synthesize textlabel;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _lineHeight = 10;
        
        /*
        int xPos = 8;
        if([VSUtils isIPad])
            xPos = 16;*/
        
        textlabel = [[MSLabel alloc] init];
        
        
        textlabel.frame = self.bounds;
        
        
        textlabel.backgroundColor = [UIColor clearColor];
        textlabel.text = self.titleLabel.text;
        textlabel.textColor = [UIColor whiteColor];
        textlabel.text = @"aawdawd";
        textlabel.numberOfLines = 2;
        textlabel.font = self.titleLabel.font;
        textlabel.textAlignment = NSTextAlignmentCenter;
        [textlabel retain];
        
        [self addSubview:textlabel];
        [self bringSubviewToFront:textlabel];
    }    
    
    return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
	if (self != nil)
	{
		_lineHeight = 10;
        
        textlabel = [[MSLabel alloc] init];
        
        /*
        int xPos = 8;
        if([VSUtils isIPad])
            xPos = 16;*/
        
       
        
        textlabel.frame = self.bounds;
        textlabel.backgroundColor = [UIColor clearColor];
        textlabel.text = self.titleLabel.text;
        textlabel.textColor = [UIColor whiteColor];
        textlabel.text = @"aawdawd";
        textlabel.numberOfLines = 2;
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.font = self.titleLabel.font;
        
        
        [self addSubview:textlabel];
        [self bringSubviewToFront:textlabel];
    }
	return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    textlabel.text = title;
    //NSLog(@"%f,%f",self.frame.size.width,self.frame.size.height);
}



- (void)setLineHeight:(int)lineHeight {
    
    
    [textlabel setLineHeight:lineHeight];
    [self setNeedsDisplay];
    
    CGSize constraintExtra = CGSizeMake(440, 20000.0f);
    
    if(![VSUtils isIPad])
        constraintExtra = CGSizeMake(210, 20000.0f);
    
    NSDictionary *attributes = @{NSFontAttributeName: textlabel.font};
    CGSize sizeQuestion = [textlabel.text boundingRectWithSize: constraintExtra
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
    
    /*
    BOOL fix = NO;
    if([KenGame sharedInstance].currentQuiz.indexNumber == 10 
       && [KenGame sharedInstance].currentQuestionIndex == 4)
    {
        fix = YES;
    }*/
    
    
    if([VSUtils isIPad])
    {
        if(sizeQuestion.height <= 37)
            [textlabel setFrame:CGRectMake(textlabel.frame.origin.x, 26, textlabel.frame.size.width, 36)];
        else
            [textlabel setFrame:CGRectMake(textlabel.frame.origin.x, 10, textlabel.frame.size.width, 72)];
    }
    else 
    {
        if(sizeQuestion.height <= 21)
            [textlabel setFrame:CGRectMake(textlabel.frame.origin.x, 11, textlabel.frame.size.width, 20)];
        else
            [textlabel setFrame:CGRectMake(textlabel.frame.origin.x, 3, textlabel.frame.size.width, 40)];
    }
}

/*
#pragma mark - Properties

- (void)setLineHeight:(int)lineHeight {
    if (_lineHeight == lineHeight) { return; }
    _lineHeight = lineHeight;
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (NSArray *)stringsFromText:(NSString *)string {
    NSMutableArray *stringsArray = [[[string componentsSeparatedByString:@" "] mutableCopy] autorelease];
    NSMutableArray *slicedString = [NSMutableArray array];
    
    while (stringsArray.count != 0) {
        NSString *line = [NSString stringWithString:@""];
        NSMutableIndexSet *wordsToRemove = [NSMutableIndexSet indexSet];
        
        for (int i = 0; i < [stringsArray count]; i++) {
            NSString *word = [stringsArray objectAtIndex:i];
            
            if ([[line stringByAppendingFormat:@"%@ ", word] sizeWithFont:self.titleLabel.font].width <= self.titleLabel.frame.size.width) {
                line = [line stringByAppendingFormat:@"%@ ", word];
                [wordsToRemove addIndex:i];
            } else {
                if (line.length == 0) {
                    line = [line stringByAppendingFormat:@"%@ ", word];
                    [wordsToRemove addIndex:i];
                }
                break;
            }
        }
        [slicedString addObject:[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [stringsArray removeObjectsAtIndexes:wordsToRemove];
    }
    
    if (slicedString.count > self.titleLabel.numberOfLines && self.titleLabel.numberOfLines != 0) {
        NSString *line = [slicedString objectAtIndex:(self.titleLabel.numberOfLines - 1)];
        line = [line stringByReplacingCharactersInRange:NSMakeRange(line.length - 3, 3) withString:@"..."];
        [slicedString removeObjectAtIndex:(self.titleLabel.numberOfLines - 1)];
        [slicedString insertObject:line atIndex:(self.titleLabel.numberOfLines - 1)];
    }
    
    return slicedString;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSArray *slicedStrings = [self stringsFromText:self.titleLabel.text];
    [self.titleLabel.textColor set];
    
    for (int i = 0; i < slicedStrings.count; i++) {
        if (i + 1 > self.titleLabel.numberOfLines && self.titleLabel.numberOfLines != 0)
            break;
        
        NSString *line = [slicedStrings objectAtIndex:i];
        
        // calculate drawHeight based on anchor
        int drawHeight = _anchorBottom ? (self.titleLabel.frame.size.height - (slicedStrings.count - i) * _lineHeight) : i * _lineHeight;        
        
        // calculate drawWidth based on textAlignment
        int drawWidth = 0;
        if (self.titleLabel.textAlignment == UITextAlignmentCenter) {
            drawWidth = floorf((self.titleLabel.frame.size.width - [line sizeWithFont:self.titleLabel.font].width) / 2);
        } else if (self.titleLabel.textAlignment == UITextAlignmentRight) {
            drawWidth = (self.titleLabel.frame.size.width - [line sizeWithFont:self.titleLabel.font].width);
        }
        
        [line drawAtPoint:CGPointMake(drawWidth, drawHeight) forWidth:self.titleLabel.frame.size.width withFont:self.titleLabel.font fontSize:self.titleLabel.font.pointSize lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentNone];
    }
    
}*/

- (void)dealloc
{
    //[self removeObserver:self forKeyPath:@"highlighted"];
    [textlabel release];
    [super dealloc];
}


@end
