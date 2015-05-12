//
//  NSAttributeDescription+SCCAttributeDescription.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSAttributeDescription+SCAttributeDescription.h"
#import <MagicalRecord/NSManagedObject+MagicalDataImport.h>

@implementation NSAttributeDescription (SCAttributeDescription)

- (void)SC_setDateFormat:(NSString *)dateFormat {
    [self SC_addUserInfoValue:dateFormat
                        toKey:kMagicalRecordImportCustomDateFormatKey];
}

#pragma mark - Internal

/** Adds the key/value pair to '_userInfo': '_userInfo[key] = value' */
- (void)SC_addUserInfoValue:(NSString *)value toKey:(NSString *)key {
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[self.userInfo copy]];
    
    userInfo[key] = value;
    
    self.userInfo = userInfo;
}

@end
