//
//  CrossPormotionView.h
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import <UIKit/UIKit.h>

@interface CrossPromotionView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    CGPoint position;
    BOOL portraitOrientation;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) BOOL portraitOrientation;


- (void) updateData;


@end
