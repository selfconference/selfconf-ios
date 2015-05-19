//
//  SponsorLevel.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

@class SCEvent;

@interface SCSponsorLevel : SCUpdatedAtCreatedAt

@property (nonatomic) NSInteger sponsorLevelID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *photoUrlString;
@property (nonatomic) NSInteger order;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) NSSet *sponsors;

/** 
 Sorts an array of 'SCSponsorLevel' instances that have at least 1 'sponsor' 
 and sorts them based on 'order' values. 
 */
+ (NSArray *)sponsorLevelsWithSponsorsSortedByOrder:(NSArray *)sponsorLevels;

/** Returns '_sponsors' ordered by 'name'. */
- (NSArray *)sponsorsSortedByName;

@end
