//
//  UIView+SCUtilities.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIView+SCUtilities.h"

@implementation UIView (SCUtilities)

- (void)SC_makeCircular {
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0f;
    self.clipsToBounds = YES;
}

@end
