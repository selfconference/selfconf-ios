//
//  SCManagedObject.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCManagedObject.h"
#import <MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Actions.h>
#import <MagicalRecord/NSManagedObject+MagicalDataImport.h>

/** The default dateFormat to use for all date attributes. */
static NSString * const kSCManagedObjectDefaultDateFormat =
@"yyyy-MM-dd'T'HH:mm:ss.SSSz";

@implementation SCManagedObject

- (instancetype)initWithEntity:(NSEntityDescription *)entity
insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    [SCManagedObject verifyDateFormatForAllDateAttributesInEntity:entity];
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];

    return self;
}

#pragma mark - Overridden

+ (NSString *)MR_entityName {
    NSString *className = NSStringFromClass(self);
    
    NSString *classPrefix = @"SC";
    
    // Remove the SC class prefix since we don't use prefixes for the entity
    // names in the 'xcdatamodeld' file.
    return [className stringByReplacingOccurrencesOfString:classPrefix
                                                withString:@""
                                                   options:0
                                                     range:NSMakeRange(0, classPrefix.length)];
}

#pragma mark - Public class methdods

+ (void)importFromResponseObject:(id)responseObject
             saveCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)saveCompletionBlock {
    if (!responseObject) {
        [self callSCManagedObjectObjectsWithErrorBlock:saveCompletionBlock
                                               objects:nil
                                                 error:nil];
    }
    else {
        __block NSArray *backgroundContextObjects;
        
        [MagicalRecord
         saveWithBlock:^(NSManagedObjectContext *localContext) {
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 backgroundContextObjects =
                 [self MR_importFromArray:responseObject inContext:localContext];
             }
             else {
                 NSAssert(NO, @"Currently only handle responseObject arrays");
             }
         }
         completion:^(BOOL contextDidSave, NSError *error) {
             // Key off of 'error' in case there were no updates that were made.
             if (error) {
                 [self callSCManagedObjectObjectsWithErrorBlock:saveCompletionBlock
                                                        objects:nil
                                                          error:error];
             }
             else {
                 if (!contextDidSave) {
                     [self callSCManagedObjectObjectsWithErrorBlock:saveCompletionBlock
                                                            objects:nil
                                                              error:nil];
                 }
                 // If there were saved changes, go ahead and refresh all of the
                 // properties.
                 else {
                     NSMutableArray *defaultContextObjects = [NSMutableArray array];
                     
                     for (SCManagedObject *object in backgroundContextObjects) {
                         [defaultContextObjects
                          addObject:[object refreshOnDefaultContext]];
                     }
                     
                     [self callSCManagedObjectObjectsWithErrorBlock:saveCompletionBlock
                                                            objects:defaultContextObjects
                                                              error:nil];
                 }
             }
         }];
    }
}

+ (void)callSCManagedObjectObjectsWithErrorBlock:(SCManagedObjectObjectsWithErrorBlock)block
                                         objects:(NSArray *)objects
                                           error:(NSError *)error {
    if (block) {
        block(objects, error);
    }
    else {
        NSLog(@"SCManagedObjectObjectsWithErrorBlock is nil");
    }
}

#pragma mark - Internal

/**
 Loops through each 'NSDateAttributeType' attribute and makes sure 
 'userInfo[@"dateFormat"]' values are properly set.
 */
+ (void)verifyDateFormatForAllDateAttributesInEntity:(NSEntityDescription *)entity {
    for (id property in entity.properties) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = property;
            
            if (attributeDescription.attributeType == NSDateAttributeType) {
                BOOL dateFormatIsCorrect =
                [attributeDescription.userInfo[kMagicalRecordImportCustomDateFormatKey]
                 isEqualToString:kSCManagedObjectDefaultDateFormat];
                
                NSAssert(dateFormatIsCorrect,
                         @"Expected dateFormat to be set to %@",
                         kSCManagedObjectDefaultDateFormat);
            }
        }
    }
}

/**
 Fetches 'self' in '+[NSManagedObjectContext(MagicalRecord) MR_defaultContext]'
 and refreshes it, updating all properties in the cache that were changed on
 another thread context. Returns 'self' on the default context.
 */
- (instancetype)refreshOnDefaultContext {
    NSManagedObjectContext *defaultContext =
    [NSManagedObjectContext MR_defaultContext];
    
    SCManagedObject *defaultContextObject =
    [self MR_inContext:defaultContext];
    
    [defaultContext refreshObject:defaultContextObject mergeChanges:YES];
    
    return defaultContextObject;
}

@end
