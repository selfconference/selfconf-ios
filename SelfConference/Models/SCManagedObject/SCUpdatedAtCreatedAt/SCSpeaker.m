//
//  Speaker.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSpeaker.h"
#import "SCEvent.h"
#import "SCSession.h"
#import "SelfConference-Swift.h"

NSString * const kSCSpeakerOpenTwitterProfileForSpeakerNotificationName =
@"kSCSpeakerOpenTwitterProfileForSpeakerNotificationName";

@implementation SCSpeaker

@dynamic speakerID;
@dynamic biography;
@dynamic name;
@dynamic twitterHandle;
@dynamic photoUrlString;
@dynamic event;
@dynamic sessions;

#pragma mark MagicalRecord

- (BOOL)importBiography:(NSString *)biography {
    self.biography = biography.SC_convertedHTMLTagString;
    return YES;
}

@end
