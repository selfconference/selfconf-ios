//
//  NSDateFormatter+SCDateFormatter.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSDateFormatter+SCDateFormatter.h"
#import "SCManagedObject.h"
#import "SelfConference-Swift.h"

@implementation NSDateFormatter (SCDateFormatter)

+ (instancetype)SCC_sharedDateFormatterWithDefaultDateFormat {
    static NSDateFormatter *sharedDateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDateFormatter = [self new];
        sharedDateFormatter.dateFormat = [Constants defaultDateFormatterString];
        sharedDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    });
    
    return sharedDateFormatter;
}

@end
