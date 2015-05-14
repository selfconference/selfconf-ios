//
//  NSDictionary+SCManagedObject.m
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSDictionary+SCManagedObject.h"

@import CoreData;

@implementation NSDictionary (SCManagedObject)

- (NSSet *)SC_allChangedObjects {
    NSMutableSet *allChangedObjects = [NSMutableSet set];
    [allChangedObjects unionSet:self.SC_insertedObjects];
    [allChangedObjects unionSet:self.SC_updatedObjects];
    [allChangedObjects unionSet:self.SC_deletedObjects];
    [allChangedObjects unionSet:self.SC_refreshedObjects];
    
    return allChangedObjects;
}

- (NSSet *)SC_insertedObjects {
    return self[NSInsertedObjectsKey];
}

#pragma mark - Internal

/** Returns objects updated on an 'NSManagedObjectContext'. */
- (NSSet *)SC_updatedObjects {
    return self[NSUpdatedObjectsKey];
}

/** Returns objects deleted from an 'NSManagedObjectContext'. */
- (NSSet *)SC_deletedObjects {
    return self[NSDeletedObjectsKey];
}

/** Returns objects refreshed on an 'NSManagedObjectContext'. */
- (NSSet *)SC_refreshedObjects {
    return self[NSRefreshedObjectsKey];
}

@end
