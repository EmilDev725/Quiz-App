//
// 
//
//  Created by Alexei Rudak on 25/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Chartboost/Chartboost.h>

#ifdef ADMOB_BANNER_ID 

#import <iAd/iAd.h>
#import "GADBannerView.h"

#endif


#import <StoreKit/StoreKit.h>


@interface BaseViewController : UIViewController <ChartboostDelegate, MBProgressHUDDelegate

#ifdef ADMOB_BANNER_ID 
,GADBannerViewDelegate
#endif
>
{
	UIAlertView *modalAlertView;
	MBProgressHUD *HUD;
    BOOL bannerIsVisible;
    //IBOutlet ADBannerView *adView;
    IBOutlet UILabel *lbCaption;
    
    NSString *captionText;
    
#ifdef ADMOB_BANNER_ID
    IBOutlet GADBannerView *bannerView_;
#endif    
    
    NSObject *object;
}

@property (nonatomic,assign) BOOL bannerIsVisible;
@property (nonatomic, retain) UILabel *lbCaption;
@property (nonatomic, retain) NSObject *object;
@property (nonatomic, retain) NSString *captionText;


-(void) hideLoadingMessage;
-(void) showLoadingMessage:(NSString*) msgText;

-(void) showLoadingHUD;
-(void) hideLoadingHUD;

-(IBAction) onBack;
-(IBAction) onHome;

-(BOOL) containsThisView:(UIView*)thisView;

-(void) pushControllerIPadWithName:(NSString*) name;
-(void) pushControllerWithName:(NSString*) name;
-(void) pushControllerWithName:(NSString*) name andSuffix:(NSString*) suffix;
-(void) pushControllerWithName:(NSString*) name andObject:(NSObject*)object;

-(void) alignComponents:(NSArray*) components offset:(NSInteger)offsetToCenter;






@end
