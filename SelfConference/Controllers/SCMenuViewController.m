//
//  SCMenuViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/18/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCMenuViewController.h"
#import "UIColor+SCColor.h"

@interface SCMenuViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *filtersSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) UITapGestureRecognizer *endSearchTapGestureRecognizer;

@end

@implementation SCMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor SC_teal];
    self.searchBar.tintColor = [UIColor whiteColor];
    
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
    NSLog(@"Got it");
    
    [self.delegate menuViewController:self
                        didSearchTerm:self.searchTerm
                           withFilter:self.filter];
}

@end
