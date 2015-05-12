//
//  Session.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCEvent, SCRoom;

@interface SCSession : SCUpdatedAtCreatedAt

@property (nonatomic, retain) NSString *sessionID;

/** The date when the session is scheduled to take place. */
@property (nonatomic, retain) NSDate *slot;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic) BOOL isKeynote;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) SCRoom *room;
@property (nonatomic, retain) NSSet *speakers;

@end
