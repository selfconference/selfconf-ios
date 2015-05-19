//
//  NSString+SCFromDate.h
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCFromDate)

/** 
 Returns a "?from_date=someDate" string to be used as a url parameter. Returns 
 an empty string if there is none. 
 */
+ (NSString *)SC_fromDateUrlParameterStringForClass:(Class)cls;

@end
