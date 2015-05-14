//
//  SCHTTPSessionManager.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@interface SCHTTPSessionManager : AFHTTPSessionManager

/** The shared instance that should be used for all API requests and responses */
+ (instancetype)sharedInstance;

@end
