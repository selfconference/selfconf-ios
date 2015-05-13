//
//  Event.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCVenue;

@interface SCEvent : SCUpdatedAtCreatedAt

typedef void (^SCEventWithErrorBlock)(SCEvent *event, NSError *error);

@property (nonatomic) NSInteger eventID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *twitterHandle;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSString *ticketsUrlString;

/** The path to use with the Lanyrd service: http://lanyrd.com/ */
@property (nonatomic, retain) NSString *lanyrdPath;

/** Returns 'YES' if the event is the current running event. */
@property (nonatomic) BOOL isCurrent;

@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *speakers;
@property (nonatomic, retain) NSSet *sponsors;
@property (nonatomic, retain) NSSet *sponsorLevels;
@property (nonatomic, retain) NSSet *organizers;
@property (nonatomic, retain) SCVenue *venue;

#pragma mark - URL Strings

/** Returns a url string to GET all of the events */
+ (NSString *)getAllEventsUrlString;

/** Returns a url string to GET the current event's sessions */
- (NSString *)getSessionsUrlString;

/** Returns a url string to GET the current event's speakers */
- (NSString *)getSpeakersUrlString;

/** Returns a url string to GET the current event's sponsors */
- (NSString *)getSponsorsUrlString;

/** Returns a url string to GET the current event's sponsor levels */
- (NSString *)getSponserLevelsUrlString;

/** Returns a url string to GET the current event's organizers */
- (NSString *)getOrganizersUrlString;

#pragma mark - Typed API requests

/** 
 Fetches the current SCEvent from the API and returns it inside
 'completionBlock' 
 */
+ (void)getCurrentEventWithCompletionBlock:(SCEventWithErrorBlock)completionBlock;

/** 
 Fetches the event's 'SCSpeaker' entities from the API and returns them inside
 'completionBlock'
 */
- (void)getSpeakersWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

#pragma mark - Local fetchers

/** Returns the current 'SCEvent' instance. */
+ (SCEvent *)currentEvent;

@end
