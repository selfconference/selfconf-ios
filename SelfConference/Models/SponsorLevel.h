//
//  SponsorLevel.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SponsorLevel : NSManagedObject

@property (nonatomic, retain) NSDate *clientCreatedAt;
@property (nonatomic, retain) NSDate *clientUpdatedAt;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *photoUrlString;
@property (nonatomic, retain) NSString *sponsorLevelID;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic) NSInteger order;
@property (nonatomic, retain) NSManagedObject *event;
@property (nonatomic, retain) NSSet *sponsors;

@end
