//
//  SCSpeaker.h
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Parse/PFObject.h>
#import <Parse/PFSubclassing.h>
#import <Parse/PFRelation.h>

@interface SCSpeaker : PFObject <PFSubclassing>

/** The full name of the speaker. */
@property (nonatomic) NSString *name;

/** The Twitter handle of the speaker. */
@property (nonatomic) NSString *twitterHandle;

/** The biography of the speaker. */
@property (nonatomic) NSString *biography;

/** A relationship of many 'SCSession' instances who own the session. */
@property (nonatomic) PFRelation *sessions;

@end
