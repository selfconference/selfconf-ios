//
//  SCMenuViewController.h
//  SelfConference
//
//  Created by Jeff Burt on 5/18/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCUpdatingEventBaseViewController.h"
#import "SCSession.h"

@protocol SCMenuViewControllerDelegate;

@interface SCMenuViewController : SCUpdatingEventBaseViewController

@property (nonatomic, weak) id<SCMenuViewControllerDelegate> delegate;

/** The current search term that lives inside the search bar */
@property (nonatomic, readonly) NSString *searchTerm;

/** The current filter that is selected on the segmented control */
@property (nonatomic, readonly) SCSessionFilter filter;

@end

@protocol SCMenuViewControllerDelegate <NSObject>

/** Called when a user searched for a term or changed a filter */
- (void)menuViewController:(SCMenuViewController *)menuViewController
             didSearchTerm:(NSString *)searchTerm
                withFilter:(SCSessionFilter)filter
         isImmediateSearch:(BOOL)isImmediateSearch;

@end

