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

- (NSSet *)SC_insertedObjects {
    return self[NSInsertedObjectsKey];
}

- (NSSet *)SC_updatedObjects {
    return self[NSUpdatedObjectsKey];
}

- (NSSet *)SC_deletedObjects {
    return self[NSDeletedObjectsKey];
}

- (NSSet *)SC_refreshedObjects {
    return self[NSRefreshedObjectsKey];
}

@end
