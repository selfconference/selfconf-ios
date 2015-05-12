//
//  Session.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Room;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate *clientUpdatedAt;
@property (nonatomic, retain) NSDate *clientCreatedAt;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *sessionID;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSDate *slot;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic) BOOL isKeynote;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *speakers;

@end
