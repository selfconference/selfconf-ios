//
//  NSPredicate+SCPredicate.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSPredicate+SCPredicate.h"

@implementation NSPredicate (SCPredicate)

+ (NSPredicate *)SC_isKindOfClassPredicate:(Class)cls {
    return [NSPredicate predicateWithFormat:@"self isKindOfClass:%@", cls];
}

@end
