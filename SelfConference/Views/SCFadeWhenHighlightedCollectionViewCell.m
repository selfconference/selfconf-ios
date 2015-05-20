//
//  SCFadeWhenHighlightedCollectionViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCFadeWhenHighlightedCollectionViewCell.h"

@implementation SCFadeWhenHighlightedCollectionViewCell

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.alpha = highlighted ? 0.4f : 1.0f;
}

@end
