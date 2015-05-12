//
//  SCAPIService.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAPIService.h"

@implementation SCAPIService

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SCAPIService *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

@end
