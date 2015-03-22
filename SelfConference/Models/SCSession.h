//
//  SCSession.h
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Parse/PFObject.h>
#import <Parse/PFSubclassing.h>
#import <Parse/PFRelation.h>

typedef void (^SCSessionFetchSessionsWithErrorBlock)(NSArray *sessions, NSError *error);

/** Gets posted when 'SCSession' instances were updated from the server */
FOUNDATION_EXPORT NSString * const kSCSessionNotificationNameForInstancesWereUpdatedFromTheServer;

@class SCSpeaker, SCRoom;

@interface SCSession : PFObject <PFSubclassing>

/** The name of the session. */
@property (nonatomic) NSString *name;

/** The details of the session. */
@property (nonatomic) NSString *details;

/** The date when the session is scheduled to take place. */
@property (nonatomic) NSDate *scheduledAt;

/** The room in which the session is located. */
@property (nonatomic) SCRoom *room;

/** A relationship of many 'SCSpeaker' instances who own the session. */
@property (nonatomic) NSArray *speakers;

/** 
 Asynchronously fetches 'SCSession' instances that live on the device's 
 database.
 */
+ (void)getLocalSessionsWithBlock:(SCSessionFetchSessionsWithErrorBlock)block;

/** Fetches all of the recently updated 'SCSession' instances from the server. */
+ (void)fetchAllSessionsFromTheAPIWithBlock:(SCSessionFetchSessionsWithErrorBlock)block;

@end
