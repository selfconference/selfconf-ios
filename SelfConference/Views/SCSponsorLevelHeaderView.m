//
//  SCSponsorLevelHeaderView.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSponsorLevelHeaderView.h"
#import "SCSponsorLevel.h"

@interface SCSponsorLevelHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SCSponsorLevelHeaderView

- (void)setSponsorLevel:(SCSponsorLevel *)sponsorLevel {
    self.nameLabel.text = [sponsorLevel.name stringByAppendingString:@" sponsors"];
    
    _sponsorLevel = sponsorLevel;
}

@end
