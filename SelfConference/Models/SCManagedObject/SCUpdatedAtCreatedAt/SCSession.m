//
//  Session.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSession.h"
#import "SCEvent.h"
#import "SCRoom.h"
#import "UIColor+SCColor.h"
#import "NSString+SCHTMLTagConverter.h"
#import <MTDates/NSDate+MTDates.h>
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>

@implementation SCSession

@dynamic sessionID;
@dynamic slot;
@dynamic name;
@dynamic abstract;
@dynamic isKeynote;
@dynamic isFavorite;
@dynamic event;
@dynamic room;
@dynamic speakers;

- (NSArray *)speakersOrderedByName {
    NSSortDescriptor *sortedBySlotSortDescriptor =
    [NSSortDescriptor
     sortDescriptorWithKey:NSStringFromSelector(@selector(name))
     ascending:YES];
    
    return
    [self.speakers sortedArrayUsingDescriptors:@[sortedBySlotSortDescriptor]];
}

- (NSString *)joinedSpeakerNamesOrderedByName {
    return [[self.speakersOrderedByName valueForKey:NSStringFromSelector(@selector(name))]
            componentsJoinedByString:@", "];
}

- (UIColor *)color {
    NSArray *availableColors = @[[UIColor SC_red],
                                 [UIColor SC_orange],
                                 [UIColor SC_yellow],
                                 [UIColor SC_purple]];
    
    NSInteger indexOfColorToUse = self.sessionID % availableColors.count;
    
    return availableColors[indexOfColorToUse];
}

+ (NSPredicate *)predicateForFilter:(SCSessionFilter)filter
                            context:(NSManagedObjectContext *)context {
    NSPredicate *predicate;
    
    switch (filter) {
        case SCSessionFilterAll: {
            predicate = nil;
        } break;
            
        case SCSessionFilterFavorites: {
            predicate = [NSPredicate predicateWithFormat:@"%K = YES",
                         NSStringFromSelector(@selector(isFavorite))];
        } break;
            
        case SCSessionFilterDayOne: {
            predicate =
            [self predicateForSlotDuringDate:[SCEvent currentEventInContext:context].startDate];
        } break;
            
        case SCSessionFilterDayTwo: {
            predicate =
            [self predicateForSlotDuringDate:[SCEvent currentEventInContext:context].endDate];
        } break;
            
        default: {
            
        } break;
    }
    
    return predicate;
}

+ (NSPredicate *)predicateForSearchTerm:(NSString *)searchTerm {
    NSPredicate *predicate;
    
    // Only filter if we have a 'searchTerm'
    if (searchTerm.length > 0) {
        // 'CONTAINS[c]' gives us a case insensitive search
        predicate =
        [NSPredicate predicateWithFormat:@"(name CONTAINS[c] %@) OR (abstract CONTAINS[c] %@) OR (room.name CONTAINS[c] %@) OR (ANY speakers.name CONTAINS[c] %@) OR (ANY speakers.biography CONTAINS[c] %@)",
         searchTerm,
         searchTerm,
         searchTerm,
         searchTerm,
         searchTerm];
    }
    
    return predicate;
}

+ (NSPredicate *)predicateForSlotDuringDate:(NSDate *)date {
    NSDate *beginningOfDay = date.mt_startOfCurrentDay;
    NSDate *endOfDay = date.mt_endOfCurrentDay;
    
    NSString *slotPropertyName = NSStringFromSelector(@selector(slot));
    
    return
    [NSPredicate predicateWithFormat:@"(%K >= %@) AND (%K <= %@)",
     slotPropertyName,
     beginningOfDay,
     slotPropertyName,
     endOfDay];
}

+ (NSArray *)sessionsSortedBySlot:(NSArray *)sessions {
    return [self objects:sessions
    sortedByPropertyName:NSStringFromSelector(@selector(slot))];
}

#pragma mark MagicalRecord

- (BOOL)importAbstract:(NSString *)abstract {
    self.abstract = abstract.SC_convertedHTMLTagString;
    return YES;
}

@end
