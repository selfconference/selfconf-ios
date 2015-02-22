//
//  SCSession.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSession.h"
#import <Parse/PFObject+Subclass.h>
#import <MTDates/NSDate+MTDates.h>
#import "NSError+SCError.h"

typedef void (^SCSessionFetchSingleSessionWithErrorBlock)(SCSession *session, NSError *error);

NSString * const kSCSessionNotificationNameForInstancesWereUpdatedFromTheServer =
@"kSCSessionNotificationNameForInstancesWereUpdatedFromTheServer";

@implementation SCSession

@dynamic name, details, scheduledAt, room, speakers;

#pragma mark - PFSubclassing

+ (NSString *)parseClassName {
    return @"Session";
}

+ (PFQuery *)query {
    PFQuery *query = [super query];
    
    // Always fetch the room and speakers, whether fetching locally or from
    // the API
    [query includeKey:NSStringFromSelector(@selector(room))];
    [query includeKey:NSStringFromSelector(@selector(speakers))];
    
    return query;
}

+ (void)getLocalSessionsWithStartOfDay:(NSDate *)startOfDay
                                 block:(SCSessionFetchSessionsWithErrorBlock)block {
    if (!startOfDay) {
        if (block) {
            block(nil, [NSError SC_errorWithDescription:@"Expected startOfDay to be non-nil"]);
        }
    }
    else {
        PFQuery *query = [self query];
        [query fromLocalDatastore];
        
        [query
         whereKey:NSStringFromSelector(@selector(scheduledAt))
         greaterThanOrEqualTo:startOfDay];
        
        NSDate *startOfNextDay = [startOfDay mt_dateDaysAfter:1];
        
        [query
         whereKey:NSStringFromSelector(@selector(scheduledAt))
         lessThanOrEqualTo:startOfNextDay];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (block) {
                block(objects, error);
            }
        }];
    }
}

+ (void)fetchAllSessionsFromTheAPIWithBlock:(SCSessionFetchSessionsWithErrorBlock)block {
    PFQuery *query = [self query];
    
    // Make sure we get them all (max value)
    query.limit = 1000;
    
    [self getLocalMostRecentlyUpdatedSessionWithBlock:^(SCSession *session, NSError *getRecentlyUpdatedSessionError) {
        if (getRecentlyUpdatedSessionError) {
            if (block) {
                block(nil, getRecentlyUpdatedSessionError);
            }
        }
        else {
            // If we have some local data, only fetch new data on the server.
            // Otherwise, grab all of the data from the server by not limiting the
            // query.
            if (session) {
                [query whereKey:NSStringFromSelector(@selector(updatedAt))
                    greaterThan:session.updatedAt];
            }
            
            // Hit the server
            [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *fetchObjectsOnServerError) {
                if (fetchObjectsOnServerError) {
                    if (block) {
                        block(nil, fetchObjectsOnServerError);
                    }
                }
                else {
                    // Store the results in the local database
                    [PFObject
                     pinAllInBackground:sessions
                     block:^(BOOL succeeded, NSError *pinSessionsError) {
                         if (pinSessionsError) {
                             if (block) {
                                 block(nil, pinSessionsError);
                             }
                         }
                         else {
                             if (block) {
                                 block(sessions, nil);
                                 
                                 [[NSNotificationCenter defaultCenter]
                                  postNotificationName:kSCSessionNotificationNameForInstancesWereUpdatedFromTheServer
                                  object:sessions];
                             }
                         }
                     }];
                }
            }];
            
        }
    }];
}

#pragma mark - Internal

/** 
 Searches through the local database and find the most recently updated 
 'SCSession' instance.
 */
+ (void)getLocalMostRecentlyUpdatedSessionWithBlock:(SCSessionFetchSingleSessionWithErrorBlock)block {
    PFQuery *query = [self query];
    
    [query fromLocalDatastore];
    
    [query orderByDescending:NSStringFromSelector(@selector(updatedAt))];
    
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (block) {
            block(objects.firstObject, error);
        }
    }];
}

@end
