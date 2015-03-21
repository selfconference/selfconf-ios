//
//  UIView+SCConstraints.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCConstraints)

/** Adds 'view' as a subview and fully constrains it to 'self' */
- (void)SC_addAndFullyConstrainSubview:(UIView *)view;

@end
