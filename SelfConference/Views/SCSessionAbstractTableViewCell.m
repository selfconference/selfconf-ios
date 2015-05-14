//
//  SCSessionAbstractTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionAbstractTableViewCell.h"
#import "SCSession.h"

@interface SCSessionAbstractTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;

@end

@implementation SCSessionAbstractTableViewCell

#pragma mark - Overrides

- (void)setSession:(SCSession *)session {
    self.abstractLabel.text = session.abstract;

    _session = session;
}

@end
