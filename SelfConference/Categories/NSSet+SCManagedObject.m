//
//  NSSet+SCManagedObject.m
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSSet+SCManagedObject.h"

@implementation NSSet (SCManagedObject)

- (BOOL)SC_containsAtLeastOneObjectKindOfClass:(Class)cls {
    return
    [self objectsPassingTest:^BOOL(id object, BOOL *stop) {
        BOOL didFindObject = NO;
        
        if ([object isKindOfClass:cls]) {
            didFindObject = YES;
            *stop = YES;
        }
        
        return didFindObject;
    }].count > 0;
}

@end
