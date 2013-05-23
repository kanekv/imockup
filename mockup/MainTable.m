//
//  MainTable.m
//  mockup
//
//  Created by Kane on 5/21/13.
//  Copyright (c) 2013 Sendgrid. All rights reserved.
//

#import "MainTable.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainTable
{
    UIView *draggedView;
    NSIndexPath *indexPath;
    CGPoint startDragPoint;
    UITableViewCell *draggedEl;
}

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
        self.data = [NSMutableArray arrayWithArray:JSON[@"albums"][@"data"]];
        [self.table reloadData];
    } failure:nil];
    
    [operation start];
    
    // Drag recognition
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.table addGestureRecognizer:longPress];
    
    return self;
}

- (IBAction)longPress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // figure out which item in the table was selected
        indexPath = [(UITableView *)sender.view indexPathForRowAtPoint:[sender locationInView:sender.view]];
        if (!indexPath)
        {
            NSLog(@"No drag!");
            return;
        }
        ((UITableView *)sender.view).scrollEnabled = NO;
        
        draggedEl = [(UITableView *)sender.view cellForRowAtIndexPath:indexPath];
        
        UIGraphicsBeginImageContext(draggedEl.contentView.bounds.size);
        [draggedEl.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        draggedView = [[UIView alloc]initWithFrame:iv.frame];
        [draggedView addSubview:iv];
        [draggedView setBackgroundColor:[UIColor blueColor]];
        CGPoint p = [sender locationInView:self.rootView];
        p.x += (self.rootView).frame.origin.x;
        [draggedView setCenter:p];
        startDragPoint = p;
        
        [self.data removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        // now add the item to the view
        [self.rootView.superview addSubview:draggedView];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        // we dragged it, so let's update the coordinates of the dragged view
        UIView *splitView = self.rootView;
        CGPoint point = [sender locationInView:splitView];
//        CGPoint pointInWindowCoords = [self.rootView.superview convertPoint:point toView:nil];
//        NSLog(@"%f", pointInWindowCoords.x);
//        CGPoint offset = ((UIScrollView *)self.rootView.superview).contentOffset;
//        if (pointInWindowCoords.x > 280 && offset.x <= ((UIScrollView *)self.rootView.superview).contentSize.width - self.rootView.superview.frame.size.width) {
//            offset.x += 5;
//        } else if (pointInWindowCoords.x < 40 && offset.x >= 5) {
//            offset.x -= 5;
//        }
//        ((UIScrollView *)self.rootView.superview).contentOffset = offset;
        point.x += (self.rootView).frame.origin.x;
        draggedView.center = point;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            draggedView.center = startDragPoint;
        } completion:^(BOOL finished) {
            [draggedView removeFromSuperview];
            [self.data insertObject:[NSDictionary dictionaryWithObject:draggedEl.textLabel.text forKey:@"name"] atIndex:indexPath.row];
            [self.table insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
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

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

@end
