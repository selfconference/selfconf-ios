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

#pragma mark - Public instance methods

+ (void)importFromResponseObject:(id)responseObject
             saveCompletionBlock:(SCManagedObjectContextDidSaveWithErrorBlock)saveCompletionBlock {
    if (!responseObject) {
        [self callSCManagedObjectContextDidSaveWithErrorBlock:saveCompletionBlock
                                               contextDidSave:NO
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
                 [self callSCManagedObjectContextDidSaveWithErrorBlock:saveCompletionBlock
                                                        contextDidSave:NO
                                                                 error:error];
             }
             else {
                 // If there were saved changes, go ahead and refresh all of the
                 // properties.
                 if (contextDidSave) {
                     for (SCManagedObject *object in backgroundContextObjects) {
                         [object refreshOnDefaultContext];
                     }
                 }
                 
                 [self callSCManagedObjectContextDidSaveWithErrorBlock:saveCompletionBlock
                                                        contextDidSave:contextDidSave
                                                                 error:nil];
             }
         }];
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
 another thread context.
 */
- (void)refreshOnDefaultContext {
    NSManagedObjectContext *defaultContext =
    [NSManagedObjectContext MR_defaultContext];
    
    [defaultContext refreshObject:[self MR_inContext:defaultContext]
                     mergeChanges:YES];
}

/** 
 Calls a SCManagedObjectContextDidSaveWithErrorBlock if it exists with the
 given parameters. 
 */
+ (void)callSCManagedObjectContextDidSaveWithErrorBlock:(SCManagedObjectContextDidSaveWithErrorBlock)block
                                         contextDidSave:(BOOL)contextDidSave
                                                  error:(NSError *)error {
    if (block) {
        block(contextDidSave, error);
    }
    else {
        NSLog(@"SCManagedObjectContextDidSaveWithErrorBlock is nil");
    }
}

@end
