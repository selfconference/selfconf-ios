//
//  SCSessionNameTableViewCell.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSession;
@protocol SCSessionNameTableViewCellDelegate;

@interface SCSessionNameTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SCSessionNameTableViewCellDelegate> delegate;

/** The 'SCSession' instance that this cell represents */
@property (nonatomic) SCSession *session;

@end

@protocol SCSessionNameTableViewCellDelegate <NSObject>

/** Called when the session is favorited or unfavorited. */
- (void)sessionNameTableViewCellDidUpdateFavorite:(SCSessionNameTableViewCell *)cell;

@end
