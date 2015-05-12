//
//  SCManagedObject.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCManagedObject.h"
#import "NSAttributeDescription+SCAttributeDescription.h"

@implementation SCManagedObject

- (instancetype)initWithEntity:(NSEntityDescription *)entity
insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        [self setDateFormatForAllDateAttributes];
    }
    
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

#pragma mark - Internal

/**
 Loops through each NSDateAttributeType attribute and applies the date format
 that is used by the API.
 */
- (void)setDateFormatForAllDateAttributes {
    for (id property in self.entity.properties) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = property;
            
            if (attributeDescription.attributeType == NSDateAttributeType) {
                // Example date string from the API: @"2015-03-02T14:50:47.944Z"
                [attributeDescription
                 SC_setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
            }
        }
    }
}

@end
