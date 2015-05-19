//
//  SCMenuViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/18/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCMenuViewController.h"
#import "UIColor+SCColor.h"
#import "SCSponsorCollectionViewCell.h"
#import "SCSponsorLevelHeaderView.h"
#import "SCEvent.h"
#import "SCSponsorLevel.h"

@interface SCMenuViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *filtersSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) UITapGestureRecognizer *endSearchTapGestureRecognizer;

@end

@implementation SCMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor SC_teal];
    self.searchBar.tintColor = [UIColor whiteColor];
    
    UIEdgeInsets contentInset = UIEdgeInsetsMake(0, 0, 40.0f, 0);
    
    self.collectionView.contentInset = contentInset;
    self.collectionView.scrollIndicatorInsets = contentInset;
    
    [self.view addGestureRecognizer:self.endSearchTapGestureRecognizer];
}

- (NSString *)searchTerm {
    return self.searchBar.text;
}

- (SCSessionFilter)filter {
    return self.filtersSegmentedControl.selectedSegmentIndex;
}

- (UITapGestureRecognizer *)endSearchTapGestureRecognizer {
    if (!_endSearchTapGestureRecognizer) {
        _endSearchTapGestureRecognizer =
        [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(endSearchTapGestureRecognizerDidFire:)];
        
        // Disabled by default
        _endSearchTapGestureRecognizer.enabled = NO;
    }
    
    return _endSearchTapGestureRecognizer;
}

#pragma mark - Overrides 

- (void)refreshEventData {
    [super refreshEventData];
    
    [self.collectionView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.endSearchTapGestureRecognizer.enabled = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.endSearchTapGestureRecognizer.enabled = NO;

    [self callDidSearchTermWithFilterDelegate];
}

#pragma mark - UISegmentedControl

- (IBAction)didChangeSegmentedControlValue:(UISegmentedControl *)segmentedControl {
    [self callDidSearchTermWithFilterDelegate];
}

#pragma mark - UITapGestureRecognizer

/** Called when '_endSearchTapGestureRecognizer' fires */
- (void)endSearchTapGestureRecognizerDidFire:(UITapGestureRecognizer *)endSearchTapGestureRecognizer {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Other

/** 
 Calls 'menuViewController:didSearchTerm:withFilter' on '_delegate' with the 
 correct values. 
 */
- (void)callDidSearchTermWithFilterDelegate {
    [self.delegate menuViewController:self
                        didSearchTerm:self.searchTerm
                           withFilter:self.filter];
}

/** Returns the 'SCSponsorLevel' instance in the given 'section'. */
- (SCSponsorLevel *)sponsorLevelInSection:(NSInteger)section {
    return self.event.sponsorLevelsWithSponsorsSortedByOrder[section];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.event.sponsorLevelsWithSponsorsSortedByOrder.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    SCSponsorLevel *sponsorLevel =
    [self sponsorLevelInSection:section];
    
    return sponsorLevel.sponsorsSortedByName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSponsorCollectionViewCell *cell =
    (SCSponsorCollectionViewCell *)[collectionView
                                    dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCSponsorCollectionViewCell class])
                                    forIndexPath:indexPath];
    
    SCSponsorLevel *sponsorLevel =
    [self sponsorLevelInSection:indexPath.section];
    
    cell.sponsor = sponsorLevel.sponsorsSortedByName[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    SCSponsorLevelHeaderView *view =
    (SCSponsorLevelHeaderView *)[collectionView
                                 dequeueReusableSupplementaryViewOfKind:kind
                                 withReuseIdentifier:NSStringFromClass([SCSponsorLevelHeaderView class])
                                 forIndexPath:indexPath];
    
    view.sponsorLevel = [self sponsorLevelInSection:indexPath.section];
    
    return view;
}

@end
