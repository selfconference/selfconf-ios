//
//  Event.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *twitterHandle;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSDate *clientCreatedAt;
@property (nonatomic, retain) NSDate *clientUpdatedAt;
@property (nonatomic, retain) NSString *lanyrdPath;
@property (nonatomic) BOOL isCurrent;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *rooms;
@property (nonatomic, retain) NSSet *speakers;
@property (nonatomic, retain) NSSet *sponsors;
@property (nonatomic, retain) NSSet *sponsorLevels;
@property (nonatomic, retain) NSSet *organizers;
@property (nonatomic, retain) NSManagedObject *venue;

@end
