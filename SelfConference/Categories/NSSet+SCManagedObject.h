//
//  NSSet+SCManagedObject.h
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (SCManagedObject)

/** Returns 'YES' if there is at least one object kind of 'cls' */
- (BOOL)SC_containsAtLeastOneObjectKindOfClass:(Class)cls;

@end
