//
//  CustomButton.m
//
//  Created by Alexei Rudak on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LinkButton.h"


@implementation LinkButton

- (void)drawRect:(CGRect)rect 
{
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Measure the font size, so the line fits the text.
	// Could be that "titleLabel" is something else in other classes like UILable, dont know.
	// So make sure you fix it here if you are enhancing UILabel or something else..
	NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font};
    CGSize size = CGSizeMake(self.bounds.size.width, MAXFLOAT);
    CGSize fontSize = [self.titleLabel.text boundingRectWithSize:size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:attributes
                                                           context:nil].size;
    
	// Get the fonts color. 
	const float * colors = CGColorGetComponents(self.titleLabel.textColor.CGColor);
	// Sets the color to draw the line
	CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0f); // Format : RGBA
	
	// Line Width : make thinner or bigger if you want
	CGContextSetLineWidth(ctx, 1.0f);
	
	// Calculate the starting point (left) and target (right)	
	float fontLeft = self.titleLabel.center.x - fontSize.width/2.0;
	float fontRight = self.titleLabel.center.x + fontSize.width/2.0;
	
	// Add Move Command to point the draw cursor to the starting point
	CGContextMoveToPoint(ctx, fontLeft, self.bounds.size.height - 1);
	
	// Add Command to draw a Line
	CGContextAddLineToPoint(ctx, fontRight, self.bounds.size.height - 1);
	
	// Actually draw the line.
	CGContextStrokePath(ctx);
	
    
    
    
	// should be nothing, but who knows...
	[super drawRect:rect];
}

@end
