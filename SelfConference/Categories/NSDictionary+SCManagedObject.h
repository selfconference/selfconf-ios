//
//  NSDictionary+SCManagedObject.h
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SCManagedObject)

/** Returns objects inserted into an 'NSManagedObjectContext'. */
- (NSSet *)SC_insertedObjects;

/** Returns objects updated on an 'NSManagedObjectContext'. */
- (NSSet *)SC_updatedObjects;

/** Returns objects deleted from an 'NSManagedObjectContext'. */
- (NSSet *)SC_deletedObjects;

/** Returns objects refreshed on an 'NSManagedObjectContext'. */
- (NSSet *)SC_refreshedObjects;

@end
