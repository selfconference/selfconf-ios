//
//  UIAlertController+SCAlertController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIAlertController+SCAlertController.h"
#import "UIAlertAction+SCAlertAction.h"
#import "SCSponsor.h"
#import "SCSpeaker.h"

@implementation UIAlertController (SCAlertController)

+ (instancetype)SC_alertControllerForSessionFeedbackFailedToSendToAPI {
    return
    [self SC_alertControllerWithTitle:@"Feedback failed to send. Please try again."
                   confirmButtonTitle:nil
                         confirmBlock:NULL];
}

+ (instancetype)SC_alertControllerForOpenLinkForSponsor:(SCSponsor *)sponsor {
    return
    [self SC_alertControllerWithTitle:[NSString stringWithFormat:@"Open the %@ website in Safari?", sponsor.name]
                   confirmButtonTitle:@"Open"
                         confirmBlock:^(UIAlertAction *action) {
                             [[UIApplication sharedApplication]
                              openURL:[NSURL URLWithString:sponsor.link]];
                         }];
}

+ (instancetype)SC_alertControllerForOpenTwitterForSpeaker:(SCSpeaker *)speaker {
    return
    [self SC_alertControllerWithTitle:[NSString stringWithFormat:@"Open Twitter profile for %@?", speaker.name]
                   confirmButtonTitle:@"Open"
                         confirmBlock:^(UIAlertAction *action) {
                             UIApplication *sharedApplication =
                             [UIApplication sharedApplication];
                             
                             NSURL *nativeTwitterURL =
                             [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@",
                                                   speaker.twitterHandle]];
                             
                             // Try to open it in the Twitter app
                             if ([sharedApplication canOpenURL:nativeTwitterURL]) {
                                 [sharedApplication openURL:nativeTwitterURL];
                             }
                             // Otherwise, open it in Safari
                             else {
                                 NSURL *safariTwitterURL =
                                 [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",
                                                       speaker.twitterHandle]];
                                 
                                 [sharedApplication openURL:safariTwitterURL];
                             }
                         }];
}

#pragma mark - Internal

/**
 Creates a 'UIAlertController' and sets the given properties. All instances
 returned will contain a cancel button. Confirm buttons are optional. Set
 'confirmButtonTitle' to 'nil' to exclude a confirm button.
 
 @param title the title of the alert
 
 @param message the message of the alert
 
 @param confirmButtonTitle the title of the confirm button that gets added. Set 
 to 'nil' to hide.
 
 @param confirmBlock the block that gets called when the confirm button is
 tapped. If 'confirmButtonTitle' is 'nil', the block is never called.
 
 @param cancelBlock the block that gets called when the cancel button is
 tapped.
 
 @return a new 'UIAlertController' instance
 */
+ (instancetype)SC_alertControllerWithTitle:(NSString *)title
                         confirmButtonTitle:(NSString *)confirmButtonTitle
                               confirmBlock:(SCAlertControllerAlertActionBlock)confirmBlock {
    NSMutableArray *alertActions = [NSMutableArray array];
    
    // Setting 'confirmButtonTitle' to 'nil' should exclude/hide the confirm
    // button.
    if (confirmButtonTitle) {
        [alertActions addObject:[UIAlertAction
                                 SC_nonDestructiveAlertActionWithTitle:confirmButtonTitle
                                 block:confirmBlock]];
    }
    
    [alertActions addObject:[UIAlertAction SC_cancelAlertAction]];
    
    return [self SC_alertControllerWithTitle:title
                                alertActions:alertActions];
}

/**
 Creates a basic 'UIAlertController' instance with the given 'title' and
 'message' and adds each of the 'alertActions' as buttons.
 */
+ (instancetype)SC_alertControllerWithTitle:(NSString *)title
                               alertActions:(NSArray *)alertActions {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction *alertAction in alertActions) {
        [alertController addAction:alertAction];
    }
    
    return alertController;
}

@end
