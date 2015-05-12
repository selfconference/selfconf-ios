//
//  Venue.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *mapsUrlString;
@property (nonatomic, retain) NSDate *clientCreatedAt;
@property (nonatomic, retain) NSDate *clientUpdatedAt;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *venueID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSSet *events;

@end
