//
//  Venue.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCVenue.h"
#import "SCAPIStrings.h"

@implementation SCVenue

@dynamic venueID;
@dynamic about;
@dynamic mapsUrlString;
@dynamic name;
@dynamic address;
@dynamic events;
@dynamic rooms;

+ (NSString *)getAllVenuesUrlString {
    return SCAPIRelativeUrlStrings.venues;
}

- (NSString *)getRoomsUrlString {
    return [NSString stringWithFormat:@"%@/%@/%@",
            SCAPIRelativeUrlStrings.venues,
            self.venueID,
            SCAPIRelativeUrlStrings.rooms];
}

@end
