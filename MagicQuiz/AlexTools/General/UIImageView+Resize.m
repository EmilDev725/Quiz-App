//
//  UIImageView+Resize.m
//
//  Created by Alexei Rudak on 1/10/13.
//
//

#import "UIImageView+Resize.h"

@implementation UIImageView (Resize)

-(void) resizeByCentralPixel
{
    // BG Image Setup
    if(self.image)
    {
        UIImage *imageTemp = self.image;
        UIImage *image = [imageTemp stretchableImageWithLeftCapWidth:(imageTemp.size.width/2) topCapHeight:(imageTemp.size.height/2)];
        self.image = image;
    }
    else
    {
        
    }
    
}

@end
