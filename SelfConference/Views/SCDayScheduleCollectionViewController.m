//
//  SCDayScheduleCollectionViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCDayScheduleCollectionViewController.h"
#import "SCSession.h"
#import "SCSessionCollectionViewCell.h"

@interface SCDayScheduleCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/** An array of 'SCSession' instances */
@property (nonatomic) NSArray *sessions;

@end

@implementation SCDayScheduleCollectionViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadSessionsLocally)
     name:kSCSessionNotificationNameForInstancesWereUpdatedFromTheServer
     object:nil];
}

- (void)setStartOfDay:(NSDate *)startOfDay {
    _startOfDay = startOfDay;
    
    [self reloadSessionsLocally];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSessionCollectionViewCell *cell =
    [collectionView
     dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCSessionCollectionViewCell class])
     forIndexPath:indexPath];
    
    cell.session = self.sessions[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320.0f, 175.0f);
}

#pragma mark - Other

/** 
 Fetches all of the 'SCSession' instances for '_startOfDay', stores them, then 
 reloads '_collectionView'. 
 */
- (void)reloadSessionsLocally {
    [SCSession
     getLocalSessionsWithStartOfDay:self.startOfDay
     block:^(NSArray *sessions, NSError *error) {
         self.sessions = sessions;
         [self.collectionView reloadData];
     }];
}

@end
