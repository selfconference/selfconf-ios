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

@implementation SCEvent

@dynamic eventID;
@dynamic name;
@dynamic about;
@dynamic twitterHandle;
@dynamic startDate;
@dynamic endDate;
@dynamic ticketsUrlString;
@dynamic lanyrdPath;
@dynamic isCurrent;
@dynamic sessions;
@dynamic speakers;
@dynamic sponsors;
@dynamic sponsorLevels;
@dynamic organizers;
@dynamic venue;

#pragma mark - Overrides

- (void)setIsCurrent:(BOOL)isCurrent {
    if (isCurrent) {
        // Delete old events when we mark a new one as current
        for (SCEvent *event in [self.class MR_findAllInContext:self.managedObjectContext]) {
            if (event != self) {
                [event MR_deleteEntityInContext:self.managedObjectContext];
            }
        }
    }
    
    NSString *isCurrentPropertyName = NSStringFromSelector(@selector(isCurrent));
    
    [self willChangeValueForKey:isCurrentPropertyName];
    
    [self setPrimitiveValue:[NSNumber numberWithBool:isCurrent]
                     forKey:isCurrentPropertyName];
    
    [self didChangeValueForKey:isCurrentPropertyName];
}

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

#pragma mark - Local fetchers

+ (SCEvent *)currentEvent {
    return [self currentEventInContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (SCEvent *)currentEventInContext:(NSManagedObjectContext *)context {
    SCEvent *currentEvent;
    
    NSArray *currentEvents =
    [self MR_findAllWithPredicate:[self isCurrentEventPredicate]
                        inContext:context];
    
    if (currentEvents.count == 0) {
        NSLog(@"There is no current SCEvent");
    }
    else if (currentEvents.count == 1) {
        currentEvent = currentEvents.firstObject;
    }
    else {
        NSAssert(NO, @"More than 1 current event exists.");
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
        
        sessions = [SCSession sessionsSortedBySlot:unsortedSessions];
    }
    else {
        sessions = self.sessionsArrangedBySlot;
    }
    
    return sessions;
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

/** Returns a 'NSPredicate' that can be used to find the current event. */
+ (NSPredicate *)isCurrentEventPredicate {
    // TODO: Change 'NO' to 'YES' once the API sets 'isCurrent' (currently
    // this is an open issue).
    return [NSPredicate predicateWithFormat:@"%K == NO",
            NSStringFromSelector(@selector(isCurrent))];
}

/** Returns 'sessions' sorted based on their 'slot' values. */
- (NSArray *)sessionsArrangedBySlot {
    return [SCSession sessionsSortedBySlot:self.sessions.allObjects];
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

#pragma mark MagicalRecord

- (BOOL)importAbout:(NSString *)about {
    self.about = about.SC_convertedHTMLTagString;
    return YES;
}

@end
