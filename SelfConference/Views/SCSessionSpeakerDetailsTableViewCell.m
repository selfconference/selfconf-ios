//
//  SCSessionSpeakerDetailsTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionSpeakerDetailsTableViewCell.h"
#import "SCSpeaker.h"
#import "UIColor+SCColor.h"
#import "UIView+SCUtilities.h"
#import "SCSession.h"

@interface SCSessionSpeakerDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;

@end

@implementation SCSessionSpeakerDetailsTableViewCell

- (void)setSession:(SCSession *)session {
    self.nameLabel.text = [NSString stringWithFormat:@"About %@",
                           session.joinedSpeakerNamesOrderedByName];
    
    SCSpeaker *oneSpeaker = session.speakers.anyObject;
    self.biographyLabel.text = oneSpeaker.biography;
    
    _session = session;
}

@end
