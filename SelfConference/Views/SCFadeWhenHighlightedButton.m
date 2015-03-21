//
//  SCFadeWhenHighlightedButton.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCFadeWhenHighlightedButton.h"

/** The alpha for when the button is highlighted (aka pressed) */
static CGFloat const kSCFadeWhenHighlightedButtonHighlightedAlpha = 0.6f;

@implementation SCFadeWhenHighlightedButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    // We are going to manually set the alpha change on press events. By
    // default, '_imageView' will fade, but we are going to fade all elements
    // so this is not needed.
    self.adjustsImageWhenHighlighted = NO;
}

#pragma mark - Overrides

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.alpha =
    highlighted ?
    kSCFadeWhenHighlightedButtonHighlightedAlpha :
    1.0f;
}

@end
