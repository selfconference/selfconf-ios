//
//  SCParseSetupHelper.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCParseSetupService.h"
#import <Parse/Parse.h>
#import "SCSession.h"
#import "SCSpeaker.h"
#import "SCRoom.h"
#import "NSUserDefaults+SCUserDefaults.h"

@implementation SCParseSetupService

+ (void)setupWithLaunchOptions:(NSDictionary*)launchOptions {
    [self setDefaultACLs];
    
    [Parse enableLocalDatastore];
    
    [self registerWithParse];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self fetchConfig];
}

#pragma mark - Internal

/** Sets the default ACLs for any objects we create */
+ (void)setDefaultACLs {
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

/** Registers the PFObject subclasses and connects to the Parse server */
+ (void)registerWithParse {
    // We have to register the subclasses before connecting to the database
    [self registerSubclasses];
    
    [Parse setApplicationId:@"C1upFohJTJOdRDe2N1pBlH8TwMyH1dIowS7O5AEd"
                  clientKey:@"gWoLzIi6nropn9Ctjg2mABXELgOeytNgySAQb3sb"];
}

/** Registers all of the PFObject subclasses with the server */
+ (void)registerSubclasses {
    [SCSession registerSubclass];
    [SCSpeaker registerSubclass];
    [SCRoom registerSubclass];
}

/** 
 Fetches the config at most once every 12 hours per app runtime. This is 
 accessible using '[PFConfig currentConfig]' throughout the app. 
 */
+ (void)fetchConfig {
    // Fetches the config at most once every 12 hours per app runtime
    const NSTimeInterval configRefreshInterval = 12.0 * 60.0 * 60.0;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *configLastFetchedAt = standardUserDefaults.SC_configLastFetchedAt;
    
    if (!configLastFetchedAt ||
        [configLastFetchedAt timeIntervalSinceNow] * -1.0 > configRefreshInterval) {
        // Intentionally running this synchronously so we can use the values
        // right away. According to the docs, this is a super lightweight call,
        // so this shouldn't be too big of a deal
        // https://parse.com/docs/ios_guide#config/iOS
        [PFConfig getConfig];
        
        [standardUserDefaults SC_setConfigLastFetchedAt:[NSDate date]];
    }
}

@end
