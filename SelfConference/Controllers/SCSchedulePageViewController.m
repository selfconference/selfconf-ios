//
//  SCSchedulePageViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSchedulePageViewController.h"
#import "SCDayScheduleCollectionViewController.h"
#import "SCSharedStoryboardInstances.h"
#import <Parse/PFConfig.h>
#import "SCConfigStrings.h"
#import <MTDates/NSDate+MTDates.h>

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
        
        // Most likely returns 8:00 am EST
        NSDate *conferenceStartTime =
        [PFConfig currentConfig][SCConfigStrings.conferenceStartTime];
        
        NSDate *beginningOfDay1 = conferenceStartTime.mt_startOfCurrentDay;
        NSDate *beginningOfDay2 = [beginningOfDay1 mt_dateDaysAfter:1];
        
        // Day one
        [viewControllersToUse
         addObject:[self createSCDayScheduleCollectionViewControllerInstanceWithStartOfDay:beginningOfDay1]];

        // Day two
        [viewControllersToUse
         addObject:[self createSCDayScheduleCollectionViewControllerInstanceWithStartOfDay:beginningOfDay2]];
        
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

@end
