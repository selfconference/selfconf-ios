//
//  UIAlertAction+SCAlertAction.h
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SCAlertControllerAlertActionBlock)(UIAlertAction *action);

@interface UIAlertAction (SCAlertAction)

/**
 Creates and returns a cancel 'UIAlertAction' with "Cancel" set as its title. 
 */
+ (UIAlertAction *)SC_cancelAlertAction;
/**
 Creates and returns a non destructive 'UIAlertAction' with 'title'" set as its
 title.
 */
+ (instancetype)SC_nonDestructiveAlertActionWithTitle:(NSString *)title
                                                block:(SCAlertControllerAlertActionBlock)block;

@end
