//
//  SCSessionsInADayHeaderTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionsInADayHeaderTableViewCell.h"
#import "UIColor+SCColor.h"
#import <MTDates/NSDate+MTDates.h>

@interface SCSessionsInADayHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation SCSessionsInADayHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.flagView.backgroundColor = [UIColor SC_orange];
}

- (void)configureWithDate:(NSDate *)date {
    self.dayLabel.text = [date mt_stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
}

@end
