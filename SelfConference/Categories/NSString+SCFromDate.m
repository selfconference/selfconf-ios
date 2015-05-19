//
//  NSString+SCFromDate.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSString+SCFromDate.h"
#import "SCUpdatedAtCreatedAt.h"
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import "NSDateFormatter+SCDateFormatter.h"
#import "SCAPIStrings.h"

@implementation NSString (SCFromDate)

+ (NSString *)SC_fromDateUrlParameterStringForClass:(Class)cls {
    NSString *fromDate = @"";
    
    if ([cls isSubclassOfClass:[SCUpdatedAtCreatedAt class]]) {
        NSDate *updatedAt =
        [[cls MR_findFirstOrderedByAttribute:NSStringFromSelector(@selector(updatedAt))
                                   ascending:NO]
         updatedAt];
        
        if (updatedAt) {
            fromDate = [[NSDateFormatter SCC_sharedDateFormatterWithDefaultDateFormat]
                        stringFromDate:updatedAt];
        }
    }
    
    if (fromDate.length > 0) {
        fromDate = fromDate.SC_stringPrefixedByFromDateUrlParameter;
    }
    
    return fromDate;
}
                    
#pragma mark - Internal
                    
/** Returns "?from_date=self". */
- (NSString *)SC_stringPrefixedByFromDateUrlParameter {
    return
    [NSString stringWithFormat:@"?%@=%@", SCAPIRequestKeys.fromDate, self];
}

@end
