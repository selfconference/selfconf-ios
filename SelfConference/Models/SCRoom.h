//
//  SCRoom.h
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Parse/PFObject.h>
#import <Parse/PFSubclassing.h>
#import <Parse/PFRelation.h>

@interface SCRoom : PFObject <PFSubclassing>

/** The name of the room. */
@property (nonatomic) NSString *name;

@end
