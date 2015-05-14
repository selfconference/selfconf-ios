//
//  SCHTTPSessionManager.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCHTTPSessionManager.h"
#import "SCAPIStrings.h"

@implementation SCHTTPSessionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SCHTTPSessionManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kSCAPIServiceBaseUrlString];
        sharedInstance = [[self alloc] initWithBaseURL:baseURL];
    });
    
    return sharedInstance;
}


@end
