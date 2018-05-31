//
//  CrossPormotionView.m
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import "CrossPromotionView.h"
#import "VSUtils.h"
#import "CrossPromotionManager.h"
#import "CrossPromotionTableViewCell.h"
#import "ApplicationTools.h"

#define kLoadedSubview_tag 1000
#define kDigitalNumbers_tag 1001

@implementation CrossPromotionView

@synthesize tableView,position,portraitOrientation;

-(id) initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder])
    {
        [self initGUI];
    }
    return self;
}

- (void) initGUI
{
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CrossPromotionView" owner:nil options:nil];
    for(id currentObject in topLevelObjects)
	{
		if([currentObject tag] == kLoadedSubview_tag && [currentObject isKindOfClass:[UIView class]])
		{
            
            [currentObject setFrame:self.bounds];
            
            UIView *loadedView = [currentObject retain];
            
            [self addSubview:currentObject];
            
            
            for (UIView *obj in loadedView.subviews)
            {
                if ([obj isKindOfClass:[UITableView class]] && obj.tag == kDigitalNumbers_tag)
                {
                    self.tableView = (UITableView *)[obj retain];
                    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
                    self.tableView.dataSource = self;
                    self.tableView.delegate = self;
                    [self.tableView reloadData];
                    
                }
                
            }
		}
	}
    
    
}


-(void) updateData
{
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [VSUtils isIPad]?140:70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int a = (int)[[CrossPromotionManager sharedInstance] itemCount];
	return a;
    
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *CellIdentifier = @"CrossPromotionTableViewCell";
    
    
    if([VSUtils isIPad])
        CellIdentifier = [NSString stringWithFormat:@"%@IPad",CellIdentifier];
    
    CrossPromotionTableViewCell *cell = (CrossPromotionTableViewCell *)[_tableView
                                                            dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = (CrossPromotionTableViewCell *)[VSUtils loadViewFromNib:CellIdentifier forClass:[CrossPromotionTableViewCell class]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CrossPromotionItem *item = [[CrossPromotionManager sharedInstance].items objectAtIndex:indexPath.row];
    [cell setData:item];
    
    return cell;
    
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    CrossPromotionItem *item = [[CrossPromotionManager sharedInstance].items objectAtIndex:indexPath.row];
    
    [[ApplicationTools sharedInstance] eventHappened:[NSString stringWithFormat:@"CrossPromotion: Item %@ was cliked",item.name] label:nil value:0];
    
    
    if(item.appstoreUrl)
    {
       
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.appstoreUrl]];
    }
}



@end
