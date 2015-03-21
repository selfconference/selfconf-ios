//
//  UIViewController+SCChildViewController.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SCChildViewController)

/** 
 Adds a child view controller on top of 'view' and constrains 
 'childViewController.view' to 'view'.
 
 @param childViewController the view controller to add as a child view controller
 @param view either '_view' or a subview of '_view'
 */
- (void)SC_addChildViewController:(UIViewController *)childViewController
                      onTopOfView:(UIView *)view;

@end
