//
//  CrossPromotionItem.h
//
//  Created by Alexei Rudak on 10/9/12.
//
//

#import <Foundation/Foundation.h>

@interface CrossPromotionItem : NSObject
{
    NSString *identifier;
    NSString *name;
    NSString *description;
    NSString *imageUrl;
    NSString *imageFile;
    NSString *appstoreUrl;
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *imageFile;
@property (nonatomic, retain) NSString *appstoreUrl;

@end
