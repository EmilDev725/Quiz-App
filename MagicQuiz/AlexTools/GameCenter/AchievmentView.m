//
//  AchievmentView.m
//
//  Created by testbest on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievmentView.h"
#import "ApplicationTools.h"
#import <QuartzCore/QuartzCore.h>
#import "VSUtils.h"
#import "Localization.h"

@implementation AchievmentView

@synthesize imAchievment,delegate,achievment,lbBadge,btNoThanks;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [imAchievment release];
    [achievment release];
    [lbBadge release];
    [btNoThanks release];
    [super dealloc];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    //UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(IBAction) postToFacebook
{
    
#ifdef SHK_ENABLED
    [[ApplicationTools sharedInstance] eventHappened:@"AchievmentView: postToFacebook" label:nil value:0];
    
    NSString *postString = [NSString stringWithFormat:Loc(@"_Loc_You_Won_Badge"),achievment.name];
    
    UIImage *image = [self imageWithImage:imAchievment.image scaledToSize:CGSizeMake(128,128)];
    [SHKFacebook shareImage:image title:postString];
    
    
    //[sharingImage release];
    
    if(delegate)
        [delegate viewFinished];
    
    [self removeFromSuperview];

#endif
    
}

-(IBAction) postToTwitter
{
#ifdef SHK_ENABLED
    [[ApplicationTools sharedInstance] eventHappened:@"AchievmentView : postToTwitter" label:nil value:0];
    
    NSString *postString = [NSString stringWithFormat:Loc(@"_Loc_You_Won_Badge"),achievment.name];


    UIImage *image = [self imageWithImage:imAchievment.image scaledToSize:CGSizeMake(128,128)];
    [SHKTwitter shareImage:image title:postString];

    
    
    [self removeFromSuperview];
    
    if(delegate)
        [delegate viewFinished];
    
#endif
    
}

-(IBAction) noThanks
{
    [[ApplicationTools sharedInstance] eventHappened:@"AchievmentView : No thanks" label:nil value:0];
    
    [self removeFromSuperview];
    
    if(delegate)
        [delegate viewFinished];
}

-(void) setData:(Achievment*) _achievment
{
    
    NSString *resizeFile = @"btn_resizable.png";
    if([VSUtils isIPad])
        resizeFile = @"btn_resizable_ipad.png";
    
    [btNoThanks setImageResizingByCentralPixelWithFile:resizeFile];
    
    self.achievment = _achievment;
    if([achievment.imagePath length] > 0)
        [imAchievment setImage:[UIImage imageNamed:self.achievment.imagePath]];
    
    NSString *wonBadge =[NSString stringWithFormat:Loc(@"_Loc_You_Won_Badge_Share_Success"), self.achievment.name];
    
    [lbBadge setText:wonBadge];
    
    [[ApplicationTools sharedInstance] eventHappened:[NSString stringWithFormat:@"@AchievmentView: %@",wonBadge] label:nil value:0];
    
    
    if([VSUtils isIPad])
        imAchievment.layer.cornerRadius = 18;
    else
        imAchievment.layer.cornerRadius = 10;
    
     imAchievment.layer.masksToBounds = YES;
}


@end
