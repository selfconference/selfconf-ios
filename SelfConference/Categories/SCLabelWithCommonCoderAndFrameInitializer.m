//
//  SCViewWithCommonCoderAndFrameInitializer.m
//  SelfConference
//
//  Created by Jeff Burt on 5/17/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCLabelWithCommonCoderAndFrameInitializer.h"

@implementation SCLabelWithCommonCoderAndFrameInitializer

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonCoderAndFrameInitializer];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonCoderAndFrameInitializer];
    }
    
    return self;
}

- (void)commonCoderAndFrameInitializer {
    // Subclass template
}

@end
