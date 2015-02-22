//
//  SCSharedStoryboards.h
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface SCSharedStoryboardInstances : NSObject

/** Returns Main.storyboard */
+ (UIStoryboard *)sharedMainStoryboardInstance;

@end
