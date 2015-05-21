//
//  SCAPIService.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAPIService.h"
#import "SCHTTPSessionManager.h"

typedef void (^SCAPIServiceTaskWithResponseObjectBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^SCAPIServiceTaskWithErrorBlock)(NSURLSessionDataTask *task, NSError *error);

@implementation SCAPIService

+ (void)getUrlString:(NSString *)urlString
     completionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock {
    [[SCHTTPSessionManager sharedInstance]
     GET:urlString
     parameters:nil
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

+ (void)postUrlString:(NSString *)urlString
           parameters:(NSDictionary *)parameters
      completionBlock:(SCAPIServiceResponseObjectWithErrorBlock)completionBlock {
    [[SCHTTPSessionManager sharedInstance]
     POST:urlString
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

@end
