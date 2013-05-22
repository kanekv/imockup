//
//  MainScroll.m
//  mockup
//
//  Created by Kane on 5/22/13.
//  Copyright (c) 2013 Sendgrid. All rights reserved.
//

#import "MainScroll.h"

@implementation MainScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.03];
    if (scrollView.contentOffset.x < 0) {
        NSLog(@"offset %f", scrollView.contentOffset.x);
        NSLog(@"bouncing left");
        self.direction = 0;
    }else if (scrollView.contentOffset.x > (scrollView.contentSize.width - scrollView.frame.size.width)) {
        NSLog(@"bouncing right");
        self.direction = 1;
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"bouncing finished %i", self.direction);
    NSLog(@"max width %f", (scrollView.contentSize.width - scrollView.frame.size.width));    
    NSLog(@"offset %f", scrollView.contentOffset.x);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
