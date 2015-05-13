//
//  SCAPIService.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCEvent;

typedef void (^SCAPIServiceResponseObjectWithErrorBlock)(id responseObject, NSError *error);

@interface SCAPIService : NSObject

/** GETs all events from the API */
+ (void)getAllEventsWithCompletionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock;

/** GETs all speakers from the API for a given event. */
+ (void)getSpeakersForEvent:(SCEvent *)event
            completionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock;

@end
