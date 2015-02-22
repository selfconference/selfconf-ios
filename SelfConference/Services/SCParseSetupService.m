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

@implementation SCParseSetupService

+ (void)setupWithLaunchOptions:(NSDictionary*)launchOptions {
    [self setDefaultACLs];
    
    [Parse enableLocalDatastore];
    
    [self registerWithParse];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
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

@end
