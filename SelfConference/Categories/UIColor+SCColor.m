//
//  UIColor+SCColor.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIColor+SCColor.h"

@implementation UIColor (SCColor)

+ (instancetype)SC_teal {
    return
    [self SC_solidColorWithNumeratorsForRed:51 green:145 blue:148];
}

+ (instancetype)SC_darkTeal {
    return
    [self SC_solidColorWithNumeratorsForRed:45 green:130 blue:133];
}

+ (instancetype)SC_orange {
    return
    [self SC_solidColorWithNumeratorsForRed:251 green:107 blue:64];
}

+ (instancetype)SC_purple {
    return
    [self SC_solidColorWithNumeratorsForRed:167 green:2 blue:103];
}

+ (instancetype)SC_yellow {
    return
    [self SC_solidColorWithNumeratorsForRed:246 green:216 blue:107];
}

+ (instancetype)SC_red {
    return
    [self SC_solidColorWithNumeratorsForRed:241 green:13 blue:73];
}

#pragma mark - Internal

/** Returns an opaque color with the given RGB numerators. */
+ (instancetype)SC_solidColorWithNumeratorsForRed:(NSInteger)red
                                            green:(NSInteger)green
                                             blue:(NSInteger)blue {
    return [self colorWithRed:red / 255.0f
                        green:green / 255.0f
                         blue:blue / 255.0f
                        alpha:1.0f];
}

@end
