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
#import "UIColor+SCColor.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self styleTabBarGlobally];
    
    [SCParseSetupService setupWithLaunchOptions:launchOptions];
    
    [self fetchUpdatedSessionsFromTheAPI];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self fetchUpdatedSessionsFromTheAPI];
}

#pragma mark - Internal

/** Applies styles to all UITabBar instances that are created */
- (void)styleTabBarGlobally {
    [UITabBar appearance].barTintColor = [UIColor SC_teal];
    [UITabBar appearance].tintColor = [UIColor whiteColor];
}

/** 
 Fetches all of the 'SCSession' instances from the server. If called multiple 
 times, only recently updated instances are fetched. 
 */
- (void)fetchUpdatedSessionsFromTheAPI {
    [SCSession fetchAllSessionsFromTheAPIWithBlock:^(NSArray *sessions, NSError *error) {
        NSLog(@"Fetched %zd sessions from the API with error: %@",
              sessions.count,
              error.localizedDescription);
    }];
}

@end
