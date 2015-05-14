//
//  SCSessionDetailsTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionDetailsTableViewCell.h"
#import "SCSession.h"

@interface SCSessionDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation SCSessionDetailsTableViewCell

#pragma mark - Overrides

- (void)setSession:(SCSession *)session {
    self.detailsLabel.text = session.abstract;

    _session = session;
}

@end
