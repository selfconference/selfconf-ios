//
//  SCScheduleViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCScheduleViewController.h"
#import "SCDayScheduleCollectionViewController.h"
#import "SCSharedStoryboardInstances.h"
#import <Parse/PFConfig.h>
#import "SCConfigStrings.h"
#import <MTDates/NSDate+MTDates.h>
#import "UIViewController+SCChildViewController.h"
#import "UIColor+SCColor.h"
#import "SCDaySelectionButton.h"
#import "NSDate+SCDate.h"

@interface SCScheduleViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

/**
 A container for '_pageViewController' that way we can constrain its position
 in the storyboard.
 */
@property (weak, nonatomic) IBOutlet UIView *pageViewControllerContainerView;

@property (nonatomic) UIPageViewController *pageViewController;

/** A collection of the view controllers that will exist in the specific order */
@property (nonatomic, strong) NSMutableArray *viewControllersToUse;

@property (weak, nonatomic) IBOutlet SCDaySelectionButton *firstDayButton;

@property (weak, nonatomic) IBOutlet SCDaySelectionButton *secondDayButton;

@end

@implementation SCScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    navigationBar.barTintColor = [UIColor SC_teal];
    
    navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self setDate:[NSDate SC_firstDayOfConference]
     forDayButton:self.firstDayButton];
    
    [self setDate:[NSDate SC_secondDayOfConference]
     forDayButton:self.secondDayButton];
    
    [self SC_addChildViewController:self.pageViewController
                        onTopOfView:self.pageViewControllerContainerView];
    
    [self scrollToViewControllerForSelectedDayAnimated:NO];
}

#pragma mark - Lazy loading

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController =
        [[UIPageViewController alloc]
         initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
         options:kNilOptions];
        
        _pageViewController.view.backgroundColor = [UIColor SC_teal];
        
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    
    return _pageViewController;
}

- (NSMutableArray *)viewControllersToUse {
    if (!_viewControllersToUse) {
        NSMutableArray *viewControllersToUse = [NSMutableArray array];
        
        // Day one
        [viewControllersToUse
         addObject:[self createSCDayScheduleCollectionViewControllerInstanceWithStartOfDay:[NSDate SC_firstDayOfConference]]];

        // Day two
        [viewControllersToUse
         addObject:[self createSCDayScheduleCollectionViewControllerInstanceWithStartOfDay:[NSDate SC_secondDayOfConference]]];
        
        _viewControllersToUse = viewControllersToUse;
    }
    
    return _viewControllersToUse;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *previousViewController;
    
    NSInteger previousIndex =
    [self.viewControllersToUse indexOfObject:viewController] - 1;
    
    if (self.viewControllersToUse.count > previousIndex && previousIndex >= 0) {
        previousViewController = self.viewControllersToUse[previousIndex];
    }
    
    return previousViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *nextViewController;
    
    NSInteger nextIndex = [self.viewControllersToUse indexOfObject:viewController] + 1;
    
    if (self.viewControllersToUse.count > nextIndex) {
        nextViewController = self.viewControllersToUse[nextIndex];
    }
    
    return nextViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        [self toggleSelectedDayButtonsAndScrollToRelatedViewController:NO];
    }
}

#pragma mark - UIButton actions

- (IBAction)didTapFirstDayButton:(SCDaySelectionButton *)button {
    if ([self shouldToggleSelectedDayButtonsWithDayButtonTap:button]) {
        [self toggleSelectedDayButtonsAndScrollToRelatedViewController:YES];
    }
}

- (IBAction)didTapSecondDayButton:(SCDaySelectionButton *)button {
    if ([self shouldToggleSelectedDayButtonsWithDayButtonTap:button]) {
        [self toggleSelectedDayButtonsAndScrollToRelatedViewController:YES];
    }
}

#pragma mark - Other

/** 
 Instantiates a new 'SCDayScheduleCollectionViewController' instance from 
 'Main.storyboard'.
 */
- (SCDayScheduleCollectionViewController *)createSCDayScheduleCollectionViewControllerInstanceWithStartOfDay:(NSDate *)startOfDay {
    NSString *dayScheduleTableViewControllerClassName =
    NSStringFromClass([SCDayScheduleCollectionViewController class]);
    
    SCDayScheduleCollectionViewController *dayScheduleCollectionViewController =
    [[SCSharedStoryboardInstances sharedMainStoryboardInstance]
     instantiateViewControllerWithIdentifier:dayScheduleTableViewControllerClassName];
    
    dayScheduleCollectionViewController.startOfDay = startOfDay;
    
    return dayScheduleCollectionViewController;
}

/** Sets the title on 'dayButton' to the name of the day. */
- (void)setDate:(NSDate *)date forDayButton:(SCDaySelectionButton *)dayButton {
    [dayButton
     setTitle:date.mt_stringFromDateWithFullWeekdayTitle.uppercaseString
     forState:UIControlStateNormal];
}

/** 
 Returns YES if the 'dayButton' that trigger all of the day buttons to be 
 toggled.
 */
- (BOOL)shouldToggleSelectedDayButtonsWithDayButtonTap:(SCDaySelectionButton *)dayButton {
    return !dayButton.selected;
}

/** 
 Switches the selected state for '_firstDayButton' and '_secondDayButton' and
 scrolls to the related view controller if desired.
 */
- (void)toggleSelectedDayButtonsAndScrollToRelatedViewController:(BOOL)shouldScrollToRelatedViewController {
    self.firstDayButton.selected = !self.firstDayButton.selected;
    self.secondDayButton.selected = !self.secondDayButton.selected;
    
    if (shouldScrollToRelatedViewController) {
        [self scrollToViewControllerForSelectedDayAnimated:YES];
    }
}

/**
 Scrolls to the page for the given selected day. To be called when the user taps 
 on one of the dayButton's.
 */
- (void)scrollToViewControllerForSelectedDayAnimated:(BOOL)shouldAnimate {
    UIViewController *pageForSelectedDayButton;
    UIPageViewControllerNavigationDirection scrollDirection;
    
    if (self.firstDayButton.isSelected) {
        pageForSelectedDayButton = self.viewControllersToUse.firstObject;
        scrollDirection = UIPageViewControllerNavigationDirectionReverse;
    }
    else {
        pageForSelectedDayButton = self.viewControllersToUse.lastObject;
        scrollDirection = UIPageViewControllerNavigationDirectionForward;
    }
    
    [self.pageViewController
     setViewControllers:@[pageForSelectedDayButton]
     direction:scrollDirection
     animated:shouldAnimate
     completion:NULL];
}

@end
