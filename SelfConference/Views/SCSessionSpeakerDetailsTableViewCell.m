//
//  SCSessionSpeakerDetailsTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionSpeakerDetailsTableViewCell.h"
#import "UIColor+SCColor.h"
#import "UIView+SCUtilities.h"

@interface SCSessionSpeakerDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;
@property (weak, nonatomic) IBOutlet UILabel *initialLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;

@end

@implementation SCSessionSpeakerDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // TODO: Select a random (but consistent) color when setting the speaker
    self.avatarContainerView.backgroundColor = [UIColor SC_red];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.avatarContainerView SC_makeCircular];
}

@end
