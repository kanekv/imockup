//
//  ViewController.h
//  mockup
//
//  Created by Kane on 5/21/13.
//  Copyright (c) 2013 Sendgrid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIScrollView.h>
#import "MainTable.h"
#import "MainScroll.h"
#import "LeftMenuViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic, strong) IBOutlet UIScrollView *mainScroll;

    @property NSMutableArray *tableSources;
    @property (nonatomic, strong) MainScroll *scrollDelegate;

    -(IBAction) optionsButtonClicked:(id) sender;
    -(IBAction) topRightButtonClicked:(id) sender;
    -(IBAction) topLockButtonClicked:(id) sender;
@end
