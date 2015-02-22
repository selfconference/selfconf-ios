//
//  SCRoom.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCRoom.h"
#import <Parse/PFObject+Subclass.h>

@implementation SCRoom

#pragma mark - PFSubclassing

+ (NSString *)parseClassName {
    return @"Room";
}

@end
