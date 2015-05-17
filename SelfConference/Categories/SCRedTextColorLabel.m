//
//  SCRedTextColorLabel.m
//  SelfConference
//
//  Created by Jeff Burt on 5/17/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCRedTextColorLabel.h"
#import "UIColor+SCColor.h"

@implementation SCRedTextColorLabel

- (void)commonCoderAndFrameInitializer {
    [super commonCoderAndFrameInitializer];
    
    self.textColor = [UIColor SC_red];
}

@end
