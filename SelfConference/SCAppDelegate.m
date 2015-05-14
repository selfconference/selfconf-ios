//
//  AppDelegate.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAppDelegate.h"
#import "UIColor+SCColor.h"
#import <MagicalRecord/MagicalRecord+Setup.h>
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import "SCEvent.h"
#import "SCVenue.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self styleNavigationBarGlobally];
    [self styleTabBarGlobally];
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [self fetchAllDataFromAPI];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self fetchAllDataFromAPI];
}

#pragma mark - Internal

/** Applies styles to all 'UITabBar' instances that are created */
- (void)styleTabBarGlobally {
    UITabBar *tabBar = [UITabBar appearance];
    
    tabBar.barTintColor = [UIColor SC_teal];
    tabBar.tintColor = [UIColor whiteColor];
}

/** Applies styles to all 'UINavigationBar' instances that are created */
- (void)styleNavigationBarGlobally {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.titleTextAttributes =
  @{NSForegroundColorAttributeName: navigationBar.tintColor};
}

/** Fetches each model from the API. */
- (void)fetchAllDataFromAPI {
    [SCVenue getVenuesWithCompletionBlock:NULL];
    
    [SCEvent getCurrentEventWithCompletionBlock:^(SCEvent *event, NSError *error) {
        [event getSpeakersWithCompletionBlock:NULL];
        [event getSessionsWithCompletionBlock:NULL];
        [event getSponsorsWithCompletionBlock:NULL];
        [event getSponsorLevelsWithCompletionBlock:NULL];
        [event getOrganizersWithCompletionBlock:NULL];
        [event.venue getRoomsWithCompletionBlock:NULL];
    }];
}

@end
