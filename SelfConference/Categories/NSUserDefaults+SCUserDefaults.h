//
//  NSUserDefaults+SCUserDefaults.h
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (SCUserDefaults)

#pragma mark - Config last fetfhed at

/** Returns the date in which the config was last fetched. */
- (NSDate *)SC_configLastFetchedAt;

/** Sets the date in which the config was last fetched. */
- (void)SC_setConfigLastFetchedAt:(NSDate *)configLastFetchedAt;

@end
