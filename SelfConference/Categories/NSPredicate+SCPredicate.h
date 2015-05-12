//
//  NSPredicate+SCPredicate.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

@import Foundation;

@interface NSPredicate (SCPredicate)

/** 
 Builds and returns a predicate that can be used to search for a specific class.
 */
+ (NSPredicate *)SC_isKindOfClassPredicate:(Class)cls;

@end
