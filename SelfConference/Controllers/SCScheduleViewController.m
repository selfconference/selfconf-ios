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
#import "SCMenuViewController.h"
#import "SCSharedStoryboardInstances.h"
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>

@interface SCScheduleViewController () <SCSessionDetailsCollectionViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SCMenuViewControllerDelegate>

@property (nonatomic) SCEvent *event;

/** 
 Stores the 'SCSession' instances that will be displayed in '_collectionView'. 
 It's possible that they are filtered. 
 */
@property (nonatomic) NSArray *sessions;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SCMenuViewController *menuViewController;

@end

@implementation SCScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor SC_teal];
    
    self.event = [SCEvent currentEvent];

    self.collectionView.cardLayoutPanGestureRecognizer.enabled = NO;
    self.collectionView.cardLayoutTapGestureRecognizer.enabled = NO;
    
    self.collectionView.backgroundView = self.menuViewController.view;
    
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

- (SCMenuViewController *)menuViewController {
    if (!_menuViewController) {
        _menuViewController =
        [[SCSharedStoryboardInstances sharedMainStoryboardInstance]
         instantiateViewControllerWithIdentifier:NSStringFromClass([SCMenuViewController class])];
        
        _menuViewController.delegate = self;
    }
    
    return _menuViewController;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSessionDetailsCollectionViewCell *cell =
    [collectionView
     dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCSessionDetailsCollectionViewCell class])
     forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // Disable scrolling by default, until it becomes exposed
    cell.tableView.scrollEnabled = NO;
    
    cell.session = self.sessions[indexPath.row];
    
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
    
    cell.tableView.scrollEnabled = NO;
    
    cell.tableView.contentOffset = CGPointZero;
}

#pragma mark - Other

/** Refreshes all data associated with '_event'. */
- (void)refreshEventData {
    self.sessions =
    [self.event sessionsWithSearchTerm:self.menuViewController.searchTerm
                                filter:self.menuViewController.filter];
    
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

- (void)sessionDetailsCollectionViewCellDidTapEmbeddedTableViewCell:(SCSessionDetailsCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    if (self.collectionView.presenting) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
        [self.collectionView.delegate collectionView:self.collectionView
                          didDeselectItemAtIndexPath:indexPath];
        
        [self.collectionView setPresenting:NO animated:YES completion:NULL];
    }
    else {
        [self.collectionView selectItemAtIndexPath:indexPath
                                          animated:NO
                                    scrollPosition:UICollectionViewScrollPositionNone];
        
        [self.collectionView.delegate collectionView:self.collectionView
                            didSelectItemAtIndexPath:indexPath];
    }
}

- (UICollectionViewLayoutAttributes *)collectionViewLayoutAttributesForSessionDetailsCollectionViewCell:(SCSessionDetailsCollectionViewCell *)cell {
    return [self.collectionView layoutAttributesForItemAtIndexPath:[self.collectionView indexPathForCell:cell]];
}

#pragma mark - SCMenuViewControllerDelegate

- (void)menuViewController:(SCMenuViewController *)menuViewController
             didSearchTerm:(NSString *)searchTerm
                withFilter:(SCSessionFilter)filter {
    [self refreshEventData];
}

@end
