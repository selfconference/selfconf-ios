//
//  Event.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCEvent.h"
#import "SCAPIStrings.h"

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

+ (NSString *)getAllEventsUrlString {
    return SCAPIRelativeUrlStrings.events;
}

- (NSString *)getSessionsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sessions];
}

- (NSString *)getSpeakersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.speakers];
}

- (NSString *)getSponsorsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsors];
}

- (NSString *)getSponserLevelsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsorLevels];
}

- (NSString *)getOrganizersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.organizers];
}

#pragma mark - Internal

/** Returns a GET url string for 'self' and appends 'suffix'/ */
- (NSString *)getUrlWithSuffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@/%@/%@",
            SCAPIRelativeUrlStrings.events,
            self.eventID,
            suffix];
}

@end
