//
//  NSError+SCError.H
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

@import Foundation;

@interface NSError (SCError)

/** 
 Quickly creates an error with the bundle indentifier as the domain and the 
 'description' as the localized description. Uses 0 as the code.
 */
+ (NSError *)SC_errorWithDescription:(NSString *)description;

@end
