//
//
//  Created by Alexei Rudak on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CrossPromotionTableViewCell.h"
#import "AlexStartApplication.h"
#import "VSUtils.h"
#import "CrossPromotionManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation CrossPromotionTableViewCell

@synthesize lbName,lbDescription,imPicture,item;

-(void) setData:(CrossPromotionItem*) item_
{
    self.item = item_;
    
    if([VSUtils isIPad])
        [lbDescription setLineHeight:26];
    else
        [lbDescription setLineHeight:16];
    
    
    if([CrossPromotionManager sharedInstance].crossPromotionItemFont)
    {
        if([VSUtils isIPad])
            [lbName setFont:[CrossPromotionManager sharedInstance].crossPromotionItemFontIPad];
        else
            [lbName setFont:[CrossPromotionManager sharedInstance].crossPromotionItemFont];
    }
    
    if([CrossPromotionManager sharedInstance].crossPromotionItemDescriptionFont)
    {
        if([VSUtils isIPad])
            [lbDescription setFont:[CrossPromotionManager sharedInstance].crossPromotionItemDescriptionFontIPad];
        else
            [lbDescription setFont:[CrossPromotionManager sharedInstance].crossPromotionItemDescriptionFont];
    }
    

    
    [lbName setText:item.name];
    [lbDescription setText:item.description];
    
    
    if(item.imageUrl)
    {
        if([CrossPromotionManager sharedInstance].loadOnlyDefaultJSON)
        {
            [imPicture setImage:[UIImage imageNamed:item.imageFile]];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:item.imageUrl];
            [imPicture setImageURL:url];
        }
       
        
        if([VSUtils isIPad])
            imPicture.layer.cornerRadius = 18;
        else
            imPicture.layer.cornerRadius = 10;
        
        imPicture.layer.masksToBounds = YES;
    }
        
}



- (void)dealloc {
    [lbName release];
    [lbDescription release];
    [imPicture release];
    [item release];
    [super dealloc];
}


@end
