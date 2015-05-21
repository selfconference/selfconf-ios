//
//  UIView+MBProgressHUD.h
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgressHUD)

/** Shows a progress hud in self's bounds */
- (void)SC_showProgressHUD;

/**
 Shows a progress hud in self's bounds with the given title
 
 @param title - The title to display on the HUD
 */
- (void)SC_showProgressHUDWithTitle:(NSString *)title;

/** Hides the most recently shown progress hud */
- (void)SC_hideProgressHUD;

@end
