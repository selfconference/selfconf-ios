//
//  UIView+MBProgressHUD.m
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (MBProgressHUD)

- (void)SC_showProgressHUD {
    [self SC_showProgressHUDWithTitle:nil];
}

- (void)SC_hideProgressHUD {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)SC_showProgressHUDWithTitle:(NSString *)title {
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self];
    progressHUD.detailsLabelText = title;
    [progressHUD show:YES];
    [self addSubview:progressHUD];
}

@end
