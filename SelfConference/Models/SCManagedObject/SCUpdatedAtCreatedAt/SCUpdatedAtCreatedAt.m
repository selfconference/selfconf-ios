//
//  SCUpdatedAtCreatedAt.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatedAtCreatedAt.h"
#import "NSManagedObjectContext+SCManagedObjectContext.h"

@implementation SCUpdatedAtCreatedAt

@dynamic createdAt;
@dynamic updatedAt;
@dynamic clientCreatedAt;
@dynamic clientUpdatedAt;

#pragma mark - Overrides

+ (void)load {
    [super load];
    
    // With help from http://stackoverflow.com/a/10723861/1926015
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(objectContextWillSave:)
         name:NSManagedObjectContextWillSaveNotification
         object:nil];
    }
}

#pragma mark - Internal

+ (void)objectContextWillSave:(NSNotification *)notification {
    NSManagedObjectContext *context = notification.object;
    
    NSDate *now = [NSDate date];
    
    Class cls = [self class];
    
    // Set the 'clientCreatedAt' for all inserted objects
    [[context SC_insertedObjectsKindOfClass:cls]
     makeObjectsPerformSelector:@selector(setClientCreatedAt:)
     withObject:now];
    
    // Set the 'clientUpdatedAt' for all inserted and updated objects
    [[context SC_insertedAndUpdatedAtObjectsKindOfClass:cls]
     makeObjectsPerformSelector:@selector(setClientUpdatedAt:)
     withObject:now];
}

@end
