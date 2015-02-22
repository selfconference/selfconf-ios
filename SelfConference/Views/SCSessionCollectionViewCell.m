//
//  SCSessionCollectionViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionCollectionViewCell.h"
#import "SCSession.h"

@interface SCSessionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakersLabel;

@end

@implementation SCSessionCollectionViewCell

- (void)setSession:(SCSession *)session {
    self.nameLabel.text = session.name;
    self.detailsLabel.text = session.details;
    
    NSArray *speakerNames =
    [session.speakers valueForKey:NSStringFromSelector(@selector(name))];
    
    self.speakersLabel.text = [speakerNames componentsJoinedByString:@", "];
    
    _session = session;
}

@end
