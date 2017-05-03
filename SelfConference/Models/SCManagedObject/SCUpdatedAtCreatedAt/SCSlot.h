//
//  Room.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCEvent;
@class SCSession;

@interface SCSlot : SCUpdatedAtCreatedAt

@property (nonatomic) int32_t slotID;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

@end
