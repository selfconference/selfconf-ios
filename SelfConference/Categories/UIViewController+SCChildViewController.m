//
//  UIViewController+SCChildViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIViewController+SCChildViewController.h"
#import "UIView+SCConstraints.h"

@implementation UIViewController (SCChildViewController)

- (void)SC_addChildViewController:(UIViewController *)childViewController
                      onTopOfView:(UIView *)view {
    [self addChildViewController:childViewController];
    [view SC_addAndFullyConstrainSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

@end
