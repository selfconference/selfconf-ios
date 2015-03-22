//
//  SCSessionDetailsViewController.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSession;

/** Represents the details for a single 'SCSession' instance */
@interface SCSessionDetailsTableViewController : UITableViewController

/** The 'SCSession' instance that this view controller represents */
@property (nonatomic) SCSession *session;

@end
