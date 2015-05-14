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
#import "SCSession.h"
#import "SCSponsor.h"
#import "SCSponsorLevel.h"
#import "SCOrganizer.h"
#import <MTDates/NSDate+MTDates.h>

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
    SCEvent *currentEvent;
    
    NSArray *currentEvents =
    [self MR_findAllWithPredicate:[self isCurrentEventPredicate]
                        inContext:[NSManagedObjectContext MR_defaultContext]];
    
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

- (NSArray *)sessionsArrangedByDay {
    NSSortDescriptor *sortedBySlotSortDescriptor =
    [NSSortDescriptor
     sortDescriptorWithKey:NSStringFromSelector(@selector(slot))
     ascending:YES];
    
    NSArray *sortedSessions =
    [self.sessions sortedArrayUsingDescriptors:@[sortedBySlotSortDescriptor]];
    
    NSMutableArray *sessionsArrangedByDay = [NSMutableArray array];
    
    NSMutableArray *sessionsInOneDay = [NSMutableArray array];
    
    NSDate *previousSessionSlot = [sortedSessions.firstObject slot];
    
    for (SCSession *session in sortedSessions) {
        NSDate *sessionSlot = session.slot;
        
        if (![sessionSlot mt_isWithinSameDay:previousSessionSlot]) {
            previousSessionSlot = sessionSlot;
            [sessionsArrangedByDay addObject:sessionsInOneDay];
            sessionsInOneDay = [NSMutableArray array];
        }
        
        [sessionsInOneDay addObject:session];
    }
    
    // If there are 0 sorted sessions, don't add an empty array giving the
    // app a false positive that there are sessions
    if (sessionsInOneDay.count > 0) {
        [sessionsArrangedByDay addObject:sessionsInOneDay];
    }
    
    return sessionsArrangedByDay;
}

#pragma mark - Internal

/** Returns a GET url string for 'self' and appends 'suffix'/ */
- (NSString *)getUrlWithSuffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@/%@/%@",
            SCAPIRelativeUrlStrings.events,
            [@(self.eventID) stringValue],
            suffix];
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

#pragma mark - URL Strings

/** Returns a url string to GET all of the events */
+ (NSString *)getAllEventsUrlString {
    return SCAPIRelativeUrlStrings.events;
}

/** Returns a url string to GET the current event's sessions */
- (NSString *)getSessionsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sessions];
}

/** Returns a url string to GET the current event's speakers */
- (NSString *)getSpeakersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.speakers];
}

/** Returns a url string to GET the current event's sponsors */
- (NSString *)getSponsorsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsors];
}

/** Returns a url string to GET the current event's sponsor levels */
- (NSString *)getSponsorLevelsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsorLevels];
}

/** Returns a url string to GET the current event's organizers */
- (NSString *)getOrganizersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.organizers];
}

@end
