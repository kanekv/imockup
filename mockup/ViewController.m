//
//  ViewController.m
//  mockup
//
//  Created by Kane on 5/21/13.
//  Copyright (c) 2013 Sendgrid. All rights reserved.
//

#import "ViewController.h"
#import "MainTable.h"
#import "MainScroll.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.scrollDelegate = [[MainScroll alloc] init];
    self.mainScroll.delegate = self.scrollDelegate;
    self.tableSources = [[NSMutableArray alloc] init];
    self.viewOptions.hidden = YES;
    
    NSInteger numberOfViews = 3;
    NSArray *labels = [[NSArray alloc] initWithObjects:@"Albums",@"Photos",@"Tweets", nil];
    
    NSArray *colors = [[NSArray alloc] initWithObjects:[UIColor lightGrayColor], [UIColor grayColor], [UIColor darkGrayColor], nil];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width / 1.3 + 10 * i;
        UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width / 1.3, self.view.frame.size.height)];
        awesomeView.backgroundColor = colors[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
        label.text = labels[i];
        label.backgroundColor = [UIColor clearColor];
        [awesomeView addSubview:label];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width / 1.3, self.view.frame.size.height - 10 - 44) style:UITableViewStyleGrouped];

        [awesomeView addSubview:tableView];
        MainTable *table = [[MainTable alloc] initWithTable:tableView rootView:awesomeView];
        [self.tableSources addObject:table];
        tableView.dataSource = table;
        tableView.delegate = table;
        
        [self.mainScroll addSubview:awesomeView];
    }
    NSLog(@"Initial %f", self.view.frame.size.width);
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width / 1.3 * 3 + 20, self.mainScroll.frame.size.height - 10);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.viewOptions.hidden = YES;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        NSLog(@"Landscape");
        float height = self.view.frame.size.width - 10 - 44;
        float width = self.view.frame.size.width + 20;
        NSLog(@"width %f", width / 1.3 * 3 + 20);
        self.mainScroll.contentSize = CGSizeMake(width / 1.3 * 3 + 20, height);
        NSInteger subviewsCount = [self.tableSources count];
        while (subviewsCount--) {
            CGRect frame = ((MainTable *)self.tableSources[subviewsCount]).table.frame;
            frame.size.height = height;
            ((MainTable *)self.tableSources[subviewsCount]).table.frame = frame;
        }
    } else {
        NSLog(@"Portrait");
        float height = self.view.frame.size.height - 10 - 44;
        NSInteger subviewsCount = [self.tableSources count];
        while (subviewsCount--) {
            CGRect frame = ((MainTable *)self.tableSources[subviewsCount]).table.frame;
            frame.size.height = height;
            ((MainTable *)self.tableSources[subviewsCount]).table.frame = frame;
        }
        
    }
//    [((MainTable *)self.tableSources[0]).table reloadData];
}

-(IBAction) optionsButtonClicked:(id) sender
{
    CGRect destination = self.viewOptions.frame;
    if (destination.origin.x == 0) {
        destination.origin.x = -200;
    } else {
        destination.origin.x = 0;
    }
    if (self.viewOptions.hidden == YES) {
        destination.origin.x = 0;
        CGRect frame = self.viewOptions.frame;
        frame.origin.x = -200;
        self.viewOptions.frame = frame;
    }
    self.viewOptions.hidden = NO;

    [UIView animateWithDuration:0.25 animations:^{
        self.viewOptions.frame = destination;
    } completion:^(BOOL finished) {
        self.viewOptions.userInteractionEnabled = !(destination.origin.x > 0);
        if (destination.origin.x < 0) {
            self.viewOptions.hidden = YES;
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
