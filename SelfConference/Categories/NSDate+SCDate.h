//
//  NSDate+SCDate.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SCDate)

/** 
 Finds the start time of the conference stored inside '[PFConfig currentConfig]' 
 and returns the beginning of that day (midnight).
 */
+ (instancetype)SC_firstDayOfConference;

/** Finds the day after 'SC_firstDayOfConference'. */
+ (instancetype)SC_secondDayOfConference;

@end
