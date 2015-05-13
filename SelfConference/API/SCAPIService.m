//
//  SCAPIService.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAPIService.h"
#import "SCHTTPSessionManager.h"
#import "SCEvent.h"

typedef void (^SCAPIServiceTaskWithResponseObjectBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^SCAPIServiceTaskWithErrorBlock)(NSURLSessionDataTask *task, NSError *error);

@implementation SCAPIService

+ (void)getAllEventsWithCompletionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock {
    [self
     GET:[SCEvent getAllEventsUrlString]
     parameters:nil
     completionBlock:completionBlock];
}

+ (void)getSpeakersForEvent:(SCEvent *)event
            completionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock {
    [self
     GET:[event getSpeakersUrlString]
     parameters:nil
     completionBlock:completionBlock];
}

#pragma mark - Internal

/**
 Calls a SCAPIServiceResponseObjectWithErrorBlock if it exists with the given
 parameters.
 */
+ (void)callSCAPIServiceResponseObjectWithErrorBlock:(SCAPIServiceResponseObjectWithErrorBlock)block
                                      responseObject:(id)responseObject
                                               error:(NSError *)error {
    if (block) {
        block(responseObject, error);
    }
    else {
        NSLog(@"SCAPIServiceResponseObjectWithErrorBlock is nil");
    }
}

/** Custom HTTP get method that returns a BTAPIResponse in the success block */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
              completionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock {
    return [[SCHTTPSessionManager sharedInstance]
            GET:URLString
            parameters:parameters
            success:^(NSURLSessionDataTask *task, id responseObject) {
                [self callSCAPIServiceResponseObjectWithErrorBlock:completionBlock
                                                    responseObject:responseObject
                                                             error:nil];
            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self callSCAPIServiceResponseObjectWithErrorBlock:completionBlock
                                                    responseObject:nil
                                                             error:error];
            }];
}

@end
