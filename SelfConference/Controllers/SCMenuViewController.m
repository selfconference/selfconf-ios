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
#import "SCNameLabelHeaderView.h"
#import "SCEvent.h"
#import "SCSponsorLevel.h"
#import "UIAlertController+SCAlertController.h"
#import "SCSharedStoryboardInstances.h"
#import "SCCodeOfConductViewController.h"

@interface SCMenuViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *filtersSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL isImmediateSearch;

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
    self.isImmediateSearch = YES;
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isImmediateSearch = NO;
    self.endSearchTapGestureRecognizer.enabled = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.endSearchTapGestureRecognizer.enabled = NO;

    [self callDidSearchTermWithFilterDelegate];
}

#pragma mark - UISegmentedControl

- (IBAction)didChangeSegmentedControlValue:(UISegmentedControl *)segmentedControl {
    self.isImmediateSearch = YES;
    
    // Prevent a crash if the user is still editing the search bar and they
    // tap on a different segment index
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    else {
        [self callDidSearchTermWithFilterDelegate];
    }
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
                           withFilter:self.filter
                    isImmediateSearch:self.isImmediateSearch];
}

/** Returns the 'SCSponsorLevel' instance in the given 'section'. */
- (SCSponsorLevel *)sponsorLevelInSection:(NSInteger)section {
    return self.event.sponsorLevelsWithSponsorsSortedByOrder[section];
}

- (NSInteger)codeOfConductSection {
    return self.event.sponsorLevelsWithSponsorsSortedByOrder.count;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.event.sponsorLevelsWithSponsorsSortedByOrder.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection;
    
    if (section == self.codeOfConductSection) {
        numberOfItemsInSection = 1;
    }
    else {
        SCSponsorLevel *sponsorLevel =
        [self sponsorLevelInSection:section];
        
        numberOfItemsInSection = sponsorLevel.sponsorsSortedByName.count;
    }
    
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    NSInteger section = indexPath.section;
    
    if (section == self.codeOfConductSection) {
        cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:@"SCCodeOfConductCollectionViewCell"
                forIndexPath:indexPath];
    }
    else {
        SCSponsorCollectionViewCell *sponsorCollectionViewCell =
        (SCSponsorCollectionViewCell *)[collectionView
                                        dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCSponsorCollectionViewCell class])
                                        forIndexPath:indexPath];
        
        SCSponsorLevel *sponsorLevel =
        [self sponsorLevelInSection:section];
        
        sponsorCollectionViewCell.sponsor =
        sponsorLevel.sponsorsSortedByName[indexPath.row];
        
        cell = sponsorCollectionViewCell;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    SCNameLabelHeaderView *view =
    (SCNameLabelHeaderView *)[collectionView
                              dequeueReusableSupplementaryViewOfKind:kind
                              withReuseIdentifier:NSStringFromClass([SCNameLabelHeaderView class])
                              forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    
    NSString *nameLabelText;
    
    if (section == self.codeOfConductSection) {
        nameLabelText = @"Other";
    }
    else {
        SCSponsorLevel *sponsorLevel =
        [self sponsorLevelInSection:indexPath.section];
        
        nameLabelText =
        [sponsorLevel.name stringByAppendingString:@" sponsors"];
    }
    
    view.nameLabel.text = nameLabelText;
    
    return view;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewControllerToPresent;
    
    if (indexPath.section == self.codeOfConductSection) {
        viewControllerToPresent =
        [[SCSharedStoryboardInstances sharedMainStoryboardInstance]
         instantiateViewControllerWithIdentifier:NSStringFromClass([SCCodeOfConductViewController class])];
    }
    else {
        SCSponsorCollectionViewCell *cell =
        (SCSponsorCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        viewControllerToPresent =
        [UIAlertController SC_alertControllerForOpenLinkForSponsor:cell.sponsor];
    }
    
    [self presentViewController:viewControllerToPresent
                       animated:YES
                     completion:NULL];
}

@end
