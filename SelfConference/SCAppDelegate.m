//
//  AppDelegate.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAppDelegate.h"
#import "SCParseSetupService.h"
#import "SCSession.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SCParseSetupService setupWithLaunchOptions:launchOptions];
    
    [SCSession fetchAllSessionsFromTheAPIWithBlock:^(NSArray *sessions, NSError *error) {
        
    }];
    
    return YES;
}

@end
