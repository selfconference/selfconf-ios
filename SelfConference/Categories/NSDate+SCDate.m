//
//  NSDate+SCDate.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSDate+SCDate.h"
#import <Parse/PFConfig.h>
#import "SCConfigStrings.h"
#import <MTDates/NSDate+MTDates.h>

@implementation NSDate (SCDate)

+ (instancetype)SC_firstDayOfConference {
    // Most likely returns 8:00 am EST
    NSDate *conferenceStartTime =
    [PFConfig currentConfig][SCConfigStrings.conferenceStartTime];
    
    return conferenceStartTime.mt_startOfCurrentDay;
}

+ (instancetype)SC_secondDayOfConference {
    return [[self SC_firstDayOfConference] mt_dateDaysAfter:1];
}

@end
