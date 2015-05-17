//
//  SCSessionNameTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionNameTableViewCell.h"
#import "SCSession.h"

@interface SCSessionNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SCSessionNameTableViewCell

#pragma mark - Overrides

- (void)setSession:(SCSession *)session {
    self.nameLabel.text = session.name;
    
    _session = session;
}

@end
