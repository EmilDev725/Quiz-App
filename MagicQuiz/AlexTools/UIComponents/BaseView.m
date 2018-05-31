//
//  BaseView.m
//
//  Created by Alexei Rudak on 10/10/12.
//
//

#import "BaseView.h"
#import "UIView-Expanded.h"
#import "AlexStartApplication.h"
#import "VSUtils.h"
#import "GlobalVariables.h"

extern UIFont *globalFont;
extern UIFont *globalFontIPad;
extern CGFloat fontSizeRatio;

@implementation BaseViewTouch

@synthesize touchLocation;

@end

@implementation BaseView

@synthesize useIPhone5Xib;

- (void)hudWasHidden
{
    
}

- (void)didAddSubview:(UIView *)subview
{
    
    if (globalFont)
    {
        if([VSUtils isIPad])
            [self changeViewFont:globalFontIPad fontRatio:fontSizeRatio];
        else
            [self changeViewFont:globalFont fontRatio:fontSizeRatio];
    }
}


-(void) showLoadingHUD
{
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	if(HUD == nil)
	{
		HUD = [[MBProgressHUD alloc] initWithView:self];
		
		//HUD.graceTime = 0.5;
		//HUD.minShowTime = 5.0;
		
		// Add HUD to screen
		[self addSubview:HUD];
		
		// Regisete for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
		
		// Show the HUD while the provided method executes in a new thread
		//[HUD showWhileExecuting:selector onTarget:self withObject:nil animated:YES];
		[HUD show:YES];
	}
	
}

-(void) hideLoadingHUD
{
	//	[HUD hide:YES];
	if(HUD!=nil)
	{
		[HUD removeFromSuperview];
		[HUD release];
		HUD = nil;
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
