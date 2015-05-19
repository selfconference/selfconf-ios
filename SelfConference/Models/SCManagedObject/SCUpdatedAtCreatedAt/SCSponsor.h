//
//  Sponsor.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCEvent;

@interface SCSponsor : SCUpdatedAtCreatedAt

@property (nonatomic) NSInteger sponsorID;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *photoUrlString;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) NSSet *sponsorLevels;

/** Returns 'sponsors' sorted based on 'name'. */
+ (NSArray *)sponsorsOrderedByName:(NSArray *)sponsors;

@end
