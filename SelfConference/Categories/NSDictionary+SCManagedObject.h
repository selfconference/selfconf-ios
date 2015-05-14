//
//  NSDictionary+SCManagedObject.h
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SCManagedObject)

/** 
 Returns all objects inserted, updated, deleted and refreshed on an 
 'NSManagedObjectContext'. 
 */
- (NSSet *)SC_allChangedObjects;

/** Returns objects inserted into an 'NSManagedObjectContext'. */
- (NSSet *)SC_insertedObjects;

@end
