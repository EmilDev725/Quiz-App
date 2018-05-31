//
//  OtherAppsViewController.h
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import <UIKit/UIKit.h>
#import "CrossPromotionView.h"
#import "BaseViewController.h"
#import "VSButton.h"

@interface OtherAppsViewController : BaseViewController
{
    CrossPromotionView *crossPromotionView;
    VSButton *btMenu;
}

@property (nonatomic, retain) IBOutlet VSButton *btMenu;
@property (nonatomic, retain) IBOutlet CrossPromotionView *crossPromotionView;


@end
