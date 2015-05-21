//
//  SCSpeakerCollectionViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSpeakerCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SCSpeaker.h"

@interface SCSpeakerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SCSpeakerCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // In case there is no image for the next speaker, show a black box instead
    self.imageView.image = nil;
}

- (void)setSpeaker:(SCSpeaker *)speaker {
    [self.imageView setImageWithURL:[NSURL URLWithString:speaker.photoUrlString]];
    
    _speaker = speaker;
}

@end
