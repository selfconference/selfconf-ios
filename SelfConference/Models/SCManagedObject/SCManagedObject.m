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
#import "SCAPIService.h"
#import "SelfConference-Swift.h"

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

+ (void)getObjectsFromUrlString:(NSString *)urlString
                completionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCAPIService
     getUrlString:urlString
     completionBlock:^(id responseObject, NSError *error) {
         if (error) {
             [self.class callSCManagedObjectObjectsWithErrorBlock:completionBlock
                                                          objects:nil
                                                            error:error];
         }
         else {
             [self importFromResponseObject:responseObject
                        saveCompletionBlock:completionBlock];
         }
     }];
}

+ (NSArray *)objects:(NSArray *)objects
sortedByPropertyName:(NSString *)propertyName {
    return
    [self objects:objects sortedByPropertyNames:@[propertyName]];
}

+ (NSArray *)objects:(NSArray *)objects
sortedByPropertyNames:(NSArray *)propertyNames {
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    
    for (NSString *propertyName in propertyNames) {
        [sortDescriptors addObject:[NSSortDescriptor
                                    sortDescriptorWithKey:propertyName
                                    ascending:YES]];
    }
    
    return
    [objects sortedArrayUsingDescriptors:sortDescriptors];
}

- (instancetype)refreshOnDefaultContext {
    NSManagedObjectContext *defaultContext =
    [NSManagedObjectContext MR_defaultContext];
    
    SCManagedObject *defaultContextObject =
    [self MR_inContext:defaultContext];
    
    [defaultContext refreshObject:defaultContextObject mergeChanges:YES];
    
    return defaultContextObject;
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
                 isEqualToString: [Constants defaultDateFormatterString]];
                
                NSAssert(dateFormatIsCorrect,
                         @"Expected dateFormat to be set to %@",
                         kSCManagedObjectDefaultDateFormat);
            }
        }
    }
}

@end
