//
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrossPromotionItem.h"
#import "MSLabel.h"
#import "EGOImageView.h"

@interface CrossPromotionTableViewCell : UITableViewCell
{
	IBOutlet EGOImageView    *imageView;
    IBOutlet UILabel         *lbName;
    IBOutlet MSLabel         *lbDescription;
    
    CrossPromotionItem       *item;
}

@property (nonatomic, retain) UILabel         *lbName;
@property (nonatomic, retain) MSLabel         *lbDescription;
@property (nonatomic, retain) EGOImageView     *imPicture;
@property (nonatomic, retain) CrossPromotionItem       *item;

-(void) setData:(CrossPromotionItem*) item;

@end
