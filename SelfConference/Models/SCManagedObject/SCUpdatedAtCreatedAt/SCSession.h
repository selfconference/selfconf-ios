//
//  Session.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"

typedef NS_ENUM(NSUInteger, SCSessionFilter) {
    SCSessionFilterAll,
    SCSessionFilterFavorites,
    SCSessionFilterDayOne,
    SCSessionFilterDayTwo
};

@import UIKit;

@class SCEvent, SCRoom;

@interface SCSession : SCUpdatedAtCreatedAt

@property (nonatomic) int32_t sessionID;

/** The date when the session is scheduled to take place. */
@property (nonatomic, retain) NSDate *slot;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *abstract;
@property (nonatomic) BOOL isKeynote;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, retain) SCEvent *event;
@property (nonatomic, retain) SCRoom *room;
@property (nonatomic, retain) NSSet *speakers;
@property (nonatomic, readonly) UIColor *color;

/** Returns 'speakers' ordered based on 'name'. */
- (NSArray *)speakersOrderedByName;

/** Returns a joined string of ordered 'speaker.name'. */
- (NSString *)joinedSpeakerNamesOrderedByName;

/** Returns an 'NSPredicate' to be used for the given filter */
+ (NSPredicate *)predicateForFilter:(SCSessionFilter)filter
                            context:(NSManagedObjectContext *)context;

/** 
 Returns an 'NSPredicate' that can be used to search for a session and all of 
 its linked objects. 
 */
+ (NSPredicate *)predicateForSearchTerm:(NSString *)searchTerm;

/** 
 Returns an 'NSPredicate' that can be used to query 'slot' values during 'date'
 */
+ (NSPredicate *)predicateForSlotDuringDate:(NSDate *)date;

/** Sorts an array of 'SCSession' instances based on 'slot' values. */
+ (NSArray *)sessionsSortedBySlot:(NSArray *)sessions;

@end
