//
//  SCScheduleViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCScheduleViewController.h"
#import "SCEvent.h"
#import "SCSessionDetailsCollectionViewCell.h"
#import <MTCardLayout/UICollectionView+CardLayout.h>
#import "SelfConference-Swift.h"
#import "SCMenuViewController.h"
#import "SCSharedStoryboardInstances.h"
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import "SCSpeaker.h"
#import "UIAlertController+SCAlertController.h"

@interface SCScheduleViewController () <SCSessionDetailsCollectionViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SCMenuViewControllerDelegate>

/** 
 Stores the 'SCSession' instances that will be displayed in '_collectionView'. 
 It's possible that they are filtered, which is the reason we're storing them
 separately.
 */
@property (nonatomic) NSArray *sessions;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SCMenuViewController *menuViewController;

@end

@implementation SCScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor SC_teal];
    
    self.collectionView.cardLayoutPanGestureRecognizer.enabled = NO;
    self.collectionView.cardLayoutTapGestureRecognizer.enabled = NO;
    
    self.collectionView.backgroundView = self.menuViewController.view;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(openTwitterProfileForSpeakerWithNotification:)
     name:kSCSpeakerOpenTwitterProfileForSpeakerNotificationName
     object:nil];
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
#pragma mark - Overrides

- (void)refreshEventData {
    [super refreshEventData];
    
    self.sessions =
    [self.event sessionsWithSearchTerm:self.menuViewController.searchTerm
                                filter:self.menuViewController.filter];
    
    [self.collectionView reloadData];
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
     setStatusBarHidden:NO
     withAnimation:UIStatusBarAnimationSlide];
    
    SCSessionDetailsCollectionViewCell *cell =
    (SCSessionDetailsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.tableView.scrollEnabled = YES;
    
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

#pragma mark - SCSessionDetailsCollectionViewCellDelegate

- (void)sessionDetailsCollectionViewCellDidTapEmbeddedTableViewCell:(SCSessionDetailsCollectionViewCell *)cell {
    // If tapping on another card that is collapsed at the bottom of the screen,
    // '[self.collectionView indexPathForCell:cell];' returns some other cell.
    // This ensures we properly deselect the selected cell, if it exists.
    NSIndexPath *indexPath =
    self.collectionView.indexPathsForSelectedItems.firstObject ?:
    [self.collectionView indexPathForCell:cell];
    
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

- (void)sessionDetailsCollectionViewCellDidUpdateFavorite:(SCSessionDetailsCollectionViewCell *)cell {
    // If we're filtering on favorites only, and the user updated a favorite
    // setting, they probably unfavorited something. In that case, let's go
    // ahead and remove it from the list.
    if (self.menuViewController.filter == SCSessionFilterFavorites) {
        [self refreshEventData];
    }
}

- (void)sessionDetailsCollectionViewCell:(SCSessionDetailsCollectionViewCell *)cell
                    isSubmittingFeedback:(BOOL)isSubmittingFeedback {
    // Don't allow the user to expand cards while submitting feedback, but allow
    // them to interact with the feedback screen on the specific cell.
    for (UICollectionViewCell *visibleCell in self.collectionView.visibleCells) {
        if (visibleCell != cell) {
            visibleCell.userInteractionEnabled = !isSubmittingFeedback;
        }
    }
}

#pragma mark - SCMenuViewControllerDelegate

- (void)menuViewController:(SCMenuViewController *)menuViewController
             didSearchTerm:(NSString *)searchTerm
                withFilter:(SCSessionFilter)filter
         isImmediateSearch:(BOOL)isImmediateSearch {
    [self refreshEventData];
    
    // Expand the card list if it's an immediate search (i.e. the user pressed
    // the SEARCH button)
    if (isImmediateSearch) {
        [self.collectionView setPresenting:NO animated:YES completion:NULL];
    }
}

#pragma mark - NSNotificationCenter

- (void)openTwitterProfileForSpeakerWithNotification:(NSNotification *)notification {
    SCSpeaker *speaker = notification.object;
    
    [self presentViewController:[UIAlertController SC_alertControllerForOpenTwitterForSpeaker:speaker]
                       animated:YES
                     completion:NULL];
}

@end
