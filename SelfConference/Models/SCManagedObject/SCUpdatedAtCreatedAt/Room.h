//
//  Room.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class Venue;

@interface Room : SCUpdatedAtCreatedAt

@property (nonatomic, retain) NSString *roomID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) NSSet *sessions;

@end
