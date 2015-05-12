//
//  Venue.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@interface Venue : SCUpdatedAtCreatedAt

@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *mapsUrlString;
@property (nonatomic, retain) NSString *venueID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *rooms;

@end
