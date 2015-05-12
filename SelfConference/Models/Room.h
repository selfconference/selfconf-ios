//
//  Room.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSDate *clientCreatedAt;
@property (nonatomic, retain) NSDate *clientUpdatedAt;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *roomID;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *sessions;

@end
