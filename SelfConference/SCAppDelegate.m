//
//  AppDelegate.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAppDelegate.h"
#import "SelfConference-Swift.h"
#import <MagicalRecord/MagicalRecord+Setup.h>
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import "SCEvent.h"
#import "SCVenue.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self styleSearchBarGlobally];
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [self fetchAllDataFromAPI];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self fetchAllDataFromAPI];
}

#pragma mark - Internal

/** Applies styles to all 'UISearchBar' instances that are created */
- (void)styleSearchBarGlobally {
    UISearchBar *searchBar = [UISearchBar appearance];
    
    [searchBar setImage:[UIImage imageNamed:@"whiteSearchBarIcon"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    
    [searchBar setImage:[UIImage imageNamed:@"whiteCancelIcon"]
       forSearchBarIcon:UISearchBarIconClear
                  state:UIControlStateNormal];
    
    [searchBar setImage:[UIImage imageNamed:@"whiteCancelIconHighlighted"]
       forSearchBarIcon:UISearchBarIconClear
                  state:UIControlStateHighlighted];
    
    UIColor *whiteColor = [UIColor whiteColor];
    
    searchBar.tintColor = whiteColor;
    
    UITextField *textField =
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil];
    
    textField.textColor = whiteColor;
    
    textField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Search"
     attributes:@{NSForegroundColorAttributeName: whiteColor}];
}

/** Fetches each model from the API. */
- (void)fetchAllDataFromAPI {
    [SCVenue getVenuesWithCompletionBlock:^(NSArray *objects, NSError *error) {
        [SCEvent getCurrentEventWithCompletionBlock:^(SCEvent *event, NSError *error) {
            [event getOrganizersWithCompletionBlock:^(NSArray *objects, NSError *error) {
                [event getRoomsWithCompletionBlock:^(NSArray *objects, NSError *error) {
                    [event getSessionsWithCompletionBlock:^(NSArray *objects, NSError *error) {
                        [event getSpeakersWithCompletionBlock:^(NSArray *objects, NSError *error) {
                            [event getSponsorLevelsWithCompletionBlock:^(NSArray *objects, NSError *error) {
                                [event getSponsorsWithCompletionBlock:^(NSArray *objects, NSError *error) {
                                    NSLog(@"Completed network refresh");
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

@end
