//
//  VSButton.h
//
//  Created by Alexei Rudak on 4/6/13.
//
//

#import <UIKit/UIKit.h>

@interface VSButton : UIButton
{
    BOOL fontSetuped;
}

@property (nonatomic, assign)BOOL fontSetuped;

- (void) setImageResizingByCentralPixelWithFile:(NSString*) name;

@end
