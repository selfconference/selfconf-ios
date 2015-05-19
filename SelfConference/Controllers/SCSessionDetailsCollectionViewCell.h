//
//  SCScheduleDetailsCollectionViewCell.h
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSession;
@protocol SCSessionDetailsCollectionViewCellDelegate;

@interface SCSessionDetailsCollectionViewCell : UICollectionViewCell

/** The 'SCSession' instance that this view controller represents */
@property (nonatomic) SCSession *session;

@property (nonatomic, weak) id<SCSessionDetailsCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@protocol SCSessionDetailsCollectionViewCellDelegate <NSObject>

/** Called when the cell is ready to be closed manually. */
- (void)sessionDetailsCollectionViewCellDidTapEmbeddedTableViewCell:(SCSessionDetailsCollectionViewCell *)cell;

- (UICollectionViewLayoutAttributes *)collectionViewLayoutAttributesForSessionDetailsCollectionViewCell:(SCSessionDetailsCollectionViewCell *)cell;

/** Called when the session is favorited or unfavorited. */
- (void)sessionDetailsCollectionViewCellDidUpdateFavorite:(SCSessionDetailsCollectionViewCell *)cell;

@end
