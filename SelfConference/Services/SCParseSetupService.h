//
//  SCParseSetupHelper.h
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCParseSetupService : NSObject

/** Initializes our connection with the Parse server */
+ (void)setupWithLaunchOptions:(NSDictionary*)launchOptions;

@end
