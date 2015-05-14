//
//  NSManagedObjectContext+SCManagedObjectContext.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SCManagedObjectContext)

/** Returns all of the inserted objects that are descendents of a specific class */
- (NSSet *)SC_insertedObjectsKindOfClass:(Class)cls;

/**
 Returns all of the inserted and updated objects that are descendents of
 a specific class.
 */
- (NSSet *)SC_insertedAndUpdatedAtObjectsKindOfClass:(Class)cls;

@end
