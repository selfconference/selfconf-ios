//
//  NSString+SCHTMLTagConverter.m
//  SelfConference
//
//  Created by Jeff Burt on 5/17/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "NSString+SCHTMLTagConverter.h"

@implementation NSString (SCHTMLTagConverter)

- (NSString *)SC_convertedHTMLTagString {
    NSString *newString = self;
    
    NSArray *replacements = @[@"<br />", @"\n",
                              @"<ul>", @"\n",
                              @"</ul>", @"\n",
                              @"<li>", @"• ",
                              @"</li>", @"\n",
                              @"<a href=\"", @"",
                              @"\">", @" (",
                              @"</a>", @")"];
    
    for (NSInteger i = 0; i < replacements.count; i += 2) {
        newString = [newString
                     stringByReplacingOccurrencesOfString:replacements[i]
                     withString:replacements[i + 1]];
    }
    
    return newString;
}

@end
