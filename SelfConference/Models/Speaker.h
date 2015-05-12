//
//  Speaker.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Speaker : NSManagedObject

@property (nonatomic, retain) NSString *biography;
@property (nonatomic, retain) NSDate *clientCreatedAt;
@property (nonatomic, retain) NSDate *clientUpdatedAt;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *speakerID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *twitterHandle;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSString *photoUrlString;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *sessions;

@end
