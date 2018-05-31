//
//  OtherAppsViewController.m
//
//  Created by Alexei Rudak on 10/7/12.
//
//

#import "OtherAppsViewController.h"
#import "VSUtils.h"
#import "Localization.h"
#import "CrossPromotionManager.h"




@implementation OtherAppsViewController

@synthesize btMenu,crossPromotionView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *resizeFile = @"btn_resizable.png";
    if([VSUtils isIPad])
        resizeFile = @"btn_resizable_ipad.png";
    
    [btMenu setImageResizingByCentralPixelWithFile:resizeFile];
    
    
    [Localization localizeView:self.view];
}

-(void) crossPromotionItemsReceived
{
    [crossPromotionView updateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[[CrossPromotionManager sharedInstance] requestItemsWithLang:nil andId:4];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(crossPromotionItemsReceived)
                                                 name:@"crossPromotionItemsReceived" object:nil];
    
    [[CrossPromotionManager sharedInstance] requestItemsWithLang:nil loadDefault:YES andId:4];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

@end
