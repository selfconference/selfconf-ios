//
//  SCSessionsInADayHeaderTableViewCell.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSessionsInADayHeaderTableViewCell : UITableViewCell

/** Configures 'self' with the given 'date'. */
- (void)configureWithDate:(NSDate *)date;

@end
