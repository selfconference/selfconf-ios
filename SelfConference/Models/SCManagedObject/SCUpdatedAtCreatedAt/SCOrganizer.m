//
//  Organizer.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCOrganizer.h"
#import "SCEvent.h"
#import "NSString+SCHTMLTagConverter.h"

@implementation SCOrganizer

@dynamic organizerID;
@dynamic biography;
@dynamic name;
@dynamic photoUrlString;
@dynamic twitterHandle;
@dynamic email;
@dynamic events;

#pragma mark MagicalRecord

- (BOOL)importBiography:(NSString *)biography {
    self.biography = biography.SC_convertedHTMLTagString;
    return YES;
}

@end
