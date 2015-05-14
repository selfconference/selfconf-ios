//
//  SCScheduleViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCScheduleViewController.h"
#import "SCEvent.h"
#import <MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import "SCSessionDetailsCollectionViewCell.h"
#import "NSDictionary+SCManagedObject.h"
#import "NSSet+SCManagedObject.h"
#import <MTCardLayout/UICollectionView+CardLayout.h>
#import "UIColor+SCColor.h"

@interface SCScheduleViewController () <SCSessionDetailsCollectionViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) SCEvent *event;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation SCScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor SC_teal];
    
    self.event = [SCEvent currentEvent];

    self.collectionView.cardLayoutPanGestureRecognizer.enabled = NO;
    self.collectionView.cardLayoutTapGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(managedObjectContextObjectsDidChangeWithNotification:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object:[NSManagedObjectContext MR_defaultContext]];
}

- (void)setEvent:(SCEvent *)event {
    if (event != _event) {
        _event = event;
        
        [self refreshEventData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.event.sessionsArrangedByDay.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    if (self.event.sessionsArrangedByDay.count > 0) {
        count = [self.event.sessionsArrangedByDay[section] count];
    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSessionDetailsCollectionViewCell *cell =
    [collectionView
     dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCSessionDetailsCollectionViewCell class])
     forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // Disable scrolling by default, until it becomes exposed
    cell.tableView.userInteractionEnabled = NO;
    cell.tableView.scrollEnabled = NO;
    
    cell.session = self.event.sessionsArrangedByDay[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication]
     setStatusBarHidden:YES
     withAnimation:UIStatusBarAnimationSlide];
    
    SCSessionDetailsCollectionViewCell *cell =
    (SCSessionDetailsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.tableView.userInteractionEnabled = YES;
    cell.tableView.scrollEnabled = YES
    ;
    [self.collectionView setPresenting:YES animated:YES completion:NULL];
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication]
     setStatusBarHidden:NO
     withAnimation:UIStatusBarAnimationSlide];
    
    SCSessionDetailsCollectionViewCell *cell =
    (SCSessionDetailsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.tableView.userInteractionEnabled = NO;
    cell.tableView.scrollEnabled = NO;
    
    cell.tableView.contentOffset = CGPointZero;
}

#pragma mark - Other

/** Refreshes all data associated with '_event'. */
- (void)refreshEventData {
    [self.collectionView reloadData];
}

- (void)managedObjectContextObjectsDidChangeWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if ([userInfo.SC_insertedObjects SC_containsAtLeastOneObjectKindOfClass:[SCEvent class]]) {
        // It's possible that we got a new current event. Allow the overridden
        // setter to decide if it's new or not.
        self.event = [SCEvent currentEvent];
    }
    else if ([userInfo.SC_allChangedObjects containsObject:self.event]) {
        [self refreshEventData];
    }
}

#pragma mark - SCSessionDetailsCollectionViewCellDelegate

- (void)sessionDetailsCollectionViewCellShouldCollapse:(SCSessionDetailsCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    [self.collectionView.delegate collectionView:self.collectionView
                      didDeselectItemAtIndexPath:indexPath];
    
    [self.collectionView setPresenting:NO animated:YES completion:NULL];
}

@end
