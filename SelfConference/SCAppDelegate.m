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

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self styleNavigationBarGlobally];
    [self styleTabBarGlobally];
        
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    return YES;
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

@end
