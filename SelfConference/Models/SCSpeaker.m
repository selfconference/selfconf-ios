//
//  SCSpeaker.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSpeaker.h"
#import <Parse/PFObject+Subclass.h>

@implementation SCSpeaker

#pragma mark - PFSubclassing

@dynamic name, twitterHandle, biography, sessions;

+ (NSString *)parseClassName {
    return @"Speaker";
}

@end
