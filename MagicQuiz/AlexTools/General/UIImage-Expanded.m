//
//  UIImage-Expanded.m
//  yes
//
//

#import "UIImage-Expanded.h"


@implementation UIImage (Expanded)


- (UIImage *)scaleImage:(CGSize)size
{    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > size.width || height > size.height)
	{
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = size.height;
            bounds.size.height = round(bounds.size.width / ratio);
        } else {
            bounds.size.height = size.width;
            bounds.size.width = round(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
	
    UInt8 *pixelData = (UInt8 *) malloc(bounds.size.width * bounds.size.height * 4);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 bounds.size.width,
                                                 bounds.size.height, 8,
                                                 bounds.size.width * 4,
                                                 colorspace,
                                                 kCGImageAlphaNoneSkipLast);
    
    CGContextScaleCTM(context, scaleRatio, scaleRatio);
    //CGContextTranslateCTM(context, 0, -height);
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
	
    CGContextRelease(context);
    CGColorSpaceRelease(colorspace);
    free(pixelData);
    
    UIImage *imageCopy = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef); // TODO was commented but leaked
    [imageCopy autorelease];
    
    return imageCopy;
}


- (UIImage *)imageCroppedToRect:(CGRect)cropRect 
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

@end