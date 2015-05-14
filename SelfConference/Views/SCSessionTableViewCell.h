//
//  SCSessionCollectionViewCell.h
//  SelfConference
//
//  Created by Jeff Burt on 2/22/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSession;

@interface SCSessionTableViewCell : UITableViewCell

/** Configures the cell for the given 'SCSession' instance */
@property (nonatomic) SCSession *session;

@end
