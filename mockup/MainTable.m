//
//  MainTable.m
//  mockup
//
//  Created by Kane on 5/21/13.
//  Copyright (c) 2013 Sendgrid. All rights reserved.
//

#import "MainTable.h"

@implementation MainTable

- (id)initWithTable:(UITableView *)table rootView:(UIView *)rootView
{
    self = [super init];
    self.data = nil;
    self.table = table;
    self.rootView = rootView;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = self.activityIndicator.frame;
    frame.origin.x = self.table.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.table.frame.size.height / 2 - frame.size.height / 2;
    self.activityIndicator.frame = frame;
    
    [self.activityIndicator startAnimating];
    [self.rootView addSubview:self.activityIndicator];
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/307023978966?fields=albums"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.activityIndicator stopAnimating];
        self.data = JSON[@"albums"][@"data"];
        [self.table reloadData];
    } failure:nil];
    
    [operation start];
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.data == nil) {
        return 0;
    }
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.textLabel.text = self.data[indexPath.row][@"name"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.data[indexPath.row][@"name"];
    CGSize constraint = CGSizeMake(100 - (5 * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
