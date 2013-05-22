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

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic, strong) IBOutlet UIScrollView *mainScroll;
    @property (nonatomic, strong) IBOutlet UIView *viewOptions;

    @property NSMutableArray *tableSources;
    @property (nonatomic, strong) MainScroll *scrollDelegate;

    -(IBAction) optionsButtonClicked:(id) sender;
@end
