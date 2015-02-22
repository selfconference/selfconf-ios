//
//  NSUserDefaults+SCUserDefaults.m
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSUserDefaults+SCUserDefaults.h"

static NSString * const kSCUserDefaultsKeyConfigLastFetchedAt =
@"kSCUserDefaultsKeyConfigLastFetchedAt";

@implementation NSUserDefaults (SCUserDefaults)

#pragma mark - Config last fetfhed at

- (NSDate *)SC_configLastFetchedAt {
    return [self objectForKey:kSCUserDefaultsKeyConfigLastFetchedAt];
}

- (void)SC_setConfigLastFetchedAt:(NSDate *)configLastFetchedAt {
    [self setObject:configLastFetchedAt
             forKey:kSCUserDefaultsKeyConfigLastFetchedAt];
}

@end
