//
//  UIView.m
//
//  Created by testbest on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView-Expanded.h"
#import "VSButton.h"

@implementation UIView (Expanded)

-(void)changeViewFont:(UIFont*) font fontRatio:(CGFloat)fontRatio
{
    
    for (UIView *subview in self.subviews)
    {
        
        if([subview isKindOfClass:[UILabel class]])
        {
            UILabel *tempLabel = (UILabel*)subview;
            
            if(tempLabel.tag!= -1)
            {
                CGFloat newFontSizeRatio = tempLabel.font.pointSize*fontRatio;
                
                [tempLabel setFont: [UIFont fontWithName:font.fontName size: newFontSizeRatio]];
            }
            else
            {
                
            }
        }
        else if([subview isKindOfClass:[UIButton class]])
        {
            
            UIButton *tempButton = (UIButton*)subview;
            
            if(tempButton.tag!= -1)
            {
                
                CGFloat newFontSizeRatio = tempButton.titleLabel.font.pointSize*fontRatio;
                [tempButton.titleLabel setFont:[UIFont fontWithName:font.fontName size: newFontSizeRatio]];
                
            }
            else
            {
                
            }
        }
        else if([subview isKindOfClass:[UIView class]])
        {
            [subview changeViewFont:font fontRatio:fontRatio];
        }
    }
}

-(void)changeViewFont:(UIView*)view font:(UIFont*) font fontRatio:(CGFloat)fontRatio
{
   
    for (UIView *subview in view.subviews)
    {
       
        if([subview isKindOfClass:[UILabel class]])
        {
            UILabel *tempLabel = (UILabel*)subview;
            if(tempLabel.tag!=-1)
            {
                CGFloat newFontSizeRatio = tempLabel.font.pointSize*fontRatio;
                
                [tempLabel setFont: [UIFont fontWithName:font.fontName size: newFontSizeRatio]];
            
                [subview changeViewFont:font fontRatio:fontRatio];
            }
        }
        
        if([subview isKindOfClass:[UIButton class]])
        {
            
            UIButton *tempButton = (UIButton*)subview;
            if(tempButton.tag!=-1)
            {
                CGFloat newFontSizeRatio = tempButton.titleLabel.font.pointSize*fontRatio;
                
                [tempButton.titleLabel setFont:[UIFont fontWithName:font.fontName size: newFontSizeRatio]];
                
                [subview changeViewFont:font fontRatio:fontRatio];
            }
            
        }
        
        if([subview isKindOfClass:[UIView class]])
        {
            [subview changeViewFont:subview font:font fontRatio:fontRatio];
        }
    }
}


@end
