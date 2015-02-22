//
//  SCSession.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSession.h"
#import <Parse/PFObject+Subclass.h>
#import <MTDates/NSDate+MTDates.h>
#import "NSError+SCError.h"

@implementation SCSession

@dynamic name, details, scheduledAt, room, speakers;

#pragma mark - PFSubclassing

+ (NSString *)parseClassName {
    return @"Session";
}

+ (void)getLocalSessionsWithStartOfDay:(NSDate *)startOfDay
                                 block:(SCSessionFetchSessionsWithErrorBlock)block {
    if (!startOfDay) {
        if (block) {
            block(nil, [NSError SC_errorWithDescription:@"Expected startOfDay to be non-nil"]);
        }
    }
    else {
        PFQuery *query = [self query];
        [query fromLocalDatastore];
        
        [query
         whereKey:NSStringFromSelector(@selector(scheduledAt))
         greaterThanOrEqualTo:startOfDay];
        
        NSDate *startOfNextDay = [startOfDay mt_dateDaysAfter:1];
        
        [query
         whereKey:NSStringFromSelector(@selector(scheduledAt))
         lessThanOrEqualTo:startOfNextDay];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (block) {
                block(objects, error);
            }
        }];
    }
}

@end
