//
//  
//
//  Created by Alexei Rudak on 25/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView-Expanded.h"
#import "VSUtils.h"
#import "AlexStartApplication.h"
#import "ApplicationTools.h"
#import "VSButton.h"
#import "GlobalVariables.h"
#import "Localization.h"

extern UIFont *globalFont;
extern UIFont *globalFontIPad;
extern CGFloat fontSizeRatio;

@implementation BaseViewController

@synthesize bannerIsVisible,lbCaption,object;
@synthesize captionText;

- (void)dealloc
{
    [object release];
    
#ifdef ADMOB_BANNER_ID
    bannerView_.delegate = nil;
    [bannerView_ release];
#endif
    
    [super dealloc];
}





-(void) pushControllerIPadWithName:(NSString*) name
{
    UIViewController *infoViewController = [[NSClassFromString(name) alloc] initWithNibName:name bundle:[NSBundle mainBundle]];
    
	[self.navigationController pushViewController:infoViewController animated:YES];
	[infoViewController release];
}

-(void) pushControllerWithName:(NSString*) name
{
   NSString *nibName = [VSUtils getXibNameForController:name];
    
    UIViewController *infoViewController = [[NSClassFromString(name) alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];

	[self.navigationController pushViewController:infoViewController animated:YES];
	[infoViewController release];
}

-(void) pushControllerWithName:(NSString*) name andSuffix:(NSString*) suffix
{
    
    
    NSString *nibName;
    if([VSUtils isIPad])
        nibName =  [NSString stringWithFormat:@"%@IPad",name];
    else
    {
        if([VSUtils isIPhone5Screen])
            nibName = [NSString stringWithFormat:@"%@-IPhone5",name];
        else
            nibName = name;
    }
    
    nibName = [NSString stringWithFormat:@"%@-%@",nibName,suffix];
	
    UIViewController *infoViewController = [[NSClassFromString(name) alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
	[self.navigationController pushViewController:infoViewController animated:YES];
	[infoViewController release];
}

-(void) pushControllerWithName:(NSString*) name andObject:(NSObject*)_object
{
    NSString *nibName = [VSUtils isIPad] ? [NSString stringWithFormat:@"%@IPad",name]:name;
	
    BaseViewController *infoViewController = [[NSClassFromString(name) alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]];
    
    infoViewController.object = _object;
    
	[self.navigationController pushViewController:infoViewController animated:YES];
	[infoViewController release];
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

- (void)hudWasHidden
{
    
}

-(BOOL) containsThisView:(UIView*)thisView
{
    for(UIView *v in self.view.subviews)
    {
        if(v == thisView)
        {
            return  YES;
        }
    }
    
    return NO;
}

-(void) alignComponents:(NSArray*) components offset:(NSInteger)offsetToCenter
{
    if([VSUtils isIPhone5Screen])
    {
        void (^centerGUIForIPhone5Screen)(UIView *,CGFloat) = ^(UIView* component,CGFloat offset) {
            
            [component setFrame:CGRectMake(component.frame.origin.x,component.frame.origin.y + offset,component.frame.size.width,component.frame.size.height)];
        };
        
        for(UIView *component in components)
            centerGUIForIPhone5Screen(component,offsetToCenter);
    }
}

-(void) showLoadingHUD
{
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	if(HUD == nil)
	{
		HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		
		//HUD.graceTime = 0.5;
		//HUD.minShowTime = 5.0;
		
		// Add HUD to screen
		[self.navigationController.view addSubview:HUD];
		
		// Regisete for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
		
		// Show the HUD while the provided method executes in a new thread
		//[HUD showWhileExecuting:selector onTarget:self withObject:nil animated:YES];
		[HUD show:YES];
	}
	
}

-(void) showLoadingMessage:(NSString*) msgText
{
	UIActivityIndicatorView* indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
										   UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	
	indicator.center = CGPointMake(142, 70 );
	
	if(!modalAlertView)
	{
		modalAlertView = [[UIAlertView alloc] initWithTitle:msgText
													message:nil
												   delegate:self
										  cancelButtonTitle:nil 
										  otherButtonTitles:nil];
	}
	
	
	[modalAlertView addSubview:indicator];
	[modalAlertView show];
	
	[indicator startAnimating];
	
}

-(void) hideLoadingMessage
{
	if(modalAlertView)
	{
		[modalAlertView dismissWithClickedButtonIndex:0 animated:NO];
		[modalAlertView release];
		modalAlertView  = nil;
	}
}

- (void)didCloseInterstitial:(NSString *)location
{
    
}






-(IBAction) onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) onHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) showChartboostAds
{
#ifdef ChartsBoostsAppID
    [Chartboost startWithAppId:ChartsBoostsAppID
                  appSignature:ChartBoostsAppSignature
                      delegate:self];
    
    // Show an interstitial
    //[cb showInterstitial];
    //[cb showInterstitial:]
    //[cb showMoreApps];
    
#endif
}


#ifdef ADMOB_BANNER_ID

- (void)adView:(GADBannerView *)view 
            didFailToReceiveAdWithError:(GADRequestError *)error
{
    
    
    
}

-(void)bannerView:(ADBannerView*)banner didFailToReceiveAdWithError:(NSError*)error
{
    
}

-(void) showBannerAdvertismentAtPoint:(CGPoint)coord
{

    // Create a view of the standard size at the top of the screen.
    
    if([bannerView_ superview])
        [bannerView_ removeFromSuperview];
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:coord];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = ADMOB_BANNER_ID;
    bannerView_.delegate = self;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    GADRequest *request = [GADRequest request];
    //request.testing = YES;
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:request];

}



#endif

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [[ApplicationTools sharedInstance] itemAppear:self];
    
}



- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        
        
        if([subview isKindOfClass:[VSButton class]])
        {
            VSButton *but = (VSButton*)subview;
            NSString *resizeFile = @"croco_btn.png";
            if([VSUtils isIPad])
                resizeFile = @"btn_resizable_ipad.png";
            
            [but setImageResizingByCentralPixelWithFile:resizeFile];
        }
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    
    if (globalFont)
    {
        if([VSUtils isIPad])
            [self.view changeViewFont:globalFontIPad fontRatio:fontSizeRatio];
        else
            [self.view changeViewFont:globalFont fontRatio:fontSizeRatio];
    }
    
    [self listSubviewsOfView:self.view];
    //[Localization localizeView:self.view];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}







- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}





@end
