//
//  SCManagedObject.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void (^SCManagedObjectObjectsWithErrorBlock)(NSArray *objects, NSError *error);

/** The default dateFormat to use for all date attributes. */
FOUNDATION_EXPORT NSString * const kSCManagedObjectDefaultDateFormat;

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

/** Sorts and returns 'objects' based on 'propertyName'. */
+ (NSArray *)objects:(NSArray *)objects
sortedByPropertyName:(NSString *)propertyName;

/**
 Fetches 'self' in '+[NSManagedObjectContext(MagicalRecord) MR_defaultContext]'
 and refreshes it, updating all properties in the cache that were changed on
 another thread context. Returns 'self' on the default context.
 */
- (instancetype)refreshOnDefaultContext;

@end
