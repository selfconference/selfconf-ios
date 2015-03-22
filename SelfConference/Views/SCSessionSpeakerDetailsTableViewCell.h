//
//  SCSessionSpeakerDetailsTableViewCell.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSpeaker;

@interface SCSessionSpeakerDetailsTableViewCell : UITableViewCell

/** The 'SCSpeaker' instance that this cell represents */
@property (nonatomic) SCSpeaker *speaker;

@end
