//
//  Event.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCEvent.h"
#import "SCAPIStrings.h"
#import "SCAPIService.h"
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import "SCSpeaker.h"
#import "SCSponsor.h"
#import "SCSponsorLevel.h"
#import "SCOrganizer.h"
#import <MTDates/NSDate+MTDates.h>
#import "NSString+SCHTMLTagConverter.h"
#import "NSString+SCFromDate.h"
#import "SCRoom.h"

@implementation SCEvent

@dynamic eventID;
@dynamic name;
@dynamic about;
@dynamic twitterHandle;
@dynamic startDate;
@dynamic endDate;
@dynamic ticketsUrlString;
@dynamic lanyrdPath;
@dynamic sessions;
@dynamic speakers;
@dynamic sponsors;
@dynamic sponsorLevels;
@dynamic organizers;
@dynamic rooms;
@dynamic venue;

#pragma mark - Typed API requests

+ (void)getCurrentEventWithCompletionBlock:(SCEventWithErrorBlock)completionBlock {
    [self
     getObjectsFromUrlString:[self getAllEventsUrlString]
     completionBlock:^(NSArray *objects, NSError *error) {         
         if (error) {
             [self callSCEventWithErrorBlock:completionBlock
                                       event:nil
                                       error:error];
         }
         else {
             [self callSCEventWithErrorBlock:completionBlock
                                       event:[self currentEvent]
                                       error:error];
         }
     }];
}

- (void)getSessionsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCSession getObjectsFromUrlString:self.getSessionsUrlString
                       completionBlock:completionBlock];
}

- (void)getSpeakersWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCSpeaker getObjectsFromUrlString:self.getSpeakersUrlString
                       completionBlock:completionBlock];
}

- (void)getSponsorsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCSponsor getObjectsFromUrlString:self.getSponsorsUrlString
                       completionBlock:completionBlock];
}

- (void)getSponsorLevelsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCSponsorLevel getObjectsFromUrlString:self.getSponsorLevelsUrlString
                            completionBlock:completionBlock];
}

- (void)getOrganizersWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCOrganizer getObjectsFromUrlString:self.getOrganizersUrlString
                         completionBlock:completionBlock];
}

- (void)getRoomsWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCRoom getObjectsFromUrlString:self.getRoomsUrlString
                    completionBlock:completionBlock];
}

#pragma mark - Local fetchers

+ (SCEvent *)currentEvent {
    return [self currentEventInContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (SCEvent *)currentEventInContext:(NSManagedObjectContext *)context {
    // Get the event with the highest 'eventID'
    SCEvent *currentEvent =
    [self MR_findFirstOrderedByAttribute:NSStringFromSelector(@selector(eventID))
                               ascending:NO
                               inContext:context];
    
    if (!currentEvent) {
        NSLog(@"There is no current SCEvent");
    }
    
    return currentEvent;
}

- (NSArray *)sessionsWithSearchTerm:(NSString *)searchTerm
                             filter:(SCSessionFilter)filter {
    NSPredicate *filterPredicate = [SCSession predicateForFilter:filter
                                                         context:self.managedObjectContext];
    
    NSPredicate *searchTermPredicate = [SCSession predicateForSearchTerm:searchTerm];
    
    NSPredicate *combinedPredicate;
    
    // Each predicate could be 'nil' if we're searching for everything with
    // no filters
    if (filterPredicate && searchTermPredicate) {
        combinedPredicate =
        [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                    subpredicates:@[filterPredicate, searchTermPredicate]];
    }
    else if (filterPredicate) {
        combinedPredicate = filterPredicate;
    }
    else if (searchTermPredicate) {
        combinedPredicate = searchTermPredicate;
    }
    
    NSArray *sessions;
    
    // Prevent the following crash: 'nil is not a valid predicate for filtering'
    if (combinedPredicate) {
        NSArray *unsortedSessions =
        [self.sessions filteredSetUsingPredicate:combinedPredicate].allObjects;
        
        sessions = [SCSession sessionsSortedBySlotAndName:unsortedSessions];
    }
    else {
        sessions = self.sessionsArrangedBySlot;
    }
    
    return sessions;
}

- (NSArray *)sponsorLevelsWithSponsorsSortedByOrder {
    return [SCSponsorLevel sponsorLevelsWithSponsorsSortedByOrder:self.sponsorLevels.allObjects];
}

#pragma mark - Internal

/** Returns a GET url string for 'self' and appends 'suffix'/ */
- (NSString *)getUrlWithSuffix:(NSString *)suffix class:(Class)cls {
    return [NSString stringWithFormat:@"%@/%@/%@%@",
            SCAPIRelativeUrlStrings.events,
            [@(self.eventID) stringValue],
            suffix,
            [NSString SC_fromDateUrlParameterStringForClass:cls]];
}

/** Calls a SCEventWithErrorBlock if it exists with the given parameters. */
+ (void)callSCEventWithErrorBlock:(SCEventWithErrorBlock)block
                            event:(SCEvent *)event
                            error:(NSError *)error {
    if (block) {
        block(event, error);
    }
    else {
        NSLog(@"SCEventWithErrorBlock is nil");
    }
}

/** Returns 'sessions' sorted based on their 'slot' values. */
- (NSArray *)sessionsArrangedBySlot {
    return [SCSession sessionsSortedBySlotAndName:self.sessions.allObjects];
}

#pragma mark - URL Strings

/** Returns a url string to GET all of the events */
+ (NSString *)getAllEventsUrlString {
    return [SCAPIRelativeUrlStrings.events
            stringByAppendingString:[NSString SC_fromDateUrlParameterStringForClass:[self class]]];
}

/** Returns a url string to GET the current event's sessions */
- (NSString *)getSessionsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sessions
                            class:[SCSession class]];
}

/** Returns a url string to GET the current event's speakers */
- (NSString *)getSpeakersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.speakers
                            class:[SCSpeaker class]];
}

/** Returns a url string to GET the current event's sponsors */
- (NSString *)getSponsorsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsors
                            class:[SCSponsor class]];
}

/** Returns a url string to GET the current event's sponsor levels */
- (NSString *)getSponsorLevelsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsorLevels
                            class:[SCSponsorLevel class]];
}

/** Returns a url string to GET the current event's organizers */
- (NSString *)getOrganizersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.organizers
                            class:[SCOrganizer class]];
}

/** Returns a url string to GET the current event's rooms */
- (NSString *)getRoomsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.rooms
                            class:[SCRoom class]];
}

#pragma mark MagicalRecord

- (BOOL)importAbout:(NSString *)about {
    self.about = about.SC_convertedHTMLTagString;
    return YES;
}

@end
