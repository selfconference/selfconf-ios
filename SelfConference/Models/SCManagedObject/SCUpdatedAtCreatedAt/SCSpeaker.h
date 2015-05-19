//
//  Speaker.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCEvent;

@interface SCSpeaker : SCUpdatedAtCreatedAt

@property (nonatomic) int32_t speakerID;
@property (nonatomic, retain) NSString *biography;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *twitterHandle;
@property (nonatomic, retain) NSString *photoUrlString;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) NSSet *sessions;

@end
