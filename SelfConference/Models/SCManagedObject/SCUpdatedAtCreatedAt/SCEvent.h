//
//  Event.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"
#import "SCSession.h"

@class SCVenue;

@interface SCEvent : SCUpdatedAtCreatedAt

typedef void (^SCEventWithErrorBlock)(SCEvent *event, NSError *error);

@property (nonatomic) int32_t eventID;
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

@property (nonatomic, retain) NSSet *slots;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *speakers;
@property (nonatomic, retain) NSSet *sponsors;
@property (nonatomic, retain) NSSet *sponsorLevels;
@property (nonatomic, retain) NSSet *organizers;
@property (nonatomic, retain) NSSet *rooms;
@property (nonatomic, retain) SCVenue *venue;

#pragma mark - Typed API requests

/** 
 Fetches the current SCEvent from the API and returns it inside
 'completionBlock' 
 */
+ (void)getCurrentEventWithCompletionBlock:(SCEventWithErrorBlock)completionBlock;

- (void)getSlotsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches the event's 'SCSession' entities from the API and returns them inside
 'completionBlock'
 */
- (void)getSessionsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches the event's 'SCSpeaker' entities from the API and returns them inside
 'completionBlock'
 */
- (void)getSpeakersWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches the event's 'SCSponsor' entities from the API and returns them inside
 'completionBlock'
 */
- (void)getSponsorsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches the event's 'SCSponsorLevel' entities from the API and returns them 
 inside 'completionBlock'
 */
- (void)getSponsorLevelsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches the event's 'SCOrganizer' entities from the API and returns them inside
 'completionBlock'
 */
- (void)getOrganizersWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches the event's 'SCRoom' entities from the API and returns them inside
 'completionBlock'
 */
- (void)getRoomsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

#pragma mark - Local fetchers

/** Returns the current 'SCEvent' instance. */
+ (SCEvent *)currentEvent;

/** Returns the current 'SCEvent' instance in the given 'context'. */
+ (SCEvent *)currentEventInContext:(NSManagedObjectContext *)context;

/** Searches '_sessions' for the given 'searchTerm' and 'filter' combined. */
- (NSArray *)sessionsWithSearchTerm:(NSString *)searchTerm
                             filter:(SCSessionFilter)filter;

/**
 Returns '_sponsorLevels' that have at least 1 'sponsor' sorted based on 
 'order'. 
 */
- (NSArray *)sponsorLevelsWithSponsorsSortedByOrder;

@end
