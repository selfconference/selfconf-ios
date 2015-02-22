//
//  SCDayScheduleCollectionViewController.h
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 Represents a single day full of sessions. The day is determined by 
 'startOfDay'. 
 */
@interface SCDayScheduleCollectionViewController : UICollectionViewController

/** Represents the beginning of the day in which this view controller represents */
@property (nonatomic) NSDate *startOfDay;

@end
