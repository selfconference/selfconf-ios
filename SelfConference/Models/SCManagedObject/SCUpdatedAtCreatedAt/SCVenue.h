//
//  Venue.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@interface SCVenue : SCUpdatedAtCreatedAt

@property (nonatomic, retain) NSString *venueID;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *mapsUrlString;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *rooms;

/** Returns a url string to GET all of the venues */
+ (NSString *)getAllVenuesUrlString;

/** Returns a url string to GET all of the rooms for the given venue */
- (NSString *)getRoomsUrlString;

@end
