//
//  NSString+SCHTMLTagConverter.h
//  SelfConference
//
//  Created by Jeff Burt on 5/17/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCHTMLTagConverter)

/** 
 Returns a string with its known HTML converted to a format iOS supports. For
 example, '<br \>' is converted to '\n'. 
 */
- (NSString *)SC_convertedHTMLTagString;

@end
