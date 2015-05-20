//
//  UIAlertAction+SCAlertAction.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIAlertAction+SCAlertAction.h"

@implementation UIAlertAction (SCAlertAction)

+ (UIAlertAction *)SC_cancelAlertAction {
    return [self SC_cancelAlertActionWithTitle:@"Cancel" block:NULL];
}

+ (instancetype)SC_nonDestructiveAlertActionWithTitle:(NSString *)title
                                                block:(SCAlertControllerAlertActionBlock)block {
    return [UIAlertAction actionWithTitle:title
                                    style:UIAlertActionStyleDefault
                                  handler:block];
}

#pragma mark - Internal

+ (instancetype)SC_cancelAlertActionWithTitle:(NSString *)title
                                        block:(SCAlertControllerAlertActionBlock)block {
    return [UIAlertAction actionWithTitle:title
                                    style:UIAlertActionStyleCancel
                                  handler:block];
}

@end
