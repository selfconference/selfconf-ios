//
//  SCSchedulePageViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSchedulePageViewController.h"
#import "SCDayScheduleTableViewController.h"

@interface SCSchedulePageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

/** A collection of the view controllers that will exist in the specific order */
@property (nonatomic, strong) NSMutableArray *viewControllersToUse;

@end

@implementation SCSchedulePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self setViewControllers:@[self.viewControllersToUse.firstObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:NULL];
}

- (NSMutableArray *)viewControllersToUse {
    if (!_viewControllersToUse) {
        NSMutableArray *viewControllersToUse = [NSMutableArray array];
        
        // Day one
        [viewControllersToUse addObject:[SCDayScheduleTableViewController new]];

        // Day two
        [viewControllersToUse addObject:[SCDayScheduleTableViewController new]];
        
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

#pragma mark - UIPageViewControllerDataSource methods

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.viewControllersToUse.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return [self.viewControllersToUse indexOfObject:pageViewController.viewControllers.firstObject];
}

@end
