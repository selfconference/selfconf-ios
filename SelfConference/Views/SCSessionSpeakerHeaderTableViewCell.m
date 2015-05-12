//
//  SCSessionSpeakerHeaderTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionSpeakerHeaderTableViewCell.h"
#import "UIColor+SCColor.h"

@interface SCSessionSpeakerHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;

@end

@implementation SCSessionSpeakerHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // TODO: determine this based on the speaker instance
    self.speakerLabel.textColor = [UIColor SC_orange];
}

- (void)configureWithNumberOfSpeakers:(NSInteger)numberOfSpeakers {
    self.speakerLabel.text =
    numberOfSpeakers > 1 ?
    @"Speakers" :
    @"Speaker";
}

@end
