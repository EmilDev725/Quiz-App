//
//  BaseView.h
//
//  Created by Alexei Rudak on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BaseViewTouch : NSObject
{
    CGPoint touchLocation;
}

@property (nonatomic, assign) CGPoint touchLocation;



@end

@interface BaseView : UIView <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    BOOL useIPhone5Xib;
    
}

@property (nonatomic, assign) BOOL useIPhone5Xib;

-(void) showLoadingHUD;
-(void) hideLoadingHUD;

@end
