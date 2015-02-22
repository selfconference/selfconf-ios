//
//  NSError+SCError.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSError+SCError.h"

@implementation NSError (SCError)

+ (NSError *)SC_errorWithDescription:(NSString *)description {
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (description) {
        userInfo[NSLocalizedDescriptionKey] = description;
    }
    
    return [NSError errorWithDomain:bundleIdentifier
                               code:0
                           userInfo:userInfo];
}

@end
