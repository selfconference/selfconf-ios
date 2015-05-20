//
//  SCSpeakerCollectionViewCell.h
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCFadeWhenHighlightedCollectionViewCell.h"

@class SCSpeaker;

@interface SCSpeakerCollectionViewCell : SCFadeWhenHighlightedCollectionViewCell

@property (nonatomic) SCSpeaker *speaker;

@end
