//
//  UIImage-Expanded.h
//  yes
//
//

#import <Foundation/Foundation.h>


@interface UIImage (Expanded)


- (UIImage *)scaleImage:(CGSize)size;
- (UIImage *)imageCroppedToRect:(CGRect)cropRect;


@end