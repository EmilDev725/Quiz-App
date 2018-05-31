//
//  VSButton.m
//
//  Created by Alexei Rudak on 4/6/13.
//
//

#import "VSButton.h"

@implementation VSButton

@synthesize fontSetuped;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aCoder
{
    if(self = [super initWithCoder:aCoder])
    {
        [self initGUI];
    }
    return self;
}

- (void) initGUI
{
    
    
    
    
}

- (void) setImageResizingByCentralPixelWithFile:(NSString*) name;
{
    UIImage *imageTemp = [UIImage imageNamed:name];
    if(imageTemp)
    {
        int a = imageTemp.size.width/2;
        int b = imageTemp.size.height/2;
        UIImage *image = [imageTemp stretchableImageWithLeftCapWidth:a topCapHeight:b];
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
