//
//  UITextView+Size.m
//
//  Created by Alexei Rudak on 5/4/13.
//
//

#import "UITextView+Size.h"



#define kMaxFieldHeight 1000

@implementation UITextView (Size)

-(BOOL)sizeFontToFitMinSize:(float)aMinFontSize maxSize:(float)aMaxFontSize {
    
    float fudgeFactor = 16.0;
    float fontSize = aMaxFontSize;
    
    self.font = [self.font fontWithSize:fontSize];
    
    CGSize tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    CGSize stringSize = [self.text boundingRectWithSize:tallerSize
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
    while (stringSize.height >= self.frame.size.height) {
        
        if (fontSize <= aMinFontSize) // it just won't fit, ever
            return NO;
        
        fontSize -= 1.0;
        self.font = [self.font fontWithSize:fontSize];
        tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
        stringSize = [self.text boundingRectWithSize:tallerSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil].size;
    }
    
    return YES; 
}

@end
