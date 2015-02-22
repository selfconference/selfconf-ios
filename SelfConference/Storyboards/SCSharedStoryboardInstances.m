//
//  SCSharedStoryboards.m
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSharedStoryboardInstances.h"

@implementation SCSharedStoryboardInstances

+ (UIStoryboard *)sharedMainStoryboardInstance {
    static id sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [UIStoryboard storyboardWithName:@"Main"
                                                   bundle:nil];
    });
    
    return sharedInstance;
}

@end
