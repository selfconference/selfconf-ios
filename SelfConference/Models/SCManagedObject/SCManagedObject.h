//
//  SCManagedObject.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void (^SCManagedObjectObjectsWithErrorBlock)(NSArray *objects, NSError *error);

@interface SCManagedObject : NSManagedObject

/** 
 Imports responseObject into existing entities if possible, otherwise creates 
 new ones. 'saveCompletionBlock' is called after the entities are saved.
 */
+ (void)importFromResponseObject:(id)responseObject
             saveCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)saveCompletionBlock;

/**
 Calls a SCManagedObjectObjectsWithErrorBlock if it exists with the
 given parameters.
 */
+ (void)callSCManagedObjectObjectsWithErrorBlock:(SCManagedObjectObjectsWithErrorBlock)block
                                         objects:(NSArray *)objects
                                           error:(NSError *)error;

/**
 Fetches objects from the 'urlString' API endpoint, converts them into entities, 
 and returns them inside 'completionBlock'.
 */
+ (void)getObjectsFromUrlString:(NSString *)urlString
                completionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock;

/**
 Fetches 'self' in '+[NSManagedObjectContext(MagicalRecord) MR_defaultContext]'
 and refreshes it, updating all properties in the cache that were changed on
 another thread context. Returns 'self' on the default context.
 */
- (instancetype)refreshOnDefaultContext;

@end
