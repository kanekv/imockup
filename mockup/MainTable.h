//
//  MainTable.h
//  mockup
//
//  Created by Kane on 5/21/13.
//  Copyright (c) 2013 Sendgrid. All rights reserved.
//
#import <UIKit/UIFont.h>
#import <Foundation/Foundation.h>
#import <AFNetworking/AFJSONRequestOperation.h>

@interface MainTable : NSObject <UITableViewDelegate, UITableViewDataSource>
    @property(strong, atomic) UITableView *table;
    @property(strong, atomic) UIView *rootView;
    @property(strong, atomic) NSArray *data;
    @property(strong, atomic) UIActivityIndicatorView *activityIndicator;

    - (id)initWithTable:(UITableView *)table rootView:(UIView *)rootView;
@end
