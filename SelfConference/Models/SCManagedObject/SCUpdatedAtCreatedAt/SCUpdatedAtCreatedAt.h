//
//  SCUpdatedAtCreatedAt.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCManagedObject.h"

/**
 Adds common created at and updated at properties (both for the server and the
 client).
 
 When subclassing with a real entity, you must add the following attributes:
 - createdAt
 - updatedAt
 - clientCreatedAt
 - clientUpdatedAt
 */
@interface SCUpdatedAtCreatedAt : SCManagedObject

/** Represents the time in which the record was created on the server */
@property (nonatomic, retain) NSDate *createdAt;

/** Represents the time in which the record was updated on the server */
@property (nonatomic, retain) NSDate *updatedAt;

/** Represents the time in which the record was created locally on the client */
@property (nonatomic, retain) NSDate *clientCreatedAt;

/** Represents the time in which the record was updated locally on the client */
@property (nonatomic, retain) NSDate *clientUpdatedAt;

@end
