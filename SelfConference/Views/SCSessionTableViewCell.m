//
//  SCSessionCollectionViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionTableViewCell.h"
#import "SCSession.h"
#import "SCRoom.h"
#import "UIColor+SCColor.h"
#import <MTDates/NSDate+MTDates.h>
#import "UIView+SCUtilities.h"

@interface SCSessionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UIView *timeLabelCircleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SCSessionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // TODO: Figure out a way to randomly select a color (and the same color
    // each time) when setting a session
    self.timeLabelCircleContainerView.backgroundColor = [UIColor SC_teal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLabelCircleContainerView SC_makeCircular];
}

- (void)setSession:(SCSession *)session {
    self.nameLabel.text = session.name;
    self.roomNameLabel.text = session.room.name;
    
    self.timeLabel.text = [session.scheduledAt
                           mt_stringFromDateWithFormat:@"ha"
                           localized:YES].uppercaseString;
    
    _session = session;
}

@end
