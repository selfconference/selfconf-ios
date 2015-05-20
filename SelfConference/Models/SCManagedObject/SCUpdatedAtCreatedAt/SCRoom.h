//
//  Room.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCVenue;
@class SCEvent;

@interface SCRoom : SCUpdatedAtCreatedAt

@property (nonatomic) int32_t roomID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) SCVenue *venue;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) NSSet *sessions;

@end
