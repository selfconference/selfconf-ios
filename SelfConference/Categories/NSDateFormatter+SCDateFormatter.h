//
//  NSDateFormatter+SCDateFormatter.h
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

@import Foundation;

@interface NSDateFormatter (SCDateFormatter)

/**
 Returns an NSDateFormatter instance with Cosntants.defaultDateFormatterString set 
 as 'dateFormat'.
 */
+ (instancetype)SCC_sharedDateFormatterWithDefaultDateFormat;

@end
