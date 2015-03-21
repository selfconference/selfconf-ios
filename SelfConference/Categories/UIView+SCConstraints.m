//
//  UIView+SCConstraints.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIView+SCConstraints.h"

@implementation UIView (SCConstraints)

- (void)SC_addAndFullyConstrainSubview:(UIView *)view {
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    
    NSArray *visualFormats = @[@"V:|[view]|",
                               @"H:|[view]|"];
    
    for (NSString *visualFormat in visualFormats) {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:visualFormat
                              options:0
                              metrics:nil
                              views:views]];
    }
}

@end
