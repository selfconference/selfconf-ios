//
//  Room.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCVenue;

@interface SCRoom : SCUpdatedAtCreatedAt

@property (nonatomic) NSInteger roomID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) SCVenue *venue;
@property (nonatomic, retain) NSSet *sessions;

@end
