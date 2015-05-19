//
//  SCUpdatingEventBaseViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatingEventBaseViewController.h"
#import "SCEvent.h"
#import <MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import "NSDictionary+SCManagedObject.h"
#import "NSSet+SCManagedObject.h"

@implementation SCUpdatingEventBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.event = [SCEvent currentEvent];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(managedObjectContextObjectsDidChangeWithNotification:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object:[NSManagedObjectContext MR_defaultContext]];
}

- (void)setEvent:(SCEvent *)event {
    if (event != _event) {
        _event = event;
        
        [self refreshEventData];
    }
}

- (void)refreshEventData {
    // Subclass template
}

#pragma mark - Internal

- (void)managedObjectContextObjectsDidChangeWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if ([userInfo.SC_insertedObjects SC_containsAtLeastOneObjectKindOfClass:[SCEvent class]]) {
        // It's possible that we got a new current event. Allow the overridden
        // setter to decide if it's new or not.
        self.event = [SCEvent currentEvent];
    }
    else if ([userInfo.SC_allChangedObjects containsObject:self.event]) {
        [self refreshEventData];
    }
}

@end
