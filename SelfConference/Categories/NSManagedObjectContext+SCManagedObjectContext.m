//
//  NSManagedObjectContext+SCManagedObjectContext.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSManagedObjectContext+SCManagedObjectContext.h"
#import "NSPredicate+SCPredicate.h"

@implementation NSManagedObjectContext (SCManagedObjectContext)

- (NSSet *)SC_insertedObjectsKindOfClass:(Class)cls {
    return
    [self.insertedObjects
     filteredSetUsingPredicate:[NSPredicate SC_isKindOfClassPredicate:cls]];
}

- (NSSet *)SC_insertedAndUpdatedAtObjectsKindOfClass:(Class)cls {
    return
    [[self SC_insertedObjectsKindOfClass:cls]
     setByAddingObjectsFromSet:[self SC_updatedObjectsKindOfClass:cls]];
}

#pragma mark - Internal

/** Returns all of the updated objects that are descendents of a specific class */
- (NSSet *)SC_updatedObjectsKindOfClass:(Class)cls {
    return
    [self.updatedObjects
     filteredSetUsingPredicate:[NSPredicate SC_isKindOfClassPredicate:cls]];
}

@end
