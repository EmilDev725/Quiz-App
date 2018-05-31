//
//  AchievmentView.h
//
//  Created by testbest on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef SHK_ENABLED

#import "SHKFacebook.h"
#import "SHKTwitter.h"

#endif


#import "Achievment.h"
#import "TidbitView.h"
#import "VSButton.h"

@protocol AchievmentViewDelegate
- (void) viewFinished;
@end

@interface AchievmentView : TidbitView <UIActionSheetDelegate>
{
    UIImageView *imAchievment;
    UILabel *lbBadge;
    UIActionSheet *quantitySheet;
    id<AchievmentViewDelegate>delegate;
    Achievment *achievment;
    VSButton *btNoThanks;
    
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imAchievment;
@property (nonatomic, retain) IBOutlet UILabel *lbBadge;
@property (nonatomic, assign) id<AchievmentViewDelegate>delegate;
@property (nonatomic, retain) Achievment *achievment;
@property (nonatomic, retain) IBOutlet VSButton *btNoThanks;

-(void) setData:(Achievment*) achievment;



@end
