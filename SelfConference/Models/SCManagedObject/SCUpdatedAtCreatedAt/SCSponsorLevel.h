//
//  SponsorLevel.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@interface SCSponsorLevel : SCUpdatedAtCreatedAt

@property (nonatomic) NSInteger sponsorLevelID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *photoUrlString;
@property (nonatomic) NSInteger order;
@property (nonatomic, retain) NSManagedObject *event;
@property (nonatomic, retain) NSSet *sponsors;

@end
