//
//  UIAlertController+SCAlertController.h
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertAction+SCAlertAction.h"

@class SCSponsor;
@class SCSpeaker;

@interface UIAlertController (SCAlertController)

/** 
 Returns a 'UIAlertController' to be used to open a sponsor's website in Safari.
 */
+ (instancetype)SC_alertControllerForOpenLinkForSponsor:(SCSponsor *)sponsor;

/**
 Returns a 'UIAlertController' to be used to open a speaker's Twitter. Tries
 to open it in the native Twitter app first (if installed), otherwise opens it
 in Safari.
 */
+ (instancetype)SC_alertControllerForOpenTwitterForSpeaker:(SCSpeaker *)speaker;

@end
