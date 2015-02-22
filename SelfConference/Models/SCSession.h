//
//  SCSession.h
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Parse/PFObject.h>
#import <Parse/PFSubclassing.h>

@class SCSpeaker, SCRoom;

@interface SCSession : PFObject <PFSubclassing>

/** The name of the session. */
@property (nonatomic) NSString *name;

/** The date when the session is scheduled to take place. */
@property (nonatomic) NSDate *scheduledAt;

/** The room in which the session is located. */
@property (nonatomic) SCRoom *room;

/** A relationship of many 'SCSpeaker' instances who own the session. */
@property (nonatomic) PFRelation *speakers;

@end
